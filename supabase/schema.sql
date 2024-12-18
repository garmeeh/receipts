

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE EXTENSION IF NOT EXISTS "pg_net" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgsodium" WITH SCHEMA "pgsodium";






COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgjwt" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";





SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."product_pricing_history" (
    "id" bigint NOT NULL,
    "product_id" bigint,
    "price" numeric NOT NULL,
    "started_on" timestamp without time zone DEFAULT "now"() NOT NULL,
    "ended_on" timestamp without time zone
);


ALTER TABLE "public"."product_pricing_history" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."product_pricing_history_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."product_pricing_history_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."product_pricing_history_id_seq" OWNED BY "public"."product_pricing_history"."id";



CREATE TABLE IF NOT EXISTS "public"."products" (
    "id" bigint NOT NULL,
    "name" "text" NOT NULL,
    "brand" "text",
    "category" "text",
    "created_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."products" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."products_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."products_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."products_id_seq" OWNED BY "public"."products"."id";



CREATE TABLE IF NOT EXISTS "public"."receipt_items" (
    "id" bigint NOT NULL,
    "receipt_id" bigint,
    "product_id" bigint,
    "user_id" "uuid",
    "quantity" numeric NOT NULL,
    "unit_price" numeric NOT NULL,
    "total_price" numeric NOT NULL
);


ALTER TABLE "public"."receipt_items" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."receipt_items_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."receipt_items_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."receipt_items_id_seq" OWNED BY "public"."receipt_items"."id";



CREATE TABLE IF NOT EXISTS "public"."receipts" (
    "id" bigint NOT NULL,
    "store_id" bigint,
    "user_id" "uuid",
    "transaction_date" timestamp without time zone NOT NULL,
    "total_amount" numeric NOT NULL,
    "created_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "ocr_text" "text"
);


ALTER TABLE "public"."receipts" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."receipts_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."receipts_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."receipts_id_seq" OWNED BY "public"."receipts"."id";



CREATE TABLE IF NOT EXISTS "public"."stores" (
    "id" bigint NOT NULL,
    "name" "text" NOT NULL,
    "chain_name" "text"
);


ALTER TABLE "public"."stores" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."stores_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."stores_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."stores_id_seq" OWNED BY "public"."stores"."id";



CREATE TABLE IF NOT EXISTS "public"."users" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "email" "text",
    "phone" "text"
);


ALTER TABLE "public"."users" OWNER TO "postgres";


ALTER TABLE ONLY "public"."product_pricing_history" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."product_pricing_history_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."products" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."products_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."receipt_items" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."receipt_items_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."receipts" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."receipts_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."stores" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."stores_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."product_pricing_history"
    ADD CONSTRAINT "product_pricing_history_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."products"
    ADD CONSTRAINT "products_name_brand_key" UNIQUE ("name", "brand");



ALTER TABLE ONLY "public"."products"
    ADD CONSTRAINT "products_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."receipt_items"
    ADD CONSTRAINT "receipt_items_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."receipts"
    ADD CONSTRAINT "receipts_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."stores"
    ADD CONSTRAINT "stores_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_pkey" PRIMARY KEY ("id");



CREATE INDEX "idx_products_name" ON "public"."products" USING "btree" ("name");



CREATE INDEX "idx_receipt_items_product" ON "public"."receipt_items" USING "btree" ("product_id");



CREATE INDEX "idx_receipt_items_user_id" ON "public"."receipt_items" USING "btree" ("user_id");



CREATE INDEX "idx_receipts_user_id" ON "public"."receipts" USING "btree" ("user_id");



ALTER TABLE ONLY "public"."product_pricing_history"
    ADD CONSTRAINT "product_pricing_history_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id");



ALTER TABLE ONLY "public"."receipt_items"
    ADD CONSTRAINT "receipt_items_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id");



ALTER TABLE ONLY "public"."receipt_items"
    ADD CONSTRAINT "receipt_items_receipt_id_fkey" FOREIGN KEY ("receipt_id") REFERENCES "public"."receipts"("id");



ALTER TABLE ONLY "public"."receipt_items"
    ADD CONSTRAINT "receipt_items_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."receipts"
    ADD CONSTRAINT "receipts_store_id_fkey" FOREIGN KEY ("store_id") REFERENCES "public"."stores"("id");



ALTER TABLE ONLY "public"."receipts"
    ADD CONSTRAINT "receipts_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id");



ALTER TABLE "public"."product_pricing_history" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."products" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."receipt_items" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."receipts" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."stores" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."users" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";





GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";









































































































































































































GRANT ALL ON TABLE "public"."product_pricing_history" TO "anon";
GRANT ALL ON TABLE "public"."product_pricing_history" TO "authenticated";
GRANT ALL ON TABLE "public"."product_pricing_history" TO "service_role";



GRANT ALL ON SEQUENCE "public"."product_pricing_history_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."product_pricing_history_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."product_pricing_history_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."products" TO "anon";
GRANT ALL ON TABLE "public"."products" TO "authenticated";
GRANT ALL ON TABLE "public"."products" TO "service_role";



GRANT ALL ON SEQUENCE "public"."products_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."products_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."products_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."receipt_items" TO "anon";
GRANT ALL ON TABLE "public"."receipt_items" TO "authenticated";
GRANT ALL ON TABLE "public"."receipt_items" TO "service_role";



GRANT ALL ON SEQUENCE "public"."receipt_items_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."receipt_items_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."receipt_items_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."receipts" TO "anon";
GRANT ALL ON TABLE "public"."receipts" TO "authenticated";
GRANT ALL ON TABLE "public"."receipts" TO "service_role";



GRANT ALL ON SEQUENCE "public"."receipts_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."receipts_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."receipts_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."stores" TO "anon";
GRANT ALL ON TABLE "public"."stores" TO "authenticated";
GRANT ALL ON TABLE "public"."stores" TO "service_role";



GRANT ALL ON SEQUENCE "public"."stores_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."stores_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."stores_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."users" TO "anon";
GRANT ALL ON TABLE "public"."users" TO "authenticated";
GRANT ALL ON TABLE "public"."users" TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "service_role";






























RESET ALL;
