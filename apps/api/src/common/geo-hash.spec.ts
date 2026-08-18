import {
  approximateLocation,
  DISCOVERY_GEOHASH_PRECISION,
  encodeGeohash,
  geohashCenter,
} from './geo-hash';

describe('geo-hash', () => {
  it('encodes a stable neighborhood cell', () => {
    const capeTown = encodeGeohash(-33.9249, 18.4241);
    expect(capeTown).toHaveLength(DISCOVERY_GEOHASH_PRECISION);
    expect(encodeGeohash(-33.9249, 18.4241)).toBe(capeTown);
  });

  it('keeps points ~100m apart in the same cell and km-apart points in different cells', () => {
    const a = encodeGeohash(-33.9249, 18.4241);
    const nearby = encodeGeohash(-33.9249 + 0.0008, 18.4241);
    const acrossTown = encodeGeohash(-33.9249 + 0.04, 18.4241);
    expect(nearby).toBe(a);
    expect(acrossTown).not.toBe(a);
  });

  it('decode center stays inside the original cell', () => {
    const hash = encodeGeohash(-26.2041, 28.0473);
    const center = geohashCenter(hash);
    expect(encodeGeohash(center.lat, center.lng)).toBe(hash);
  });

  it('approximateLocation never returns the precise input', () => {
    const lat = -33.9249123;
    const lng = 18.4241456;
    const approx = approximateLocation(lat, lng);
    expect(approx.approxLat).not.toBe(lat);
    expect(approx.approxLng).not.toBe(lng);
    expect(approx.geoHashApprox).toHaveLength(DISCOVERY_GEOHASH_PRECISION);
  });
});
