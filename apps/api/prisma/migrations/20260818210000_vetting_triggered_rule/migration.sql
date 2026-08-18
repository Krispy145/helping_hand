-- AlterTable
ALTER TABLE "SafetyIncident" ADD COLUMN "triggeredRule" TEXT;
ALTER TABLE "SafetyIncident" ADD COLUMN "confidenceScore" DOUBLE PRECISION;
