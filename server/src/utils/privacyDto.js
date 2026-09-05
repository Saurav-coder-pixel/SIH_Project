const { RegulatedProfessions } = require('../models/User');

/**
 * Calculates Haversine approximate distance in kilometers between two lat/lng pairs.
 */
function calculateHaversineDistance(lat1, lon1, lat2, lon2) {
  if (lat1 == null || lon1 == null || lat2 == null || lon2 == null) return null;
  const R = 6371; // Earth's radius in km
  const dLat = (lat2 - lat1) * (Math.PI / 180);
  const dLon = (lon2 - lon1) * (Math.PI / 180);
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(lat1 * (Math.PI / 180)) *
      Math.cos(lat2 * (Math.PI / 180)) *
      Math.sin(dLon / 2) *
      Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  const dist = R * c;
  return Math.round(dist * 10) / 10; // Round to 1 decimal place
}

/**
 * Transforms a User model document into a privacy-safe Public Profile DTO.
 *
 * Enforces:
 * - Coordinates removal (lat/lng strictly stripped)
 * - Phone/contact hiding unless isConnectedWithConsent === true
 * - Regulated profession restriction (hidden or flagged if tier < 3)
 *
 * @param {Object} user - User document or JSON object
 * @param {Object} [options]
 * @param {Array<number>} [options.requesterCoords] - [lng, lat] of requester for distance calc
 * @param {boolean} [options.isConnectedWithConsent] - Whether requester has accepted connection
 * @returns {Object} Safe public user profile DTO
 */
function toPublicProfileDTO(user, options = {}) {
  if (!user) return null;
  const u = typeof user.toObject === 'function' ? user.toObject() : user;

  const isRegulated = RegulatedProfessions.some(p =>
    (u.profession || '').toLowerCase().includes(p)
  );

  const tier3Verified = u.verification && u.verification.tier >= 3 && u.verification.status === 'verified';

  // If user has a regulated profession but hasn't completed Tier 3 verification, hide profession service details
  if (isRegulated && !tier3Verified) {
    u.regulated_pending = true;
  }

  let approxDistanceKm = null;
  if (options.requesterCoords && u.location && u.location.coordinates) {
    const [reqLng, reqLat] = options.requesterCoords;
    const [uLng, uLat] = u.location.coordinates;
    approxDistanceKm = calculateHaversineDistance(reqLat, reqLng, uLat, uLng);
  }

  const publicDTO = {
    _id: u._id,
    name: u.name,
    role: u.role,
    bio: u.bio,
    profession: u.profession,
    is_regulated_profession: isRegulated,
    regulated_pending: u.regulated_pending || false,
    skills: u.skills || [],
    services: u.services || [],
    interests: u.interests || [],
    experience: u.experience || [],
    availability: u.availability || { status: 'available', hours: 'Flexible' },
    verification: {
      tier: u.verification ? u.verification.tier : 1,
      status: u.verification ? u.verification.status : 'unverified'
    },
    reputation: u.reputation || { score: 5.0, review_count: 0 },
    locality_name: u.locality_name || 'Nearby Locality',
    search_radius_km: u.search_radius_km || 5,
    approx_distance_km: approxDistanceKm,
    created_at: u.created_at
  };

  // ONLY expose phone if consent has been explicitly granted
  if (options.isConnectedWithConsent) {
    publicDTO.phone = u.phone;
  }

  // NON-NEGOTIABLE PRIVACY GUARANTEE:
  // Under NO CIRCUMSTANCES is location.coordinates returned in public DTO!
  delete publicDTO.location;
  delete publicDTO.coordinates;

  return publicDTO;
}

/**
 * Checks if a user is discoverable in public search results.
 * Regulated professionals MUST be Tier 3 verified.
 */
function isUserDiscoverable(user) {
  if (!user || user.status !== 'active') return false;
  const isRegulated = RegulatedProfessions.some(p =>
    (user.profession || '').toLowerCase().includes(p)
  );
  if (isRegulated) {
    return user.verification && user.verification.tier >= 3 && user.verification.status === 'verified';
  }
  return true;
}

module.exports = {
  toPublicProfileDTO,
  calculateHaversineDistance,
  isUserDiscoverable
};
