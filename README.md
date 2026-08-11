# The Operator's Brief — persistence & permissions fix

This repo exists to give the daily *Operator's Brief* scheduled task a **home**.
The scheduled task runs in a fresh, throwaway container every day. Without a
repo attached, three things reset on every run:

- `editions/` — the archive of past briefs (needed to report *change*, not *state*)
- `watchlist.md` — unresolved items rolled forward
- `.claude/settings.json` — the permission allowlist

That reset is why the task (a) asked for permission every single day and
(b) kept losing continuity. Attaching this repo fixes both.

## One-time setup (do this once, ~5 min)

1. **Create a private GitHub repo** — e.g. `operators-brief` — and push the
   contents of this folder to it (`.claude/`, `editions/`, `watchlist.md`, this README).
2. On **claude.ai/code**, open the schedule that runs the brief → its
   **Environment** settings → set the **source repository** to the repo from step 1.
   Give it **Gmail** connector access and a **network policy** that allows the
   news/data domains the brief researches.
3. In the same environment settings, set the run to **auto-approve / skip
   permission prompts** (a.k.a. accept-edits / bypass mode for the scheduled run).
   The `.claude/settings.json` allowlist below covers every tool the brief uses,
   so with a repo attached the prompts stop even without bypass mode — but bypass
   mode is the belt-and-suspenders guarantee for anything new.

That's it. From the next run onward: no daily permission prompts, and each
edition + watchlist update is committed back so tomorrow's brief can read the
last 10 editions.

## What's in here

- `.claude/settings.json` — permission allowlist (Bash date/ls/cat/find/git,
  Read/Write/Edit, WebSearch, WebFetch, Artifact, Gmail draft tools) + a
  SessionStart hook registration.
- `.claude/hooks/session-start.sh` — ensures `editions/` and `watchlist.md`
  exist on a fresh clone.
- `editions/` — where each `artifact-<YYYY-MM-DD>.html` and the hub live.
- `watchlist.md` — rolling unresolved items.

## Important: make the daily prompt persist its output

The stored scheduled prompt must **commit and push** at the end, or the archive
still won't survive. Add this as the final step of the prompt:

```
Finally, persist state: from the repo root run
  git add editions/ watchlist.md
  git commit -m "brief: <YYYY-MM-DD>"
  git push -u origin <default-branch>
so tomorrow's run can read the last 10 editions.
```

The Artifact hub URL stays constant across runs, so email links never change.
