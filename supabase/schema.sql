-- Balvia CRM — Supabase schema
-- Run this once in your Supabase project's SQL editor (Dashboard → SQL Editor → New query → paste → Run).
--
-- Each row's `data` column holds the whole contact/user record as JSON — this
-- mirrors the document-store shape the app already speaks, so the app code
-- barely changes when you switch it from Claude's built-in database to this one.

create extension if not exists "pgcrypto";

create table if not exists contacts (
  id uuid primary key default gen_random_uuid(),
  data jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists company_users (
  id uuid primary key default gen_random_uuid(),
  data jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Realtime: lets the app get live updates when data changes (e.g. from another tab).
alter publication supabase_realtime add table contacts;
alter publication supabase_realtime add table company_users;

-- Row Level Security.
--
-- IMPORTANT TRADE-OFF: this app has no login step — it talks to Supabase
-- with the public "anon" key, which is safe to expose in client code, but
-- the policies below grant that anon key full read/write access to both
-- tables. That means anyone who has your site's URL (or who finds your
-- Supabase URL + anon key some other way) can read and write this data —
-- there is no per-user privacy. That's fine for a single-person tool you
-- don't share widely, but if you want real privacy, add Supabase Auth
-- (email/password or magic link) and change these policies to check
-- auth.uid() — ask me and I'll wire that up.
alter table contacts enable row level security;
alter table company_users enable row level security;

create policy "anon full access" on contacts
  for all using (true) with check (true);

create policy "anon full access" on company_users
  for all using (true) with check (true);
