-- CreateEnum
CREATE TYPE "VerificationStatus" AS ENUM ('UNVERIFIED', 'PENDING', 'VERIFIED', 'FAILED');

-- CreateEnum
CREATE TYPE "VerificationFailureReason" AS ENUM ('UNDERAGE', 'PROVIDER_REJECTED', 'EXPIRED');

-- AlterTable
ALTER TABLE "User" ADD COLUMN "verificationStatus" "VerificationStatus" NOT NULL DEFAULT 'UNVERIFIED';
ALTER TABLE "User" ADD COLUMN "verificationProvider" TEXT;
ALTER TABLE "User" ADD COLUMN "verificationProviderRef" TEXT;
ALTER TABLE "User" ADD COLUMN "verifiedAt" TIMESTAMP(3);
ALTER TABLE "User" ADD COLUMN "verificationFailureReason" "VerificationFailureReason";

-- CreateIndex
CREATE UNIQUE INDEX "User_verificationProviderRef_key" ON "User"("verificationProviderRef");

-- CreateIndex
CREATE INDEX "User_verificationStatus_idx" ON "User"("verificationStatus");
