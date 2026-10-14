BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "transit_next_stop" (
    "id" bigserial PRIMARY KEY,
    "routeId" bigint NOT NULL,
    "headsign" text NOT NULL,
    "stopPointExternalId" text NOT NULL,
    "nextStopName" text NOT NULL,
    "cachedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "transit_next_stop_lookup_idx" ON "transit_next_stop" USING btree ("routeId", "headsign", "stopPointExternalId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "transit_next_stop"
    ADD CONSTRAINT "transit_next_stop_fk_0"
    FOREIGN KEY("routeId")
    REFERENCES "transit_route"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR open_transport_map
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('open_transport_map', '20260928153727508-next_stop_cache', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260928153727508-next_stop_cache', "timestamp" = now();

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
