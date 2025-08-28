/*
  Warnings:

  - You are about to drop the column `email` on the `tour_group_guides` table. All the data in the column will be lost.
  - You are about to drop the column `fullName` on the `tour_group_guides` table. All the data in the column will be lost.
  - You are about to drop the column `phone` on the `tour_group_guides` table. All the data in the column will be lost.
  - You are about to drop the column `email` on the `tour_group_participants` table. All the data in the column will be lost.
  - You are about to alter the column `fullName` on the `tour_group_participants` table. The data in that column could be lost. The data in that column will be cast from `VarChar(255)` to `VarChar(100)`.
  - You are about to drop the column `email` on the `users` table. All the data in the column will be lost.
  - You are about to drop the column `username` on the `users` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[phone]` on the table `users` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `fullName` to the `tour_group_guide_assignments` table without a default value. This is not possible if the table is not empty.
  - Added the required column `phone` to the `tour_group_guide_assignments` table without a default value. This is not possible if the table is not empty.
  - Added the required column `gender` to the `tour_group_participants` table without a default value. This is not possible if the table is not empty.
  - Added the required column `idCardNumber` to the `tour_group_participants` table without a default value. This is not possible if the table is not empty.
  - Added the required column `idCardType` to the `tour_group_participants` table without a default value. This is not possible if the table is not empty.
  - Made the column `dateOfBirth` on table `tour_group_participants` required. This step will fail if there are existing NULL values in that column.
  - Made the column `fullName` on table `users` required. This step will fail if there are existing NULL values in that column.
  - Made the column `phone` on table `users` required. This step will fail if there are existing NULL values in that column.

*/
-- CreateEnum
CREATE TYPE "public"."UserStatus" AS ENUM ('ACTIVE', 'DISABLED', 'DELETED');

-- DropIndex
DROP INDEX "public"."tour_group_photos_uploaderType_uploaderId_idx";

-- DropIndex
DROP INDEX "public"."users_email_key";

-- DropIndex
DROP INDEX "public"."users_username_key";

-- AlterTable
ALTER TABLE "public"."tour_group_guide_assignments" ADD COLUMN     "fullName" VARCHAR(100) NOT NULL,
ADD COLUMN     "phone" VARCHAR(30) NOT NULL;

-- AlterTable
ALTER TABLE "public"."tour_group_guides" DROP COLUMN "email",
DROP COLUMN "fullName",
DROP COLUMN "phone";

-- AlterTable
ALTER TABLE "public"."tour_group_participants" DROP COLUMN "email",
ADD COLUMN     "gender" "public"."Gender" NOT NULL,
ADD COLUMN     "idCardNumber" VARCHAR(255) NOT NULL,
ADD COLUMN     "idCardType" "public"."IdCardType" NOT NULL,
ALTER COLUMN "fullName" SET DATA TYPE VARCHAR(100),
ALTER COLUMN "dateOfBirth" SET NOT NULL;

-- AlterTable
ALTER TABLE "public"."users" DROP COLUMN "email",
DROP COLUMN "username",
ADD COLUMN     "status" "public"."UserStatus" NOT NULL DEFAULT 'ACTIVE',
ALTER COLUMN "passwordHash" DROP NOT NULL,
ALTER COLUMN "fullName" SET NOT NULL,
ALTER COLUMN "phone" SET NOT NULL;

-- CreateIndex
CREATE INDEX "tour_group_photos_uploaderId_idx" ON "public"."tour_group_photos"("uploaderId");

-- CreateIndex
CREATE UNIQUE INDEX "users_phone_key" ON "public"."users"("phone");
