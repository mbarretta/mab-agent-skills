# Plan Schema

One JSON file per work item. Path: `.claude/plans/{slug}.json` (project-local if `.claude/plans/` exists) or `~/.claude/plans/{slug}.json`.

The plan is the single source of truth for the harness. Machine-mutable parts are JSON (status fields, verdicts). Freeform narration lives in the `log` array as timestamped entries. Nothing else — no separate progress doc, no separate feedback directory.

If `.claude/plans/` is tracked by git in the host repo, commit the plan JSON alongside the work it describes — future sessions and code review benefit from the plan being versioned next to the diff. If it is `.gitignored` (or there's no repo), the plan lives locally and still functions.

## Schema

```jsonc
{
  "slug": "feat-csv-export",                // filename stem, kebab-case, ≤ 40 chars
  "title": "Add CSV export to dashboard",
  "kind": "bug | feature | improvement | chore | design | spec",
  "mode": "dev | design | mixed",           // selects which rubric the evaluator uses
  "created": "2026-04-21",
  "status": "planned | in_progress | complete | blocked",
  "context": "Short paragraph: why this exists, links to feedback or source, constraints.",

  "verification": "npm run test && npm run typecheck",
  // Command string run in a shell at the repo root. Empty string means no programmatic verification
  // (common for pure design tasks). Detected at plan time; kept in the plan so it travels with the work.

  "tasks": [
    {
      "id": "1",
      "title": "Wire up export button and handler",
      "status": "pending | in_progress | complete | blocked",
      "depends_on": [],                     // list of task ids that must be complete first
      "files": ["src/components/Dashboard.tsx"],   // hint only; evaluator uses git diff for truth

      "why": "Sales enablement needs per-tab exports before the March demo; current workaround is a screenshot.",
      // One-sentence reason this task exists. Feeds the evaluator's context so taste calls can respect intent.

      // For dev / mixed mode. Objects preferred; plain strings still accepted for backwards compat.
      "acceptance_criteria": [
        { "id": "ac1", "text": "Clicking the Export button triggers a file download named dashboard-{YYYYMMDD}.csv", "critical": true },
        { "id": "ac2", "text": "The CSV has a header row matching the visible table columns exactly", "critical": true },
        { "id": "ac3", "text": "Error toast appears if the user is offline; no download attempted" }
      ],

      // For design / mixed mode:
      "rubric_targets": {
        "audience": "engineering leads reviewing the proposal",
        "format": "RFC-style markdown, 600–1000 words",
        "must_cover": ["problem statement", "alternatives considered", "recommended approach", "open questions"],
        "must_not": ["ship-time estimates", "team assignments"]
      },

      "notes": "free-form; appendable without schema drift",

      "verdicts": [
        {
          "timestamp": "2026-04-21T14:22:00-04:00",
          "overall": "FAIL",
          "verification": "PASS",
          "criteria": "FAIL",
          "criteria_critical": "FAIL",
          "quality": "PASS",
          "no_placeholders": "PASS",
          "issues": [
            "ac1: Filename uses underscore separator, spec says hyphen",
            "ac3: No offline error path; handler silently catches fetch() rejection"
          ],
          "notes": "Core happy path works; ac1 is critical so overall fails."
        }
      ]
    }
  ],

  "gap_notes": [
    // Appended only when retries exhaust (≥ 2 consecutive FAIL verdicts on the same task).
    // Candidate material for CLAUDE.md additions. See session-protocol.md step 9.
    { "timestamp": "2026-04-21T15:01:00-04:00", "task_id": "1", "note": "Agent repeatedly used underscore separators — repo convention is hyphen; candidate CLAUDE.md line." }
  ],

  "log": [
    { "timestamp": "2026-04-21T13:00:00-04:00", "note": "Plan created from pasted feedback." },
    { "timestamp": "2026-04-21T14:18:00-04:00", "note": "Task 1 implemented; tests green; handoff to evaluator." }
  ]
}
```

## Rules for plan edits

- **Immutability of identity fields**: `slug`, `created`, `tasks[*].id`, `acceptance_criteria[*].id`. Never rewrite them.
- **Status transitions** — allowed only:
  - Plan: `planned → in_progress → complete`, any state → `blocked`, `blocked → in_progress`.
  - Task: same transitions as plan.
- **`depends_on` is append/remove, not reorder-sensitive.** The task id, not its position, is the referent.
- **`acceptance_criteria` / `rubric_targets`** should not be edited after a task enters `in_progress` except to *narrow* them in response to a clarify answer. If requirements genuinely change, set the task to `blocked`, write a log entry explaining why, and create a new task. The `critical` flag may only be loosened (true → false), never tightened mid-flight.
- **`verdicts[]`** is append-only. Never rewrite history.
- **`gap_notes[]`** is append-only. Never delete; these are the trail the user follows when deciding whether to update CLAUDE.md.
- **`log[]`** is append-only, reverse-chronological allowed if preferred. Timestamp every entry.
- **`files[]`** is a hint used to focus initial context only. The evaluator trusts `git diff`, not this list.

## Acceptance criteria: object vs string form

The schema accepts both:

- **Object form (preferred)**: `{ "id": "ac1", "text": "...", "critical": true }`. Lets the evaluator cite specific AC ids in `issues:` and drives the `criteria_critical` verdict field.
- **String form (legacy)**: `"Clicking the export button triggers..."`. The skill normalizes on read: id becomes `ac{index}` (1-based), `critical` defaults to `false`.

Rule of thumb for `critical`: mark AC items `true` when failing them makes the change ship-blocking or user-visible in the first 30 seconds. Everything else stays `false`. Err toward fewer critical items — if everything is critical, nothing is.

## `why` field

One sentence on why the task exists. Lives at the task level (not a replacement for plan-level `context`, which is broader). The evaluator reads it when deciding whether to blur a style line in favor of the intent — e.g. a benchmark task whose `why` is "prove it's faster than the baseline" should not fail the verdict on a missing happy-path test if the AC never asked for one.

Empty string is allowed but discouraged. If you can't state the why in one sentence, the task is probably overscoped.

## Verdict block fields

Every verdict must include:
- `overall` — PASS / FAIL; conjunction of the fields below, with `criteria_critical: FAIL` forcing overall FAIL regardless of other fields.
- `verification` — PASS / FAIL / SKIP.
- `criteria` — overall AC pass status (dev) or rubric pass status (design).
- `criteria_critical` — PASS / FAIL / SKIP; aggregates AC entries with `critical: true` only. SKIP only when no AC is marked critical.
- `quality` — PASS / FAIL.
- `no_placeholders` — PASS / FAIL.
- `issues[]` — dash-bullet list; ids the specific AC when applicable (`ac1: ...`).
- `notes` — one short paragraph.

## Minimal plan example (design mode)

```jsonc
{
  "slug": "design-agent-eval-rubric",
  "title": "Propose an evaluation rubric for internal coding agent quality",
  "kind": "design",
  "mode": "design",
  "created": "2026-04-21",
  "status": "planned",
  "context": "Leadership asked for a one-pager that the team can adopt without further debate. Must be model-agnostic and avoid scoring systems that drift over time.",
  "verification": "",
  "tasks": [
    {
      "id": "1",
      "title": "Draft rubric v1 as RFC markdown",
      "status": "pending",
      "depends_on": [],
      "files": ["docs/rfcs/agent-eval-rubric.md"],
      "why": "Unblock the coding-agent procurement meeting; without a rubric, each vendor demo drifts into taste debates.",
      "rubric_targets": {
        "audience": "staff engineers skimming before a 30-minute meeting",
        "format": "RFC-style markdown, 600–900 words, numbered criteria",
        "must_cover": [
          "problem statement",
          "criteria with hard thresholds",
          "calibration plan",
          "known limitations"
        ],
        "must_not": ["vendor comparisons", "detailed tool selection"]
      },
      "notes": "",
      "verdicts": []
    }
  ],
  "gap_notes": [],
  "log": []
}
```

## Slug conventions

- `fix-*` for bugs
- `feat-*` for features
- `improve-*` for refactors / perf / dx
- `chore-*` for deps / infra
- `design-*` for design artifacts (proposals, rubrics, wireframes-as-markdown)
- `spec-*` for specifications / RFCs

Examples: `fix-csv-naming`, `feat-export-csv`, `improve-test-speed`, `chore-bump-node-22`, `design-agent-eval-rubric`, `spec-auth-refresh-flow`.
