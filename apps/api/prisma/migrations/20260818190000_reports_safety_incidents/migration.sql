-- AlterEnum
ALTER TYPE "SessionStatus" ADD VALUE 'DISPUTED';

-- CreateEnum
CREATE TYPE "ReportType" AS ENUM ('HELPER_MISCONDUCT', 'HELPEE_MISUSE', 'SCAM', 'THEFT', 'UNSAFE_SITUATION');

-- CreateEnum
CREATE TYPE "ReportSeverity" AS ENUM ('LOW', 'MEDIUM', 'HIGH');

-- CreateEnum
CREATE TYPE "ReportStatus" AS ENUM ('NEW', 'TRIAGED', 'ACTIONED', 'REJECTED');

-- CreateEnum
CREATE TYPE "SafetyIncidentSource" AS ENUM ('REQUEST_VETTING', 'RATE_LIMIT', 'REPORT_PATTERN');

-- CreateTable
CREATE TABLE "Report" (
    "id" TEXT NOT NULL,
    "reporterId" TEXT NOT NULL,
    "targetUserId" TEXT,
    "sessionId" TEXT,
    "requestId" TEXT,
    "type" "ReportType" NOT NULL,
    "severity" "ReportSeverity" NOT NULL DEFAULT 'MEDIUM',
    "description" TEXT NOT NULL,
    "evidenceUrls" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "status" "ReportStatus" NOT NULL DEFAULT 'NEW',
    "sessionEnded" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Report_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SafetyIncident" (
    "id" TEXT NOT NULL,
    "userId" TEXT,
    "source" "SafetyIncidentSource" NOT NULL,
    "reasonCode" TEXT NOT NULL,
    "detailsRedacted" TEXT,
    "reportId" TEXT,
    "requestId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "SafetyIncident_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "Report_reporterId_createdAt_idx" ON "Report"("reporterId", "createdAt");

-- CreateIndex
CREATE INDEX "Report_targetUserId_idx" ON "Report"("targetUserId");

-- CreateIndex
CREATE INDEX "Report_status_idx" ON "Report"("status");

-- CreateIndex
CREATE UNIQUE INDEX "Report_reporterId_sessionId_key" ON "Report"("reporterId", "sessionId") WHERE "sessionId" IS NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "Report_reporterId_requestId_key" ON "Report"("reporterId", "requestId") WHERE "sessionId" IS NULL AND "requestId" IS NOT NULL;

-- CreateIndex
CREATE INDEX "SafetyIncident_userId_createdAt_idx" ON "SafetyIncident"("userId", "createdAt");

-- CreateIndex
CREATE INDEX "SafetyIncident_source_idx" ON "SafetyIncident"("source");

-- AddForeignKey
ALTER TABLE "Report" ADD CONSTRAINT "Report_reporterId_fkey" FOREIGN KEY ("reporterId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Report" ADD CONSTRAINT "Report_targetUserId_fkey" FOREIGN KEY ("targetUserId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Report" ADD CONSTRAINT "Report_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "Session"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Report" ADD CONSTRAINT "Report_requestId_fkey" FOREIGN KEY ("requestId") REFERENCES "Request"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SafetyIncident" ADD CONSTRAINT "SafetyIncident_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SafetyIncident" ADD CONSTRAINT "SafetyIncident_reportId_fkey" FOREIGN KEY ("reportId") REFERENCES "Report"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SafetyIncident" ADD CONSTRAINT "SafetyIncident_requestId_fkey" FOREIGN KEY ("requestId") REFERENCES "Request"("id") ON DELETE SET NULL ON UPDATE CASCADE;
