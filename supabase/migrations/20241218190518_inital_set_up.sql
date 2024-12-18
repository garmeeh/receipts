create sequence "public"."product_pricing_history_id_seq";

create sequence "public"."products_id_seq";

create sequence "public"."receipt_items_id_seq";

create sequence "public"."receipts_id_seq";

create sequence "public"."stores_id_seq";

create table "public"."product_pricing_history" (
    "id" bigint not null default nextval('product_pricing_history_id_seq'::regclass),
    "product_id" bigint,
    "price" numeric not null,
    "started_on" timestamp without time zone not null default now(),
    "ended_on" timestamp without time zone
);


alter table "public"."product_pricing_history" enable row level security;

create table "public"."products" (
    "id" bigint not null default nextval('products_id_seq'::regclass),
    "name" text not null,
    "brand" text,
    "category" text,
    "created_at" timestamp without time zone default CURRENT_TIMESTAMP
);


alter table "public"."products" enable row level security;

create table "public"."receipt_items" (
    "id" bigint not null default nextval('receipt_items_id_seq'::regclass),
    "receipt_id" bigint,
    "product_id" bigint,
    "user_id" uuid,
    "quantity" numeric not null,
    "unit_price" numeric not null,
    "total_price" numeric not null
);


alter table "public"."receipt_items" enable row level security;

create table "public"."receipts" (
    "id" bigint not null default nextval('receipts_id_seq'::regclass),
    "store_id" bigint,
    "user_id" uuid,
    "transaction_date" timestamp without time zone not null,
    "total_amount" numeric not null,
    "created_at" timestamp without time zone default CURRENT_TIMESTAMP
);


alter table "public"."receipts" enable row level security;

create table "public"."stores" (
    "id" bigint not null default nextval('stores_id_seq'::regclass),
    "name" text not null,
    "chain_name" text
);


alter table "public"."stores" enable row level security;

create table "public"."users" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "email" text,
    "phone" text
);


alter table "public"."users" enable row level security;

alter sequence "public"."product_pricing_history_id_seq" owned by "public"."product_pricing_history"."id";

alter sequence "public"."products_id_seq" owned by "public"."products"."id";

alter sequence "public"."receipt_items_id_seq" owned by "public"."receipt_items"."id";

alter sequence "public"."receipts_id_seq" owned by "public"."receipts"."id";

alter sequence "public"."stores_id_seq" owned by "public"."stores"."id";

CREATE INDEX idx_products_name ON public.products USING btree (name);

CREATE INDEX idx_receipt_items_product ON public.receipt_items USING btree (product_id);

CREATE INDEX idx_receipt_items_user_id ON public.receipt_items USING btree (user_id);

CREATE INDEX idx_receipts_user_id ON public.receipts USING btree (user_id);

CREATE UNIQUE INDEX product_pricing_history_pkey ON public.product_pricing_history USING btree (id);

CREATE UNIQUE INDEX products_name_brand_key ON public.products USING btree (name, brand);

CREATE UNIQUE INDEX products_pkey ON public.products USING btree (id);

CREATE UNIQUE INDEX receipt_items_pkey ON public.receipt_items USING btree (id);

CREATE UNIQUE INDEX receipts_pkey ON public.receipts USING btree (id);

CREATE UNIQUE INDEX stores_pkey ON public.stores USING btree (id);

CREATE UNIQUE INDEX users_pkey ON public.users USING btree (id);

alter table "public"."product_pricing_history" add constraint "product_pricing_history_pkey" PRIMARY KEY using index "product_pricing_history_pkey";

alter table "public"."products" add constraint "products_pkey" PRIMARY KEY using index "products_pkey";

alter table "public"."receipt_items" add constraint "receipt_items_pkey" PRIMARY KEY using index "receipt_items_pkey";

alter table "public"."receipts" add constraint "receipts_pkey" PRIMARY KEY using index "receipts_pkey";

alter table "public"."stores" add constraint "stores_pkey" PRIMARY KEY using index "stores_pkey";

alter table "public"."users" add constraint "users_pkey" PRIMARY KEY using index "users_pkey";

alter table "public"."product_pricing_history" add constraint "product_pricing_history_product_id_fkey" FOREIGN KEY (product_id) REFERENCES products(id) not valid;

alter table "public"."product_pricing_history" validate constraint "product_pricing_history_product_id_fkey";

alter table "public"."products" add constraint "products_name_brand_key" UNIQUE using index "products_name_brand_key";

alter table "public"."receipt_items" add constraint "receipt_items_product_id_fkey" FOREIGN KEY (product_id) REFERENCES products(id) not valid;

alter table "public"."receipt_items" validate constraint "receipt_items_product_id_fkey";

alter table "public"."receipt_items" add constraint "receipt_items_receipt_id_fkey" FOREIGN KEY (receipt_id) REFERENCES receipts(id) not valid;

alter table "public"."receipt_items" validate constraint "receipt_items_receipt_id_fkey";

alter table "public"."receipt_items" add constraint "receipt_items_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) not valid;

alter table "public"."receipt_items" validate constraint "receipt_items_user_id_fkey";

alter table "public"."receipts" add constraint "receipts_store_id_fkey" FOREIGN KEY (store_id) REFERENCES stores(id) not valid;

alter table "public"."receipts" validate constraint "receipts_store_id_fkey";

alter table "public"."receipts" add constraint "receipts_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) not valid;

alter table "public"."receipts" validate constraint "receipts_user_id_fkey";

grant delete on table "public"."product_pricing_history" to "anon";

grant insert on table "public"."product_pricing_history" to "anon";

grant references on table "public"."product_pricing_history" to "anon";

grant select on table "public"."product_pricing_history" to "anon";

grant trigger on table "public"."product_pricing_history" to "anon";

grant truncate on table "public"."product_pricing_history" to "anon";

grant update on table "public"."product_pricing_history" to "anon";

grant delete on table "public"."product_pricing_history" to "authenticated";

grant insert on table "public"."product_pricing_history" to "authenticated";

grant references on table "public"."product_pricing_history" to "authenticated";

grant select on table "public"."product_pricing_history" to "authenticated";

grant trigger on table "public"."product_pricing_history" to "authenticated";

grant truncate on table "public"."product_pricing_history" to "authenticated";

grant update on table "public"."product_pricing_history" to "authenticated";

grant delete on table "public"."product_pricing_history" to "service_role";

grant insert on table "public"."product_pricing_history" to "service_role";

grant references on table "public"."product_pricing_history" to "service_role";

grant select on table "public"."product_pricing_history" to "service_role";

grant trigger on table "public"."product_pricing_history" to "service_role";

grant truncate on table "public"."product_pricing_history" to "service_role";

grant update on table "public"."product_pricing_history" to "service_role";

grant delete on table "public"."products" to "anon";

grant insert on table "public"."products" to "anon";

grant references on table "public"."products" to "anon";

grant select on table "public"."products" to "anon";

grant trigger on table "public"."products" to "anon";

grant truncate on table "public"."products" to "anon";

grant update on table "public"."products" to "anon";

grant delete on table "public"."products" to "authenticated";

grant insert on table "public"."products" to "authenticated";

grant references on table "public"."products" to "authenticated";

grant select on table "public"."products" to "authenticated";

grant trigger on table "public"."products" to "authenticated";

grant truncate on table "public"."products" to "authenticated";

grant update on table "public"."products" to "authenticated";

grant delete on table "public"."products" to "service_role";

grant insert on table "public"."products" to "service_role";

grant references on table "public"."products" to "service_role";

grant select on table "public"."products" to "service_role";

grant trigger on table "public"."products" to "service_role";

grant truncate on table "public"."products" to "service_role";

grant update on table "public"."products" to "service_role";

grant delete on table "public"."receipt_items" to "anon";

grant insert on table "public"."receipt_items" to "anon";

grant references on table "public"."receipt_items" to "anon";

grant select on table "public"."receipt_items" to "anon";

grant trigger on table "public"."receipt_items" to "anon";

grant truncate on table "public"."receipt_items" to "anon";

grant update on table "public"."receipt_items" to "anon";

grant delete on table "public"."receipt_items" to "authenticated";

grant insert on table "public"."receipt_items" to "authenticated";

grant references on table "public"."receipt_items" to "authenticated";

grant select on table "public"."receipt_items" to "authenticated";

grant trigger on table "public"."receipt_items" to "authenticated";

grant truncate on table "public"."receipt_items" to "authenticated";

grant update on table "public"."receipt_items" to "authenticated";

grant delete on table "public"."receipt_items" to "service_role";

grant insert on table "public"."receipt_items" to "service_role";

grant references on table "public"."receipt_items" to "service_role";

grant select on table "public"."receipt_items" to "service_role";

grant trigger on table "public"."receipt_items" to "service_role";

grant truncate on table "public"."receipt_items" to "service_role";

grant update on table "public"."receipt_items" to "service_role";

grant delete on table "public"."receipts" to "anon";

grant insert on table "public"."receipts" to "anon";

grant references on table "public"."receipts" to "anon";

grant select on table "public"."receipts" to "anon";

grant trigger on table "public"."receipts" to "anon";

grant truncate on table "public"."receipts" to "anon";

grant update on table "public"."receipts" to "anon";

grant delete on table "public"."receipts" to "authenticated";

grant insert on table "public"."receipts" to "authenticated";

grant references on table "public"."receipts" to "authenticated";

grant select on table "public"."receipts" to "authenticated";

grant trigger on table "public"."receipts" to "authenticated";

grant truncate on table "public"."receipts" to "authenticated";

grant update on table "public"."receipts" to "authenticated";

grant delete on table "public"."receipts" to "service_role";

grant insert on table "public"."receipts" to "service_role";

grant references on table "public"."receipts" to "service_role";

grant select on table "public"."receipts" to "service_role";

grant trigger on table "public"."receipts" to "service_role";

grant truncate on table "public"."receipts" to "service_role";

grant update on table "public"."receipts" to "service_role";

grant delete on table "public"."stores" to "anon";

grant insert on table "public"."stores" to "anon";

grant references on table "public"."stores" to "anon";

grant select on table "public"."stores" to "anon";

grant trigger on table "public"."stores" to "anon";

grant truncate on table "public"."stores" to "anon";

grant update on table "public"."stores" to "anon";

grant delete on table "public"."stores" to "authenticated";

grant insert on table "public"."stores" to "authenticated";

grant references on table "public"."stores" to "authenticated";

grant select on table "public"."stores" to "authenticated";

grant trigger on table "public"."stores" to "authenticated";

grant truncate on table "public"."stores" to "authenticated";

grant update on table "public"."stores" to "authenticated";

grant delete on table "public"."stores" to "service_role";

grant insert on table "public"."stores" to "service_role";

grant references on table "public"."stores" to "service_role";

grant select on table "public"."stores" to "service_role";

grant trigger on table "public"."stores" to "service_role";

grant truncate on table "public"."stores" to "service_role";

grant update on table "public"."stores" to "service_role";

grant delete on table "public"."users" to "anon";

grant insert on table "public"."users" to "anon";

grant references on table "public"."users" to "anon";

grant select on table "public"."users" to "anon";

grant trigger on table "public"."users" to "anon";

grant truncate on table "public"."users" to "anon";

grant update on table "public"."users" to "anon";

grant delete on table "public"."users" to "authenticated";

grant insert on table "public"."users" to "authenticated";

grant references on table "public"."users" to "authenticated";

grant select on table "public"."users" to "authenticated";

grant trigger on table "public"."users" to "authenticated";

grant truncate on table "public"."users" to "authenticated";

grant update on table "public"."users" to "authenticated";

grant delete on table "public"."users" to "service_role";

grant insert on table "public"."users" to "service_role";

grant references on table "public"."users" to "service_role";

grant select on table "public"."users" to "service_role";

grant trigger on table "public"."users" to "service_role";

grant truncate on table "public"."users" to "service_role";

grant update on table "public"."users" to "service_role";


