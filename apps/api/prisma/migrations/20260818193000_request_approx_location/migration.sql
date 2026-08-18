-- AlterTable
ALTER TABLE "Request" ADD COLUMN "geoHashApprox" TEXT;
ALTER TABLE "Request" ADD COLUMN "approxLat" DOUBLE PRECISION;
ALTER TABLE "Request" ADD COLUMN "approxLng" DOUBLE PRECISION;

-- Coarse snap for existing rows (~1km). New writes use geohash cell centers.
UPDATE "Request"
SET
  "approxLat" = ROUND(("lat")::numeric, 2)::double precision,
  "approxLng" = ROUND(("lng")::numeric, 2)::double precision
WHERE "lat" IS NOT NULL AND "lng" IS NOT NULL;

-- CreateIndex
CREATE INDEX "Request_approxLat_approxLng_idx" ON "Request"("approxLat", "approxLng");

-- CreateIndex
CREATE INDEX "Request_geoHashApprox_idx" ON "Request"("geoHashApprox");
