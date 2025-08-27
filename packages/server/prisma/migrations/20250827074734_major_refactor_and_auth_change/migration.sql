-- CreateEnum
CREATE TYPE "public"."CategoryType" AS ENUM ('CAT_ATTRACTION', 'CAT_HOTEL', 'CAT_RESTAURANT', 'CAT_SHOPPING_PLACE', 'CAT_TRANSPORTATION');

-- CreateEnum
CREATE TYPE "public"."UserRole" AS ENUM ('ADMIN', 'PLANNER', 'GUIDE', 'USER');

-- CreateEnum
CREATE TYPE "public"."IdCardType" AS ENUM ('ID_CARD', 'PASSPORT', 'HOME_RETURN_PERMIT', 'TAIWAN_COMPATRIOT_PERMIT', 'OFFICER_ID', 'OTHER');

-- CreateEnum
CREATE TYPE "public"."Gender" AS ENUM ('MALE', 'FEMALE', 'OTHER');

-- CreateEnum
CREATE TYPE "public"."UploaderType" AS ENUM ('USER', 'PARTICIPANT');

-- CreateEnum
CREATE TYPE "public"."FavoriteEntityType" AS ENUM ('FAV_ATTRACTION', 'FAV_HOTEL', 'FAV_RESTAURANT', 'FAV_SHOPPING_PLACE', 'FAV_TRANSPORTATION');

-- CreateEnum
CREATE TYPE "public"."MediaType" AS ENUM ('IMAGE', 'VIDEO');

-- CreateEnum
CREATE TYPE "public"."TourGroupStatus" AS ENUM ('DRAFT', 'CONFIRMED', 'ACTIVE', 'COMPLETED', 'CANCELLED', 'INACTIVE');

-- CreateEnum
CREATE TYPE "public"."TourReviewTargetType" AS ENUM ('TOUR_GROUP', 'GUIDE', 'HOTEL', 'ATTRACTION', 'RESTAURANT', 'TRANSPORTATION', 'SHOPPING_PLACE', 'ITINERARY_PLANNING', 'CUSTOMER_SUPPORT', 'APP_USABILITY', 'OTHER_FEEDBACK');

-- CreateEnum
CREATE TYPE "public"."ItineraryItemType" AS ENUM ('TRANSPORTATION', 'DINING', 'ATTRACTION', 'ACCOMMODATION', 'SHOPPING', 'OTHER');

-- CreateEnum
CREATE TYPE "public"."GuideRole" AS ENUM ('LEAD_GUIDE', 'LOCAL_GUIDE', 'INTERPRETER', 'DRIVER');

-- CreateEnum
CREATE TYPE "public"."GuideLogType" AS ENUM ('DAILY_LOG', 'ACTIVITY_LOG', 'INCIDENT_LOG', 'WEATHER_LOG', 'FINANCIAL_LOG');

-- CreateEnum
CREATE TYPE "public"."AuditStatus" AS ENUM ('SUCCESS', 'FAILED');

-- CreateTable
CREATE TABLE "public"."locations" (
    "id" SERIAL NOT NULL,
    "city" VARCHAR(100) NOT NULL,
    "region" VARCHAR(100),
    "country" VARCHAR(100) NOT NULL,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "locations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."attractions" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "description" TEXT,
    "address" VARCHAR(511) NOT NULL,
    "phone" VARCHAR(30),
    "latitude" DECIMAL(9,6),
    "longitude" DECIMAL(9,6),
    "averageRating" DECIMAL(3,2) NOT NULL DEFAULT 0.00,
    "reviewCount" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "locationId" INTEGER NOT NULL,

    CONSTRAINT "attractions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."categories" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "type" "public"."CategoryType" NOT NULL,
    "description" TEXT,

    CONSTRAINT "categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."attraction_categories" (
    "attractionId" INTEGER NOT NULL,
    "categoryId" INTEGER NOT NULL,

    CONSTRAINT "attraction_categories_pkey" PRIMARY KEY ("attractionId","categoryId")
);

-- CreateTable
CREATE TABLE "public"."hotel_categories" (
    "hotelId" INTEGER NOT NULL,
    "categoryId" INTEGER NOT NULL,

    CONSTRAINT "hotel_categories_pkey" PRIMARY KEY ("hotelId","categoryId")
);

-- CreateTable
CREATE TABLE "public"."restaurant_categories" (
    "restaurantId" INTEGER NOT NULL,
    "categoryId" INTEGER NOT NULL,

    CONSTRAINT "restaurant_categories_pkey" PRIMARY KEY ("restaurantId","categoryId")
);

-- CreateTable
CREATE TABLE "public"."shopping_place_categories" (
    "shoppingPlaceId" INTEGER NOT NULL,
    "categoryId" INTEGER NOT NULL,

    CONSTRAINT "shopping_place_categories_pkey" PRIMARY KEY ("shoppingPlaceId","categoryId")
);

-- CreateTable
CREATE TABLE "public"."transportation_categories" (
    "transportationId" INTEGER NOT NULL,
    "categoryId" INTEGER NOT NULL,

    CONSTRAINT "transportation_categories_pkey" PRIMARY KEY ("transportationId","categoryId")
);

-- CreateTable
CREATE TABLE "public"."users" (
    "id" SERIAL NOT NULL,
    "username" VARCHAR(50) NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "passwordHash" VARCHAR(255) NOT NULL,
    "fullName" VARCHAR(100),
    "role" "public"."UserRole" NOT NULL DEFAULT 'USER',
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "openid" VARCHAR(255),
    "idCardType" "public"."IdCardType",
    "idCardNumber" VARCHAR(255),
    "gender" "public"."Gender",
    "dateOfBirth" DATE,
    "phone" VARCHAR(30),

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."user_favorites" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "entityType" "public"."FavoriteEntityType" NOT NULL,
    "attractionId" INTEGER,
    "hotelId" INTEGER,
    "restaurantId" INTEGER,
    "shoppingPlaceId" INTEGER,
    "transportationId" INTEGER,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "user_favorites_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."assets" (
    "id" SERIAL NOT NULL,
    "mediaType" "public"."MediaType" NOT NULL,
    "url" VARCHAR(2048) NOT NULL,
    "caption" TEXT,
    "isPrimary" BOOLEAN NOT NULL DEFAULT false,
    "uploadedAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "uploaderId" INTEGER NOT NULL,
    "attractionId" INTEGER,
    "hotelId" INTEGER,
    "restaurantId" INTEGER,
    "shoppingPlaceId" INTEGER,

    CONSTRAINT "assets_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."hotels" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "description" TEXT,
    "address" VARCHAR(511) NOT NULL,
    "phone" VARCHAR(30),
    "latitude" DECIMAL(9,6),
    "longitude" DECIMAL(9,6),
    "starRating" INTEGER NOT NULL DEFAULT 0,
    "averageRating" DECIMAL(3,2) NOT NULL DEFAULT 0.00,
    "reviewCount" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "locationId" INTEGER NOT NULL,

    CONSTRAINT "hotels_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."hotel_rooms" (
    "id" SERIAL NOT NULL,
    "roomType" VARCHAR(100) NOT NULL,
    "description" TEXT,
    "isAvailable" BOOLEAN NOT NULL DEFAULT true,
    "maxOccupancy" INTEGER NOT NULL DEFAULT 2,
    "hotelId" INTEGER NOT NULL,

    CONSTRAINT "hotel_rooms_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."amenities" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "description" TEXT,

    CONSTRAINT "amenities_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."hotel_amenities" (
    "hotelId" INTEGER NOT NULL,
    "amenityId" INTEGER NOT NULL,

    CONSTRAINT "hotel_amenities_pkey" PRIMARY KEY ("hotelId","amenityId")
);

-- CreateTable
CREATE TABLE "public"."tour_groups" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "description" TEXT,
    "startDate" DATE NOT NULL,
    "endDate" DATE NOT NULL,
    "maxParticipants" INTEGER NOT NULL,
    "status" "public"."TourGroupStatus" NOT NULL DEFAULT 'ACTIVE',
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "userId" INTEGER NOT NULL,

    CONSTRAINT "tour_groups_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."tour_group_participants" (
    "id" SERIAL NOT NULL,
    "fullName" VARCHAR(255) NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "phone" VARCHAR(30),
    "dateOfBirth" DATE,
    "emergencyContact" VARCHAR(255) NOT NULL,
    "emergencyPhone" VARCHAR(30) NOT NULL,
    "specialRequests" TEXT,
    "registrationDate" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "tourGroupId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "assignedRoomId" INTEGER,

    CONSTRAINT "tour_group_participants_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."tour_group_photos" (
    "id" SERIAL NOT NULL,
    "url" VARCHAR(2048) NOT NULL,
    "caption" TEXT,
    "isPublic" BOOLEAN NOT NULL DEFAULT true,
    "uploadDate" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "likes" INTEGER NOT NULL DEFAULT 0,
    "tourGroupId" INTEGER NOT NULL,
    "uploaderType" "public"."UploaderType" NOT NULL,
    "uploaderId" INTEGER NOT NULL,

    CONSTRAINT "tour_group_photos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."tour_reviews" (
    "id" SERIAL NOT NULL,
    "comment" TEXT,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "participantId" INTEGER NOT NULL,
    "tourGroupId" INTEGER NOT NULL,
    "targetType" "public"."TourReviewTargetType" NOT NULL,
    "targetId" INTEGER,
    "ratings" JSONB NOT NULL,

    CONSTRAINT "tour_reviews_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."tour_group_guides" (
    "id" SERIAL NOT NULL,
    "fullName" VARCHAR(255) NOT NULL,
    "phone" VARCHAR(30) NOT NULL,
    "email" VARCHAR(255),
    "licenseNumber" VARCHAR(100) NOT NULL,
    "yearsOfExperience" INTEGER,
    "specialty" TEXT,
    "introduction" TEXT,
    "userId" INTEGER NOT NULL,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "tour_group_guides_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."tour_group_guide_assignments" (
    "id" SERIAL NOT NULL,
    "assignedAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "role" "public"."GuideRole" NOT NULL DEFAULT 'LEAD_GUIDE',
    "tourGroupId" INTEGER NOT NULL,
    "guideId" INTEGER NOT NULL,

    CONSTRAINT "tour_group_guide_assignments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."tour_group_guide_logs" (
    "id" SERIAL NOT NULL,
    "title" VARCHAR(255) NOT NULL,
    "content" TEXT NOT NULL,
    "logType" "public"."GuideLogType" NOT NULL DEFAULT 'DAILY_LOG',
    "date" DATE NOT NULL,
    "startTime" TIME,
    "endTime" TIME,
    "locationId" INTEGER,
    "weather" VARCHAR(100),
    "participantsCount" INTEGER,
    "issues" TEXT,
    "solutions" TEXT,
    "nextDayPlan" TEXT,
    "isImportant" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "tourGroupId" INTEGER NOT NULL,

    CONSTRAINT "tour_group_guide_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."itinerary_hotel_stays" (
    "id" SERIAL NOT NULL,
    "checkInDate" DATE NOT NULL,
    "checkOutDate" DATE NOT NULL,
    "notes" TEXT,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "destinationId" INTEGER NOT NULL,
    "hotelId" INTEGER NOT NULL,

    CONSTRAINT "itinerary_hotel_stays_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."assigned_rooms" (
    "id" SERIAL NOT NULL,
    "roomNumber" VARCHAR(50) NOT NULL,
    "notes" TEXT,
    "hotelStayId" INTEGER NOT NULL,

    CONSTRAINT "assigned_rooms_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."tour_group_participant_groups" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "description" TEXT,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "tourGroupId" INTEGER NOT NULL,

    CONSTRAINT "tour_group_participant_groups_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."tour_group_participant_group_members" (
    "groupId" INTEGER NOT NULL,
    "participantId" INTEGER NOT NULL,
    "joinedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "tour_group_participant_group_members_pkey" PRIMARY KEY ("groupId","participantId")
);

-- CreateTable
CREATE TABLE "public"."restaurants" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "description" TEXT,
    "address" VARCHAR(511) NOT NULL,
    "latitude" DECIMAL(9,6),
    "longitude" DECIMAL(9,6),
    "averageRating" DECIMAL(3,2) NOT NULL DEFAULT 0.00,
    "reviewCount" INTEGER NOT NULL DEFAULT 0,
    "priceRange" VARCHAR(50),
    "phone" VARCHAR(30),
    "website" VARCHAR(255),
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "locationId" INTEGER NOT NULL,

    CONSTRAINT "restaurants_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."transportations" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "description" TEXT,
    "provider" VARCHAR(255),
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "transportations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."shopping_places" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "description" TEXT,
    "address" VARCHAR(511) NOT NULL,
    "latitude" DECIMAL(9,6),
    "longitude" DECIMAL(9,6),
    "averageRating" DECIMAL(3,2) NOT NULL DEFAULT 0.00,
    "reviewCount" INTEGER NOT NULL DEFAULT 0,
    "openingHours" VARCHAR(255),
    "phone" VARCHAR(30),
    "website" VARCHAR(255),
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "locationId" INTEGER NOT NULL,

    CONSTRAINT "shopping_places_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."itinerary_templates" (
    "id" SERIAL NOT NULL,
    "title" VARCHAR(255) NOT NULL,
    "description" TEXT,
    "durationDays" INTEGER NOT NULL,
    "isPublic" BOOLEAN NOT NULL DEFAULT false,
    "version" VARCHAR(20) NOT NULL DEFAULT '1.0',
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "creatorId" INTEGER NOT NULL,

    CONSTRAINT "itinerary_templates_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."itineraries" (
    "id" SERIAL NOT NULL,
    "title" VARCHAR(255) NOT NULL,
    "description" TEXT,
    "durationDays" INTEGER NOT NULL,
    "startDate" DATE,
    "endDate" DATE,
    "templateVersion" VARCHAR(20),
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "templateId" INTEGER,
    "tourGroupId" INTEGER NOT NULL,

    CONSTRAINT "itineraries_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."itinerary_days" (
    "id" SERIAL NOT NULL,
    "dayNumber" INTEGER NOT NULL,
    "date" DATE,
    "notes" TEXT,
    "itineraryId" INTEGER NOT NULL,
    "locationId" INTEGER,

    CONSTRAINT "itinerary_days_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."itinerary_destinations" (
    "id" SERIAL NOT NULL,
    "orderInDay" INTEGER NOT NULL DEFAULT 1,
    "description" TEXT,
    "startTime" TIME,
    "endTime" TIME,
    "notes" TEXT,
    "isCustomized" BOOLEAN NOT NULL DEFAULT false,
    "itineraryDayId" INTEGER NOT NULL,
    "itemType" "public"."ItineraryItemType" NOT NULL,
    "attractionId" INTEGER,
    "hotelId" INTEGER,
    "restaurantId" INTEGER,
    "transportationId" INTEGER,
    "shoppingPlaceId" INTEGER,

    CONSTRAINT "itinerary_destinations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."template_destinations" (
    "id" SERIAL NOT NULL,
    "dayNumber" INTEGER NOT NULL,
    "orderInDay" INTEGER NOT NULL DEFAULT 1,
    "description" TEXT,
    "notes" TEXT,
    "itemType" "public"."ItineraryItemType" NOT NULL,
    "templateId" INTEGER NOT NULL,
    "attractionId" INTEGER,
    "hotelId" INTEGER,
    "restaurantId" INTEGER,
    "transportationId" INTEGER,
    "shoppingPlaceId" INTEGER,

    CONSTRAINT "template_destinations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."itinerary_day_weather_snapshots" (
    "id" SERIAL NOT NULL,
    "date" DATE NOT NULL,
    "temperatureHigh" DECIMAL(5,2),
    "temperatureLow" DECIMAL(5,2),
    "condition" VARCHAR(100) NOT NULL,
    "humidity" INTEGER,
    "windSpeed" DECIMAL(5,2),
    "windDirection" VARCHAR(50),
    "precipitation" DECIMAL(5,2),
    "uvIndex" INTEGER,
    "sunrise" TIME,
    "sunset" TIME,
    "forecastSource" VARCHAR(100),
    "capturedAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "itineraryDayId" INTEGER NOT NULL,
    "locationId" INTEGER,

    CONSTRAINT "itinerary_day_weather_snapshots_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."audit_logs" (
    "id" SERIAL NOT NULL,
    "action" VARCHAR(100) NOT NULL,
    "entityType" VARCHAR(100) NOT NULL,
    "entityId" INTEGER NOT NULL,
    "oldData" JSONB,
    "newData" JSONB,
    "performedAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "ipAddress" VARCHAR(45),
    "userAgent" TEXT,
    "status" "public"."AuditStatus" NOT NULL DEFAULT 'SUCCESS',
    "reason" TEXT,
    "performedById" INTEGER NOT NULL,

    CONSTRAINT "audit_logs_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "locations_city_region_country_key" ON "public"."locations"("city", "region", "country");

-- CreateIndex
CREATE UNIQUE INDEX "attractions_name_key" ON "public"."attractions"("name");

-- CreateIndex
CREATE INDEX "attractions_locationId_idx" ON "public"."attractions"("locationId");

-- CreateIndex
CREATE INDEX "attractions_averageRating_idx" ON "public"."attractions"("averageRating");

-- CreateIndex
CREATE INDEX "attractions_locationId_averageRating_idx" ON "public"."attractions"("locationId", "averageRating");

-- CreateIndex
CREATE UNIQUE INDEX "categories_name_type_key" ON "public"."categories"("name", "type");

-- CreateIndex
CREATE UNIQUE INDEX "users_username_key" ON "public"."users"("username");

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "public"."users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "users_openid_key" ON "public"."users"("openid");

-- CreateIndex
CREATE INDEX "user_favorites_userId_entityType_idx" ON "public"."user_favorites"("userId", "entityType");

-- CreateIndex
CREATE INDEX "user_favorites_attractionId_idx" ON "public"."user_favorites"("attractionId");

-- CreateIndex
CREATE INDEX "user_favorites_hotelId_idx" ON "public"."user_favorites"("hotelId");

-- CreateIndex
CREATE INDEX "user_favorites_restaurantId_idx" ON "public"."user_favorites"("restaurantId");

-- CreateIndex
CREATE INDEX "user_favorites_shoppingPlaceId_idx" ON "public"."user_favorites"("shoppingPlaceId");

-- CreateIndex
CREATE INDEX "user_favorites_transportationId_idx" ON "public"."user_favorites"("transportationId");

-- CreateIndex
CREATE UNIQUE INDEX "user_attraction_favorite_unique" ON "public"."user_favorites"("userId", "attractionId");

-- CreateIndex
CREATE UNIQUE INDEX "user_hotel_favorite_unique" ON "public"."user_favorites"("userId", "hotelId");

-- CreateIndex
CREATE UNIQUE INDEX "user_restaurant_favorite_unique" ON "public"."user_favorites"("userId", "restaurantId");

-- CreateIndex
CREATE UNIQUE INDEX "user_shopping_place_favorite_unique" ON "public"."user_favorites"("userId", "shoppingPlaceId");

-- CreateIndex
CREATE UNIQUE INDEX "user_transportation_favorite_unique" ON "public"."user_favorites"("userId", "transportationId");

-- CreateIndex
CREATE INDEX "assets_uploaderId_idx" ON "public"."assets"("uploaderId");

-- CreateIndex
CREATE INDEX "assets_attractionId_idx" ON "public"."assets"("attractionId");

-- CreateIndex
CREATE INDEX "assets_hotelId_idx" ON "public"."assets"("hotelId");

-- CreateIndex
CREATE INDEX "assets_restaurantId_idx" ON "public"."assets"("restaurantId");

-- CreateIndex
CREATE INDEX "assets_shoppingPlaceId_idx" ON "public"."assets"("shoppingPlaceId");

-- CreateIndex
CREATE UNIQUE INDEX "hotels_name_key" ON "public"."hotels"("name");

-- CreateIndex
CREATE INDEX "hotels_locationId_idx" ON "public"."hotels"("locationId");

-- CreateIndex
CREATE INDEX "hotels_locationId_starRating_idx" ON "public"."hotels"("locationId", "starRating");

-- CreateIndex
CREATE INDEX "hotel_rooms_hotelId_idx" ON "public"."hotel_rooms"("hotelId");

-- CreateIndex
CREATE UNIQUE INDEX "amenities_name_key" ON "public"."amenities"("name");

-- CreateIndex
CREATE INDEX "tour_groups_userId_idx" ON "public"."tour_groups"("userId");

-- CreateIndex
CREATE INDEX "tour_groups_status_startDate_idx" ON "public"."tour_groups"("status", "startDate");

-- CreateIndex
CREATE INDEX "tour_groups_startDate_endDate_idx" ON "public"."tour_groups"("startDate", "endDate");

-- CreateIndex
CREATE INDEX "tour_group_participants_tourGroupId_idx" ON "public"."tour_group_participants"("tourGroupId");

-- CreateIndex
CREATE INDEX "tour_group_participants_userId_idx" ON "public"."tour_group_participants"("userId");

-- CreateIndex
CREATE INDEX "tour_group_participants_assignedRoomId_idx" ON "public"."tour_group_participants"("assignedRoomId");

-- CreateIndex
CREATE INDEX "tour_group_photos_tourGroupId_idx" ON "public"."tour_group_photos"("tourGroupId");

-- CreateIndex
CREATE INDEX "tour_group_photos_uploaderType_uploaderId_idx" ON "public"."tour_group_photos"("uploaderType", "uploaderId");

-- CreateIndex
CREATE INDEX "tour_reviews_participantId_idx" ON "public"."tour_reviews"("participantId");

-- CreateIndex
CREATE INDEX "tour_reviews_tourGroupId_idx" ON "public"."tour_reviews"("tourGroupId");

-- CreateIndex
CREATE INDEX "tour_reviews_targetType_targetId_idx" ON "public"."tour_reviews"("targetType", "targetId");

-- CreateIndex
CREATE UNIQUE INDEX "tour_group_guides_licenseNumber_key" ON "public"."tour_group_guides"("licenseNumber");

-- CreateIndex
CREATE UNIQUE INDEX "tour_group_guides_userId_key" ON "public"."tour_group_guides"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "tour_group_guide_assignments_tourGroupId_guideId_key" ON "public"."tour_group_guide_assignments"("tourGroupId", "guideId");

-- CreateIndex
CREATE INDEX "tour_group_guide_logs_tourGroupId_idx" ON "public"."tour_group_guide_logs"("tourGroupId");

-- CreateIndex
CREATE INDEX "tour_group_guide_logs_locationId_idx" ON "public"."tour_group_guide_logs"("locationId");

-- CreateIndex
CREATE UNIQUE INDEX "itinerary_hotel_stays_destinationId_key" ON "public"."itinerary_hotel_stays"("destinationId");

-- CreateIndex
CREATE INDEX "itinerary_hotel_stays_hotelId_idx" ON "public"."itinerary_hotel_stays"("hotelId");

-- CreateIndex
CREATE INDEX "assigned_rooms_hotelStayId_idx" ON "public"."assigned_rooms"("hotelStayId");

-- CreateIndex
CREATE INDEX "tour_group_participant_groups_tourGroupId_idx" ON "public"."tour_group_participant_groups"("tourGroupId");

-- CreateIndex
CREATE UNIQUE INDEX "restaurants_name_key" ON "public"."restaurants"("name");

-- CreateIndex
CREATE INDEX "restaurants_locationId_idx" ON "public"."restaurants"("locationId");

-- CreateIndex
CREATE INDEX "restaurants_averageRating_idx" ON "public"."restaurants"("averageRating");

-- CreateIndex
CREATE INDEX "restaurants_locationId_averageRating_idx" ON "public"."restaurants"("locationId", "averageRating");

-- CreateIndex
CREATE UNIQUE INDEX "shopping_places_name_key" ON "public"."shopping_places"("name");

-- CreateIndex
CREATE INDEX "shopping_places_locationId_idx" ON "public"."shopping_places"("locationId");

-- CreateIndex
CREATE INDEX "shopping_places_averageRating_idx" ON "public"."shopping_places"("averageRating");

-- CreateIndex
CREATE INDEX "shopping_places_locationId_averageRating_idx" ON "public"."shopping_places"("locationId", "averageRating");

-- CreateIndex
CREATE INDEX "itinerary_templates_creatorId_idx" ON "public"."itinerary_templates"("creatorId");

-- CreateIndex
CREATE UNIQUE INDEX "itinerary_templates_title_version_key" ON "public"."itinerary_templates"("title", "version");

-- CreateIndex
CREATE UNIQUE INDEX "itineraries_tourGroupId_key" ON "public"."itineraries"("tourGroupId");

-- CreateIndex
CREATE INDEX "itineraries_startDate_endDate_idx" ON "public"."itineraries"("startDate", "endDate");

-- CreateIndex
CREATE INDEX "itineraries_templateId_idx" ON "public"."itineraries"("templateId");

-- CreateIndex
CREATE INDEX "itinerary_days_locationId_idx" ON "public"."itinerary_days"("locationId");

-- CreateIndex
CREATE UNIQUE INDEX "itinerary_days_itineraryId_dayNumber_key" ON "public"."itinerary_days"("itineraryId", "dayNumber");

-- CreateIndex
CREATE INDEX "itinerary_destinations_itineraryDayId_idx" ON "public"."itinerary_destinations"("itineraryDayId");

-- CreateIndex
CREATE INDEX "itinerary_destinations_attractionId_idx" ON "public"."itinerary_destinations"("attractionId");

-- CreateIndex
CREATE INDEX "itinerary_destinations_hotelId_idx" ON "public"."itinerary_destinations"("hotelId");

-- CreateIndex
CREATE INDEX "itinerary_destinations_restaurantId_idx" ON "public"."itinerary_destinations"("restaurantId");

-- CreateIndex
CREATE INDEX "itinerary_destinations_transportationId_idx" ON "public"."itinerary_destinations"("transportationId");

-- CreateIndex
CREATE INDEX "itinerary_destinations_shoppingPlaceId_idx" ON "public"."itinerary_destinations"("shoppingPlaceId");

-- CreateIndex
CREATE INDEX "template_destinations_templateId_idx" ON "public"."template_destinations"("templateId");

-- CreateIndex
CREATE INDEX "template_destinations_attractionId_idx" ON "public"."template_destinations"("attractionId");

-- CreateIndex
CREATE INDEX "template_destinations_hotelId_idx" ON "public"."template_destinations"("hotelId");

-- CreateIndex
CREATE INDEX "template_destinations_restaurantId_idx" ON "public"."template_destinations"("restaurantId");

-- CreateIndex
CREATE INDEX "template_destinations_transportationId_idx" ON "public"."template_destinations"("transportationId");

-- CreateIndex
CREATE INDEX "template_destinations_shoppingPlaceId_idx" ON "public"."template_destinations"("shoppingPlaceId");

-- CreateIndex
CREATE UNIQUE INDEX "itinerary_day_weather_snapshots_itineraryDayId_key" ON "public"."itinerary_day_weather_snapshots"("itineraryDayId");

-- CreateIndex
CREATE INDEX "itinerary_day_weather_snapshots_locationId_idx" ON "public"."itinerary_day_weather_snapshots"("locationId");

-- CreateIndex
CREATE INDEX "audit_logs_entityType_entityId_idx" ON "public"."audit_logs"("entityType", "entityId");

-- CreateIndex
CREATE INDEX "audit_logs_performedAt_idx" ON "public"."audit_logs"("performedAt");

-- CreateIndex
CREATE INDEX "audit_logs_performedById_idx" ON "public"."audit_logs"("performedById");

-- AddForeignKey
ALTER TABLE "public"."attractions" ADD CONSTRAINT "attractions_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "public"."locations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."attraction_categories" ADD CONSTRAINT "attraction_categories_attractionId_fkey" FOREIGN KEY ("attractionId") REFERENCES "public"."attractions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."attraction_categories" ADD CONSTRAINT "attraction_categories_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "public"."categories"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."hotel_categories" ADD CONSTRAINT "hotel_categories_hotelId_fkey" FOREIGN KEY ("hotelId") REFERENCES "public"."hotels"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."hotel_categories" ADD CONSTRAINT "hotel_categories_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "public"."categories"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."restaurant_categories" ADD CONSTRAINT "restaurant_categories_restaurantId_fkey" FOREIGN KEY ("restaurantId") REFERENCES "public"."restaurants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."restaurant_categories" ADD CONSTRAINT "restaurant_categories_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "public"."categories"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."shopping_place_categories" ADD CONSTRAINT "shopping_place_categories_shoppingPlaceId_fkey" FOREIGN KEY ("shoppingPlaceId") REFERENCES "public"."shopping_places"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."shopping_place_categories" ADD CONSTRAINT "shopping_place_categories_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "public"."categories"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."transportation_categories" ADD CONSTRAINT "transportation_categories_transportationId_fkey" FOREIGN KEY ("transportationId") REFERENCES "public"."transportations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."transportation_categories" ADD CONSTRAINT "transportation_categories_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "public"."categories"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."user_favorites" ADD CONSTRAINT "user_favorites_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."user_favorites" ADD CONSTRAINT "user_favorites_attractionId_fkey" FOREIGN KEY ("attractionId") REFERENCES "public"."attractions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."user_favorites" ADD CONSTRAINT "user_favorites_hotelId_fkey" FOREIGN KEY ("hotelId") REFERENCES "public"."hotels"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."user_favorites" ADD CONSTRAINT "user_favorites_restaurantId_fkey" FOREIGN KEY ("restaurantId") REFERENCES "public"."restaurants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."user_favorites" ADD CONSTRAINT "user_favorites_shoppingPlaceId_fkey" FOREIGN KEY ("shoppingPlaceId") REFERENCES "public"."shopping_places"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."user_favorites" ADD CONSTRAINT "user_favorites_transportationId_fkey" FOREIGN KEY ("transportationId") REFERENCES "public"."transportations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."assets" ADD CONSTRAINT "assets_uploaderId_fkey" FOREIGN KEY ("uploaderId") REFERENCES "public"."users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."assets" ADD CONSTRAINT "assets_attractionId_fkey" FOREIGN KEY ("attractionId") REFERENCES "public"."attractions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."assets" ADD CONSTRAINT "assets_hotelId_fkey" FOREIGN KEY ("hotelId") REFERENCES "public"."hotels"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."assets" ADD CONSTRAINT "assets_restaurantId_fkey" FOREIGN KEY ("restaurantId") REFERENCES "public"."restaurants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."assets" ADD CONSTRAINT "assets_shoppingPlaceId_fkey" FOREIGN KEY ("shoppingPlaceId") REFERENCES "public"."shopping_places"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."hotels" ADD CONSTRAINT "hotels_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "public"."locations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."hotel_rooms" ADD CONSTRAINT "hotel_rooms_hotelId_fkey" FOREIGN KEY ("hotelId") REFERENCES "public"."hotels"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."hotel_amenities" ADD CONSTRAINT "hotel_amenities_hotelId_fkey" FOREIGN KEY ("hotelId") REFERENCES "public"."hotels"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."hotel_amenities" ADD CONSTRAINT "hotel_amenities_amenityId_fkey" FOREIGN KEY ("amenityId") REFERENCES "public"."amenities"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."tour_groups" ADD CONSTRAINT "tour_groups_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."tour_group_participants" ADD CONSTRAINT "tour_group_participants_tourGroupId_fkey" FOREIGN KEY ("tourGroupId") REFERENCES "public"."tour_groups"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."tour_group_participants" ADD CONSTRAINT "tour_group_participants_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."tour_group_participants" ADD CONSTRAINT "tour_group_participants_assignedRoomId_fkey" FOREIGN KEY ("assignedRoomId") REFERENCES "public"."assigned_rooms"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."tour_group_photos" ADD CONSTRAINT "tour_group_photos_tourGroupId_fkey" FOREIGN KEY ("tourGroupId") REFERENCES "public"."tour_groups"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."tour_reviews" ADD CONSTRAINT "tour_reviews_participantId_fkey" FOREIGN KEY ("participantId") REFERENCES "public"."tour_group_participants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."tour_reviews" ADD CONSTRAINT "tour_reviews_tourGroupId_fkey" FOREIGN KEY ("tourGroupId") REFERENCES "public"."tour_groups"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."tour_group_guides" ADD CONSTRAINT "tour_group_guides_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."tour_group_guide_assignments" ADD CONSTRAINT "tour_group_guide_assignments_tourGroupId_fkey" FOREIGN KEY ("tourGroupId") REFERENCES "public"."tour_groups"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."tour_group_guide_assignments" ADD CONSTRAINT "tour_group_guide_assignments_guideId_fkey" FOREIGN KEY ("guideId") REFERENCES "public"."tour_group_guides"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."tour_group_guide_logs" ADD CONSTRAINT "tour_group_guide_logs_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "public"."locations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."tour_group_guide_logs" ADD CONSTRAINT "tour_group_guide_logs_tourGroupId_fkey" FOREIGN KEY ("tourGroupId") REFERENCES "public"."tour_groups"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."itinerary_hotel_stays" ADD CONSTRAINT "itinerary_hotel_stays_destinationId_fkey" FOREIGN KEY ("destinationId") REFERENCES "public"."itinerary_destinations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."itinerary_hotel_stays" ADD CONSTRAINT "itinerary_hotel_stays_hotelId_fkey" FOREIGN KEY ("hotelId") REFERENCES "public"."hotels"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."assigned_rooms" ADD CONSTRAINT "assigned_rooms_hotelStayId_fkey" FOREIGN KEY ("hotelStayId") REFERENCES "public"."itinerary_hotel_stays"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."tour_group_participant_groups" ADD CONSTRAINT "tour_group_participant_groups_tourGroupId_fkey" FOREIGN KEY ("tourGroupId") REFERENCES "public"."tour_groups"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."tour_group_participant_group_members" ADD CONSTRAINT "tour_group_participant_group_members_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "public"."tour_group_participant_groups"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."tour_group_participant_group_members" ADD CONSTRAINT "tour_group_participant_group_members_participantId_fkey" FOREIGN KEY ("participantId") REFERENCES "public"."tour_group_participants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."restaurants" ADD CONSTRAINT "restaurants_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "public"."locations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."shopping_places" ADD CONSTRAINT "shopping_places_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "public"."locations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."itinerary_templates" ADD CONSTRAINT "itinerary_templates_creatorId_fkey" FOREIGN KEY ("creatorId") REFERENCES "public"."users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."itineraries" ADD CONSTRAINT "itineraries_templateId_fkey" FOREIGN KEY ("templateId") REFERENCES "public"."itinerary_templates"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."itineraries" ADD CONSTRAINT "itineraries_tourGroupId_fkey" FOREIGN KEY ("tourGroupId") REFERENCES "public"."tour_groups"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."itinerary_days" ADD CONSTRAINT "itinerary_days_itineraryId_fkey" FOREIGN KEY ("itineraryId") REFERENCES "public"."itineraries"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."itinerary_days" ADD CONSTRAINT "itinerary_days_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "public"."locations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."itinerary_destinations" ADD CONSTRAINT "itinerary_destinations_itineraryDayId_fkey" FOREIGN KEY ("itineraryDayId") REFERENCES "public"."itinerary_days"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."itinerary_destinations" ADD CONSTRAINT "itinerary_destinations_attractionId_fkey" FOREIGN KEY ("attractionId") REFERENCES "public"."attractions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."itinerary_destinations" ADD CONSTRAINT "itinerary_destinations_hotelId_fkey" FOREIGN KEY ("hotelId") REFERENCES "public"."hotels"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."itinerary_destinations" ADD CONSTRAINT "itinerary_destinations_restaurantId_fkey" FOREIGN KEY ("restaurantId") REFERENCES "public"."restaurants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."itinerary_destinations" ADD CONSTRAINT "itinerary_destinations_transportationId_fkey" FOREIGN KEY ("transportationId") REFERENCES "public"."transportations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."itinerary_destinations" ADD CONSTRAINT "itinerary_destinations_shoppingPlaceId_fkey" FOREIGN KEY ("shoppingPlaceId") REFERENCES "public"."shopping_places"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."template_destinations" ADD CONSTRAINT "template_destinations_templateId_fkey" FOREIGN KEY ("templateId") REFERENCES "public"."itinerary_templates"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."template_destinations" ADD CONSTRAINT "template_destinations_attractionId_fkey" FOREIGN KEY ("attractionId") REFERENCES "public"."attractions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."template_destinations" ADD CONSTRAINT "template_destinations_hotelId_fkey" FOREIGN KEY ("hotelId") REFERENCES "public"."hotels"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."template_destinations" ADD CONSTRAINT "template_destinations_restaurantId_fkey" FOREIGN KEY ("restaurantId") REFERENCES "public"."restaurants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."template_destinations" ADD CONSTRAINT "template_destinations_transportationId_fkey" FOREIGN KEY ("transportationId") REFERENCES "public"."transportations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."template_destinations" ADD CONSTRAINT "template_destinations_shoppingPlaceId_fkey" FOREIGN KEY ("shoppingPlaceId") REFERENCES "public"."shopping_places"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."itinerary_day_weather_snapshots" ADD CONSTRAINT "itinerary_day_weather_snapshots_itineraryDayId_fkey" FOREIGN KEY ("itineraryDayId") REFERENCES "public"."itinerary_days"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."itinerary_day_weather_snapshots" ADD CONSTRAINT "itinerary_day_weather_snapshots_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "public"."locations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."audit_logs" ADD CONSTRAINT "audit_logs_performedById_fkey" FOREIGN KEY ("performedById") REFERENCES "public"."users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
