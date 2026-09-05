const test = require('node:test');
const assert = require('node:assert/strict');
const express = require('express');
const { toPublicProfileDTO, isUserDiscoverable, calculateHaversineDistance } = require('../src/utils/privacyDto');
const LocationService = require('../src/services/location.service');

test('Nook P0 Suite — Privacy DTO & Haversine Distance', async (t) => {
  await t.test('calculateHaversineDistance computes accurate distance in km', () => {
    // Distance between Bengaluru Center (12.9716, 77.5946) and Koramangala (12.9352, 77.6245) is ~5.3 km
    const dist = calculateHaversineDistance(12.9716, 77.5946, 12.9352, 77.6245);
    assert.ok(dist > 4.5 && dist < 6.0, `Expected distance ~5.3km, got ${dist}km`);
  });

  await t.test('toPublicProfileDTO NEVER exposes location.coordinates or raw phone without consent', () => {
    const mockUser = {
      _id: 'user123',
      name: 'Rohan Sharma',
      phone: '+919876543210',
      role: 'provider',
      profession: 'Product Photographer',
      skills: ['Photography', 'Editing'],
      location: {
        type: 'Point',
        coordinates: [77.6245, 12.9352]
      },
      locality_name: 'Koramangala, Bengaluru',
      verification: { tier: 2, status: 'verified' }
    };

    const publicDTO = toPublicProfileDTO(mockUser, {
      requesterCoords: [77.5946, 12.9716],
      isConnectedWithConsent: false
    });

    // PRIVACY ASSERTIONS:
    assert.strictEqual(publicDTO.location, undefined, 'CRITICAL: location object MUST be stripped from public DTO');
    assert.strictEqual(publicDTO.coordinates, undefined, 'CRITICAL: coordinates MUST be stripped from public DTO');
    assert.strictEqual(publicDTO.phone, undefined, 'CRITICAL: phone number MUST be hidden without consent');
    assert.strictEqual(publicDTO.locality_name, 'Koramangala, Bengaluru');
    assert.ok(typeof publicDTO.approx_distance_km === 'number');
  });

  await t.test('toPublicProfileDTO exposes phone ONLY when isConnectedWithConsent is true', () => {
    const mockUser = {
      _id: 'user123',
      name: 'Rohan Sharma',
      phone: '+919876543210',
      locality_name: 'Koramangala, Bengaluru'
    };

    const publicDTO = toPublicProfileDTO(mockUser, {
      isConnectedWithConsent: true
    });

    assert.strictEqual(publicDTO.phone, '+919876543210');
  });

  await t.test('isUserDiscoverable enforces Tier 3 verification for regulated professions', () => {
    const doctorUnverified = {
      status: 'active',
      profession: 'Cardiologist Doctor',
      verification: { tier: 1, status: 'verified' }
    };

    const doctorVerifiedTier3 = {
      status: 'active',
      profession: 'Doctor',
      verification: { tier: 3, status: 'verified' }
    };

    const electricianTier1 = {
      status: 'active',
      profession: 'Electrician',
      verification: { tier: 1, status: 'verified' }
    };

    assert.strictEqual(isUserDiscoverable(doctorUnverified), false, 'Regulated doctor without Tier 3 must NOT be discoverable');
    assert.strictEqual(isUserDiscoverable(doctorVerifiedTier3), true, 'Regulated doctor with Tier 3 MUST be discoverable');
    assert.strictEqual(isUserDiscoverable(electricianTier1), true, 'Unregulated electrician with Tier 1 is discoverable');
  });
});

test('Nook P0 Suite — Location Abstraction Service', async (t) => {
  await t.test('Geocodes query string into locality name and coordinates', async () => {
    const res = await LocationService.geocode('Koramangala');
    assert.strictEqual(res.locality_name, 'Koramangala, Bengaluru');
    assert.deepStrictEqual(res.coordinates, [77.6245, 12.9352]);
  });
});
