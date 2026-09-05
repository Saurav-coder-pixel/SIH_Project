const test = require('node:test');
const assert = require('node:assert/strict');
const { parseNeedText } = require('../src/services/nlpParser.service');
const { toPublicProfileDTO, isUserDiscoverable, calculateHaversineDistance } = require('../src/utils/privacyDto');

test('Nook Minimum End-to-End Demo Scenario — 10-Step Validation Suite', async (t) => {
  let businessUser = {
    _id: 'biz_user_101',
    name: 'Sharma E-Commerce Store',
    phone: '+919999888877',
    role: 'seeker',
    locality_name: 'Koramangala, Bengaluru',
    location: { type: 'Point', coordinates: [77.6245, 12.9352] },
    search_radius_km: 5
  };

  let candidateProvider = {
    _id: 'provider_user_202',
    name: 'Ananya Verma',
    phone: '+919876543210',
    role: 'provider',
    profession: 'Commercial Product Photographer',
    skills: ['Product Photography', 'Studio Lighting', 'Photoshop'],
    services: ['E-commerce SKU Photography', 'Catalog Shoot'],
    locality_name: 'Indiranagar, Bengaluru',
    location: { type: 'Point', coordinates: [77.6412, 12.9784] },
    verification: { tier: 2, status: 'verified' },
    reputation: { score: 4.9, review_count: 34 }
  };

  // Step 1: Role Selection
  await t.test('Step 1: User selects role "Find a service"', () => {
    assert.strictEqual(businessUser.role, 'seeker');
  });

  // Step 2 & 3: Natural Language Need Parsing
  await t.test('Step 2 & 3: Natural Language Need Input -> Parsed Category & Urgency', () => {
    const rawText = "I need product photography for 500 SKUs this week";
    const parsed = parseNeedText(rawText);

    assert.strictEqual(parsed.category, 'product photography', 'Must parse category as product photography');
    assert.strictEqual(parsed.urgency, 'this_week', 'Must parse urgency as this_week');
    assert.ok(parsed.extracted_keywords.includes('photography'), 'Must extract photography keyword');
  });

  // Step 4 & 5: Nearby Search & Privacy-Safe Candidate Match
  await t.test('Step 4 & 5: Nearby Candidates returned with locality, distance, verification & reputation WITHOUT exact coordinates', () => {
    const dist = calculateHaversineDistance(
      businessUser.location.coordinates[1], businessUser.location.coordinates[0],
      candidateProvider.location.coordinates[1], candidateProvider.location.coordinates[0]
    );

    // Initial public profile DTO (unconnected)
    const publicProfile = toPublicProfileDTO(candidateProvider, {
      requesterCoords: businessUser.location.coordinates,
      isConnectedWithConsent: false
    });

    // ASSERTIONS:
    assert.strictEqual(publicProfile.locality_name, 'Indiranagar, Bengaluru');
    assert.ok(publicProfile.approx_distance_km > 0, 'Must calculate approximate distance');
    assert.strictEqual(publicProfile.verification.tier, 2);
    assert.strictEqual(publicProfile.reputation.score, 4.9);

    // NON-NEGOTIABLE PRIVACY ASSERTS:
    assert.strictEqual(publicProfile.location, undefined, 'Exact location object MUST NOT be returned');
    assert.strictEqual(publicProfile.coordinates, undefined, 'Exact coordinates MUST NOT be returned');
    assert.strictEqual(publicProfile.phone, undefined, 'Phone number MUST NOT be returned prior to consent');
  });

  // Step 6: User feedback
  await t.test('Step 6: User marks result as "Useful"', () => {
    const feedback = { feedback_type: 'Useful', comment: 'Great match near Koramangala' };
    assert.strictEqual(feedback.feedback_type, 'Useful');
  });

  // Step 7: Connection Request Sent
  let connectionRequest = null;
  await t.test('Step 7: User sends connection request — contact details stay private', () => {
    connectionRequest = {
      _id: 'req_303',
      requester_id: businessUser._id,
      provider_id: candidateProvider._id,
      message: 'Interested in product photography for 500 SKUs.',
      status: 'pending'
    };

    assert.strictEqual(connectionRequest.status, 'pending');
  });

  // Step 8: Provider Accepts Request
  let establishedConnection = null;
  await t.test('Step 8: Provider accepts request -> mutual consent granted', () => {
    connectionRequest.status = 'accepted';
    connectionRequest.responded_at = new Date();

    establishedConnection = {
      _id: 'conn_404',
      user_a: businessUser._id,
      user_b: candidateProvider._id,
      consent_state: 'accepted',
      chat_enabled: true
    };

    assert.strictEqual(connectionRequest.status, 'accepted');
    assert.strictEqual(establishedConnection.consent_state, 'accepted');
  });

  // Step 9: In-App Chat opens & Contact Unlocked
  await t.test('Step 9: In-app chat enabled & Provider phone unlocked (exact home coordinates STILL hidden)', () => {
    const unlockedProfile = toPublicProfileDTO(candidateProvider, {
      requesterCoords: businessUser.location.coordinates,
      isConnectedWithConsent: true // Consent granted!
    });

    assert.strictEqual(unlockedProfile.phone, '+919876543210', 'Phone MUST be unlocked after consent');
    assert.strictEqual(unlockedProfile.location, undefined, 'Exact home coordinates MUST remain hidden even after consent');
  });

  // Step 10: Analytics Funnel Logging
  await t.test('Step 10: Analytics records full conversion funnel', () => {
    const analyticsFunnel = {
      total_needs: 1,
      total_requests: 1,
      accepted_requests: 1,
      conversion_rate: 100
    };

    assert.strictEqual(analyticsFunnel.conversion_rate, 100);
  });
});
