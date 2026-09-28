# Balvia

A relationship ledger for tracking customers, clients, suppliers, lenders, borrowers and architects — contact info, what they offer, and when to follow up.

Plain HTML/CSS/JS, no build step. Backed by [Supabase](https://supabase.com) (free tier), deployed on [Vercel](https://vercel.com) (free tier).

## 1. Create your Supabase project

1. Go to [supabase.com](https://supabase.com) → sign up (free) → **New project**.
2. Once it's created, open **SQL Editor** (left sidebar) → **New query**.
3. Paste in the contents of [`supabase/schema.sql`](supabase/schema.sql) and click **Run**. This creates the `contacts` and `company_users` tables.
4. Go to **Settings → API**. You'll need two values from this page:
   - **Project URL**
   - **anon / public** key (not the `service_role` key — never use that one in client-side code)

## 2. Connect the app to Supabase

Open `config.js` and replace the placeholders with the values from step 1:

```js
window.SUPABASE_URL = "https://your-project-ref.supabase.co";
window.SUPABASE_ANON_KEY = "eyJ...";
```

That's it — the app talks to Supabase directly from the browser.

**A note on security:** this app has no login screen. The anon key above is safe to expose (it's designed to be public), but the database policies in `schema.sql` currently give that key full read/write access to your data, with no per-person restriction. That's fine for a personal tool you don't share widely, but anyone with your site's URL could, in principle, read or edit your contacts. If you want real privacy — a login step, data scoped to just you — Supabase Auth is the standard way to add that; ask and it can be wired in.

## 3. Try it locally

Any static file server works, for example:

```bash
npx serve .
```

Then open the URL it prints. You should see "Synced" in the bottom-left of the sidebar once `config.js` is filled in correctly.

## 4. Push to GitHub

```bash
cd balvia-crm
git init
git add .
git commit -m "Initial commit"
gh repo create balvia-crm --private --source=. --push
```

(No `gh` CLI? Create an empty repo at [github.com/new](https://github.com/new), then:)

```bash
git remote add origin https://github.com/<you>/balvia-crm.git
git branch -M main
git push -u origin main
```

## 5. Deploy to Vercel

1. Go to [vercel.com/new](https://vercel.com/new) → **Import** your `balvia-crm` GitHub repo.
2. Framework preset: **Other** (it's a static site — no build command needed).
3. Click **Deploy**. You'll get a free `your-project.vercel.app` URL.

From then on, every `git push` to `main` auto-deploys.

## Project structure

```
index.html          the whole app (HTML + CSS + JS)
config.js            your Supabase URL + anon key (committed — the anon key is public by design)
supabase/schema.sql   database schema + row-level security policies, run once in Supabase's SQL editor
```
