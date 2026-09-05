const User = require('../models/User');
const { toPublicProfileDTO, calculateHaversineDistance, isUserDiscoverable } = require('../utils/privacyDto');

/**
 * Hybrid Ranking & Nearby Candidate Search Engine.
 * Combines 2dsphere geospatial filtering, deterministic signals, and explainable scoring.
 */
class RankingService {
  /**
   * Finds nearby ranked candidates for a given Need object.
   *
   * @param {Object} need - Need model document
   * @param {Object} [options]
   * @param {number} [options.overrideRadiusKm] - User-selected search radius override
   * @returns {Object} { candidates, metadata }
   */
  static async findMatchesForNeed(need, options = {}) {
    const needCoords = need.location.coordinates; // [lng, lat]
    const initialRadius = options.overrideRadiusKm || need.radius_km || 5;

    let searchRadiusKm = initialRadius;
    let candidatesFound = [];
    let autoExpanded = false;

    // Search loops with auto-radius expansion if 0 results found
    const radiusSteps = [initialRadius, Math.max(initialRadius * 2, 15), 50];

    for (const radiusStep of radiusSteps) {
      searchRadiusKm = radiusStep;
      
      // Mongoose 2dsphere geospatial query
      // $near / $geoWithin or Haversine filtering over candidates
      const rawCandidates = await User.find({
        status: 'active',
        role: { $in: ['provider', 'both'] },
        _id: { $ne: need.requester_id }, // Exclude self
        location: {
          $near: {
            $geometry: {
              type: 'Point',
              coordinates: needCoords
            },
            $maxDistance: searchRadiusKm * 1000 // meters
          }
        }
      });

      // Apply HARD filters:
      // 1. Regulated profession Tier 3 check
      // 2. Category / Skill keyword relevance
      const filtered = rawCandidates.filter(c => isUserDiscoverable(c));

      if (filtered.length > 0) {
        candidatesFound = filtered;
        if (searchRadiusKm > initialRadius) {
          autoExpanded = true;
        }
        break;
      }
    }

    // If still empty, query all discoverable providers to ensure fallback
    if (candidatesFound.length === 0) {
      const allProviders = await User.find({
        status: 'active',
        role: { $in: ['provider', 'both'] },
        _id: { $ne: need.requester_id }
      });
      candidatesFound = allProviders.filter(c => isUserDiscoverable(c));
      autoExpanded = true;
    }

    // Rank candidates deterministically
    const targetCategory = (need.parsed_need.category || '').toLowerCase();
    const keywords = need.parsed_need.extracted_keywords || [];

    const rankedList = candidatesFound.map(candidate => {
      const cObj = typeof candidate.toObject === 'function' ? candidate.toObject() : candidate;
      const [cLng, cLat] = cObj.location.coordinates;
      const [nLng, nLat] = needCoords;

      const distKm = calculateHaversineDistance(nLat, nLng, cLat, cLng) || 0;

      // Score components (Total = 100 points max)
      let relevanceScore = 20; // Base score
      const explanationTags = [];

      // 1. Category / Skill match score (up to 40 pts)
      const candSkillsStr = [...(cObj.skills || []), ...(cObj.services || []), cObj.profession || ''].join(' ').toLowerCase();
      
      if (candSkillsStr.includes(targetCategory)) {
        relevanceScore += 40;
        explanationTags.push(`Exact Category Match (${need.parsed_need.category})`);
      } else {
        const matchingKw = keywords.filter(kw => candSkillsStr.includes(kw));
        if (matchingKw.length > 0) {
          const kwScore = Math.min(matchingKw.length * 10, 30);
          relevanceScore += kwScore;
          explanationTags.push(`Matching Skills: ${matchingKw.join(', ')}`);
        }
      }

      // 2. Distance score (up to 25 pts)
      if (distKm <= 2) {
        relevanceScore += 25;
        explanationTags.push(`Very Close (${distKm} km away)`);
      } else if (distKm <= 5) {
        relevanceScore += 20;
        explanationTags.push(`Nearby (${distKm} km away)`);
      } else if (distKm <= 15) {
        relevanceScore += 10;
        explanationTags.push(`Within Area (${distKm} km away)`);
      } else {
        relevanceScore += 5;
        explanationTags.push(`Extended Radius (${distKm} km away)`);
      }

      // 3. Verification Tier bonus (up to 15 pts)
      const tier = cObj.verification ? cObj.verification.tier : 1;
      if (tier === 3) {
        relevanceScore += 15;
        explanationTags.push('Tier 3 Regulated & Verified Professional');
      } else if (tier === 2) {
        relevanceScore += 10;
        explanationTags.push('Tier 2 Verified Provider Badge');
      } else {
        relevanceScore += 5;
        explanationTags.push('Tier 1 Verified Phone User');
      }

      // 4. Reputation score (up to 10 pts)
      const rating = cObj.reputation ? cObj.reputation.score : 5.0;
      if (rating >= 4.5) {
        relevanceScore += 10;
        explanationTags.push(`Top Rated (${rating} ★)`);
      } else {
        relevanceScore += Math.round(rating * 2);
      }

      // Clamp score to 99% max
      const finalPercentageScore = Math.min(Math.round(relevanceScore), 99);

      // Convert candidate model to privacy-safe public profile DTO
      const publicDto = toPublicProfileDTO(candidate, {
        requesterCoords: needCoords,
        isConnectedWithConsent: false
      });

      return {
        candidate: publicDto,
        match_score: finalPercentageScore,
        approx_distance_km: distKm,
        explanation_tags: explanationTags
      };
    });

    // Sort descending by match_score, then ascending by distance
    rankedList.sort((a, b) => {
      if (b.match_score !== a.match_score) {
        return b.match_score - a.match_score;
      }
      return a.approx_distance_km - b.approx_distance_km;
    });

    return {
      results: rankedList,
      metadata: {
        total_candidates: rankedList.length,
        search_radius_km: searchRadiusKm,
        initial_radius_km: initialRadius,
        auto_expanded: autoExpanded,
        expansion_notice: autoExpanded ? `No matches found within ${initialRadius}km. Expanded search radius to ${searchRadiusKm}km.` : null
      }
    };
  }
}

module.exports = RankingService;
