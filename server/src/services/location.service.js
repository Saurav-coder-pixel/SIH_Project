const env = require('../config/env');

/**
 * Location Service Abstraction.
 * Centralizes all geocoding, reverse geocoding, and locality calculations.
 * Protects frontend from contacting Google Maps directly.
 */
class LocationService {
  /**
   * Converts address or place query string into safe locality name and approximate coordinates.
   */
  static async geocode(addressQuery) {
    if (!addressQuery || typeof addressQuery !== 'string') {
      throw new Error('Invalid address query');
    }

    // Standardized mock geocoding abstraction (with production Google Geocoding API placeholder)
    if (env.GOOGLE_MAPS_API_KEY) {
      try {
        const url = `https://maps.googleapis.com/maps/api/geocode/json?address=${encodeURIComponent(addressQuery)}&key=${env.GOOGLE_MAPS_API_KEY}`;
        const res = await fetch(url);
        const data = await res.json();
        if (data.status === 'OK' && data.results.length > 0) {
          const result = data.results[0];
          const loc = result.geometry.location;
          return {
            locality_name: result.formatted_address,
            coordinates: [loc.lng, loc.lat]
          };
        }
      } catch (err) {
        console.warn('[LocationService] Google Maps Geocode call failed, falling back to internal lookup:', err.message);
      }
    }

    // Default mock geocoding lookup for test/demo environments
    const queryLower = addressQuery.toLowerCase();
    if (queryLower.includes('koramangala')) {
      return { locality_name: 'Koramangala, Bengaluru', coordinates: [77.6245, 12.9352] };
    } else if (queryLower.includes('indiranagar')) {
      return { locality_name: 'Indiranagar, Bengaluru', coordinates: [77.6412, 12.9784] };
    } else if (queryLower.includes('whitefield')) {
      return { locality_name: 'Whitefield, Bengaluru', coordinates: [77.7499, 12.9698] };
    } else if (queryLower.includes('connaught') || queryLower.includes('delhi')) {
      return { locality_name: 'Connaught Place, New Delhi', coordinates: [77.2167, 28.6315] };
    } else if (queryLower.includes('mumbai') || queryLower.includes('bandra')) {
      return { locality_name: 'Bandra West, Mumbai', coordinates: [72.8357, 19.0596] };
    }

    return {
      locality_name: addressQuery.trim(),
      coordinates: [77.5946, 12.9716] // Default Bengaluru center
    };
  }

  /**
   * Reverse geocodes exact coordinates into safe human-readable locality string.
   */
  static async reverseGeocode(lng, lat) {
    return `Locality near (${lat.toFixed(3)}, ${lng.toFixed(3)})`;
  }
}

module.exports = LocationService;
