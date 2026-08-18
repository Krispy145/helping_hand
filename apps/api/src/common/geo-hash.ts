/** Neighborhood-scale cell (~1.2km × 0.6km). Used for helper discovery. */
export const DISCOVERY_GEOHASH_PRECISION = 6;

const BASE32 = '0123456789bcdefghjkmnpqrstuvwxyz';

export function encodeGeohash(
  lat: number,
  lng: number,
  precision = DISCOVERY_GEOHASH_PRECISION,
): string {
  let minLat = -90;
  let maxLat = 90;
  let minLng = -180;
  let maxLng = 180;
  let hash = '';
  let bit = 0;
  let ch = 0;
  let lngBit = true;

  while (hash.length < precision) {
    if (lngBit) {
      const mid = (minLng + maxLng) / 2;
      if (lng >= mid) {
        ch = (ch << 1) + 1;
        minLng = mid;
      } else {
        ch <<= 1;
        maxLng = mid;
      }
    } else {
      const mid = (minLat + maxLat) / 2;
      if (lat >= mid) {
        ch = (ch << 1) + 1;
        minLat = mid;
      } else {
        ch <<= 1;
        maxLat = mid;
      }
    }
    lngBit = !lngBit;
    bit += 1;
    if (bit === 5) {
      hash += BASE32[ch];
      bit = 0;
      ch = 0;
    }
  }

  return hash;
}

export function geohashBounds(hash: string): {
  minLat: number;
  maxLat: number;
  minLng: number;
  maxLng: number;
} {
  let minLat = -90;
  let maxLat = 90;
  let minLng = -180;
  let maxLng = 180;
  let lngBit = true;

  for (const character of hash) {
    const index = BASE32.indexOf(character);
    if (index < 0) {
      throw new Error(`Invalid geohash character: ${character}`);
    }
    for (let mask = 16; mask > 0; mask >>= 1) {
      if (lngBit) {
        const mid = (minLng + maxLng) / 2;
        if ((index & mask) !== 0) minLng = mid;
        else maxLng = mid;
      } else {
        const mid = (minLat + maxLat) / 2;
        if ((index & mask) !== 0) minLat = mid;
        else maxLat = mid;
      }
      lngBit = !lngBit;
    }
  }

  return { minLat, maxLat, minLng, maxLng };
}

export function geohashCenter(hash: string): { lat: number; lng: number } {
  const bounds = geohashBounds(hash);
  return {
    lat: (bounds.minLat + bounds.maxLat) / 2,
    lng: (bounds.minLng + bounds.maxLng) / 2,
  };
}

export function approximateLocation(
  lat: number,
  lng: number,
): {
  geoHashApprox: string;
  approxLat: number;
  approxLng: number;
} {
  const geoHashApprox = encodeGeohash(lat, lng);
  const center = geohashCenter(geoHashApprox);
  return {
    geoHashApprox,
    approxLat: center.lat,
    approxLng: center.lng,
  };
}
