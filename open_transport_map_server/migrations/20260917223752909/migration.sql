BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "transit_agency" (
    "id" bigserial PRIMARY KEY,
    "externalId" text NOT NULL,
    "name" text NOT NULL,
    "timezone" text NOT NULL DEFAULT 'Europe/Stockholm'::text,
    "countryCode" text NOT NULL DEFAULT 'SE'::text,
    "city" text NOT NULL,
    "syncedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "transit_agency_external_id_idx" ON "transit_agency" USING btree ("externalId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "transit_route" (
    "id" bigserial PRIMARY KEY,
    "agencyId" bigint NOT NULL,
    "externalId" text NOT NULL,
    "shortName" text NOT NULL,
    "longName" text,
    "transportMode" text NOT NULL,
    "backgroundColor" text,
    "foregroundColor" text,
    "borderColor" text
);

-- Indexes
CREATE UNIQUE INDEX "transit_route_agency_ext_idx" ON "transit_route" USING btree ("agencyId", "externalId");
CREATE INDEX "transit_route_mode_idx" ON "transit_route" USING btree ("transportMode");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "transit_route_shape" (
    "id" bigserial PRIMARY KEY,
    "routeId" bigint NOT NULL,
    "directionId" bigint,
    "headsign" text,
    "geometryGeoJson" text NOT NULL
);

-- Indexes
CREATE INDEX "transit_route_shape_route_idx" ON "transit_route_shape" USING btree ("routeId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "transit_route_stop" (
    "id" bigserial PRIMARY KEY,
    "routeShapeId" bigint NOT NULL,
    "stopPointId" bigint NOT NULL,
    "stopSequence" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "transit_route_stop_seq_idx" ON "transit_route_stop" USING btree ("routeShapeId", "stopSequence");
CREATE INDEX "transit_route_stop_point_idx" ON "transit_route_stop" USING btree ("stopPointId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "transit_stop_area" (
    "id" bigserial PRIMARY KEY,
    "agencyId" bigint NOT NULL,
    "externalId" text NOT NULL,
    "name" text NOT NULL,
    "latitude" double precision NOT NULL,
    "longitude" double precision NOT NULL,
    "municipality" text,
    "tariffZoneId" bigint
);

-- Indexes
CREATE UNIQUE INDEX "transit_stop_area_agency_ext_idx" ON "transit_stop_area" USING btree ("agencyId", "externalId");
CREATE INDEX "transit_stop_area_coords_idx" ON "transit_stop_area" USING btree ("latitude", "longitude");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "transit_stop_point" (
    "id" bigserial PRIMARY KEY,
    "agencyId" bigint NOT NULL,
    "stopAreaId" bigint NOT NULL,
    "externalId" text NOT NULL,
    "name" text NOT NULL,
    "platform" text,
    "latitude" double precision NOT NULL,
    "longitude" double precision NOT NULL,
    "designation" text
);

-- Indexes
CREATE UNIQUE INDEX "transit_stop_point_agency_ext_idx" ON "transit_stop_point" USING btree ("agencyId", "externalId");
CREATE INDEX "transit_stop_point_area_idx" ON "transit_stop_point" USING btree ("stopAreaId");
CREATE INDEX "transit_stop_point_coords_idx" ON "transit_stop_point" USING btree ("latitude", "longitude");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "transit_zone" (
    "id" bigserial PRIMARY KEY,
    "agencyId" bigint NOT NULL,
    "externalId" text NOT NULL,
    "name" text NOT NULL,
    "color" text,
    "geometryGeoJson" text
);

-- Indexes
CREATE UNIQUE INDEX "transit_zone_agency_ext_idx" ON "transit_zone" USING btree ("agencyId", "externalId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "transit_route"
    ADD CONSTRAINT "transit_route_fk_0"
    FOREIGN KEY("agencyId")
    REFERENCES "transit_agency"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "transit_route_shape"
    ADD CONSTRAINT "transit_route_shape_fk_0"
    FOREIGN KEY("routeId")
    REFERENCES "transit_route"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "transit_route_stop"
    ADD CONSTRAINT "transit_route_stop_fk_0"
    FOREIGN KEY("routeShapeId")
    REFERENCES "transit_route_shape"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "transit_route_stop"
    ADD CONSTRAINT "transit_route_stop_fk_1"
    FOREIGN KEY("stopPointId")
    REFERENCES "transit_stop_point"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "transit_stop_area"
    ADD CONSTRAINT "transit_stop_area_fk_0"
    FOREIGN KEY("agencyId")
    REFERENCES "transit_agency"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "transit_stop_area"
    ADD CONSTRAINT "transit_stop_area_fk_1"
    FOREIGN KEY("tariffZoneId")
    REFERENCES "transit_zone"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "transit_stop_point"
    ADD CONSTRAINT "transit_stop_point_fk_0"
    FOREIGN KEY("agencyId")
    REFERENCES "transit_agency"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "transit_stop_point"
    ADD CONSTRAINT "transit_stop_point_fk_1"
    FOREIGN KEY("stopAreaId")
    REFERENCES "transit_stop_area"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "transit_zone"
    ADD CONSTRAINT "transit_zone_fk_0"
    FOREIGN KEY("agencyId")
    REFERENCES "transit_agency"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR open_transport_map
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('open_transport_map', '20260917223752909', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260917223752909', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260910193913364-string-rate-limit-keys', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260910193913364-string-rate-limit-keys', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260824182354731', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182354731', "timestamp" = now();


COMMIT;
