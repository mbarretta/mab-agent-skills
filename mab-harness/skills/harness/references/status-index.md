# Plan Index & `/harness status`

The harness keeps a small index file alongside plans so `/harness status` can be cheap — a single read, no globbing, no per-plan parse. The index is optional scaffolding: if it's missing, the skill falls back to globbing `*.json` in the plan directory.

## Location

Same directory as the plans:
- `.claude/plans/_index.json` (project-local, if `.claude/plans/` exists in the cwd)
- `~/.claude/plans/_index.json` (global fallback)

The underscore prefix keeps it out of the way alphabetically and signals "not a plan."

## Schema

```jsonc
{
  "plans": [
    {
      "slug": "feat-csv-export",
      "title": "Add CSV export to dashboard",
      "status": "planned | in_progress | complete | blocked",
      "mode": "dev | design | mixed",
      "tasks_total": 3,
      "tasks_complete": 1,
      "updated": "2026-04-21T15:04:00-04:00",
      "path": ".claude/plans/feat-csv-export.json"     // relative to the index file
    }
  ]
}
```

Only data that `/harness status` wants to show appears here. Everything load-bearing (AC, verdicts, log) still lives in the plan JSON.

## When the skill writes the index

Four touch points, each an atomic read-modify-write of the index file:

1. **Plan creation** (phase 4 of SKILL.md) — append a row.
2. **Task status transition** (`pending → in_progress`, `in_progress → complete`, `… → blocked`) — update `status`, `tasks_complete`, and `updated`.
3. **Plan completion** (last task marks complete) — set `status: complete`, stamp `updated`.
4. **Plan deletion** — if the user removes a plan JSON manually, the next `/harness status` call should notice the missing file and prune the row. Treat a broken `path` as a hint to remove, not an error.

The skill never writes arbitrary fields to the index. If you need more data, read the plan JSON.

## When the skill reads the index

`/harness status` is the primary reader. The skill's flow:

1. Try to read `_index.json` in the project-local plan dir; fall back to global.
2. If both are missing, glob `.claude/plans/*.json` (project first, then `~/.claude/plans/*.json`) and reconstruct the view on the fly. Do **not** create an index in this fallback path — the user may have deliberately pruned it. Surface a one-liner: "No index found; reconstructed from glob. Run `/harness plan …` to start a new one, or create the index implicitly by completing a task."
3. Present active (not complete) plans first, then complete, then blocked. Newest-updated first within each group.

## Display format (reference)

`/harness status` output is prose, not JSON. Example:

```
Active plans
  feat-csv-export       dev      1/3 tasks   updated 2h ago    .claude/plans/feat-csv-export.json
  design-eval-rubric    design   0/1 tasks   updated 1d ago    .claude/plans/design-eval-rubric.json

Blocked
  fix-offline-toast     dev      0/2 tasks   updated 5d ago    .claude/plans/fix-offline-toast.json   ← 2x FAIL; see gap_notes

Complete
  chore-bump-node-22    chore    1/1 tasks   completed 3d ago
```

Keep it dense and grep-friendly — users read this from the terminal, not a dashboard.

## Concurrency notes

Two `/harness` sessions writing the same index at the same time is rare but survivable:

- The index is small; rewrites are cheap.
- Always read → modify → write. Never append-only.
- If the index fails to parse (e.g., partial write from an interrupted session), log a one-line warning, back it up to `_index.json.broken-{timestamp}`, and rebuild from glob. Don't crash.

No locking required for single-user workflows. If you find yourself wanting locks, you're probably using the harness wrong — it's one-task-per-session by design.

## Fallback posture

The index is a convenience, not a contract. Anything that's true of the plans must be recoverable from the plan JSONs alone. If you delete `_index.json`, the next `/harness status` runs a glob; on the next write event, the index is rebuilt. No data loss.
