-- AlterEnum
ALTER TYPE "VerificationStatus" ADD VALUE 'REQUIRES_DOCUMENT';

-- AlterTable
ALTER TABLE "User" ADD COLUMN "ageThreshold" INTEGER;

-- CreateTable
CREATE TABLE "AgeVerificationAttempt" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "provider" TEXT NOT NULL,
    "providerSessionId" TEXT NOT NULL,
    "status" "VerificationStatus" NOT NULL DEFAULT 'PENDING',
    "ageThreshold" INTEGER NOT NULL,
    "method" TEXT,
    "failureReason" "VerificationFailureReason",
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "verifiedAt" TIMESTAMP(3),
    "expiresAt" TIMESTAMP(3),

    CONSTRAINT "AgeVerificationAttempt_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AgeVerificationNotification" (
    "id" TEXT NOT NULL,
    "attemptId" TEXT NOT NULL,
    "state" TEXT NOT NULL,
    "processedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AgeVerificationNotification_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "AgeVerificationAttempt_providerSessionId_key" ON "AgeVerificationAttempt"("providerSessionId");

-- CreateIndex
CREATE INDEX "AgeVerificationAttempt_userId_createdAt_idx" ON "AgeVerificationAttempt"("userId", "createdAt");

-- CreateIndex
CREATE INDEX "AgeVerificationAttempt_status_idx" ON "AgeVerificationAttempt"("status");

-- AddForeignKey
ALTER TABLE "AgeVerificationAttempt" ADD CONSTRAINT "AgeVerificationAttempt_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AgeVerificationNotification" ADD CONSTRAINT "AgeVerificationNotification_attemptId_fkey" FOREIGN KEY ("attemptId") REFERENCES "AgeVerificationAttempt"("id") ON DELETE CASCADE ON UPDATE CASCADE;
