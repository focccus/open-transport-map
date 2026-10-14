BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "transit_route" ADD COLUMN "cachedAt" timestamp without time zone;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "transit_route_shape" ADD COLUMN "cachedAt" timestamp without time zone;
CREATE INDEX "transit_route_shape_lookup_idx" ON "transit_route_shape" USING btree ("routeId", "headsign");

--
-- MIGRATION VERSION FOR open_transport_map
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('open_transport_map', '20260928141334457-ondemand_route_caching', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260928141334457-ondemand_route_caching', "timestamp" = now();

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
