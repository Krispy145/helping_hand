import { toPublicRequest } from './public-serializers';

describe('toPublicRequest', () => {
  it('returns approximate coordinates and never the precise lat/lng', () => {
    const createdAt = new Date('2026-08-18T10:00:00Z');
    const publicRequest = toPublicRequest({
      id: 'req-1',
      title: 'Need a grocery run',
      description: 'A few essentials from a nearby shop.',
      category: 'groceries',
      status: 'APPROVED',
      urgency: 'MEDIUM',
      lat: -33.9249123,
      lng: 18.4241456,
      approxLat: -33.923,
      approxLng: 18.425,
      createdAt,
      updatedAt: createdAt,
    });

    expect(publicRequest.lat).toBe(-33.923);
    expect(publicRequest.lng).toBe(18.425);
    expect(publicRequest.lat).not.toBe(-33.9249123);
    expect(publicRequest.lng).not.toBe(18.4241456);
  });
});
