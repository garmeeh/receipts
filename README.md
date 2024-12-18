# Receipts

To start first run:

```
poetry install --no-root
```

To start the backend:

```
poetry run uvicorn app.main:app --reload
```

## Env

Add `credentials.json` to the root

## Linting & Auto Fix

For type linting ensure you have https://marketplace.visualstudio.com/items?itemName=charliermarsh.ruff installed

## Supabase

1. Ensure you have installed the [CLI](https://supabase.com/docs/guides/local-development/cli/getting-started?queryGroups=platform&platform=macos#installing-the-supabase-cli) or [update it](https://supabase.com/docs/guides/local-development/cli/getting-started?queryGroups=platform&platform=macos#updating-the-supabase-cli)

2. Run `supabase start`

3.

**Migrations**

You can make changes to your local database through the UI or via SQL editor. None of these are "committed" until you write a migration. You can auto generate one by running:

```bash
supabase db diff -f NAME_OF_YOUR_MIGRATION
```

An example is I ran: `supabase db diff -f inital_set_up` which generated `supabase/migrations20241218190518_inital_set_up.sql` (you can see this in the project sidebar)

This works pretty well unless you are doing something crazy complex.

You can run this command to generate the latest schema. Very useful if you want to pass it as context to a LLM or in cursor.

```bash
supabase db dump -f supabase/schema.sql --local
```
