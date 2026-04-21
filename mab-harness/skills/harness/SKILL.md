---
name: harness
description: "Drive structured software-or-design work through a plan → implement → evaluate loop with a skeptical subagent gate. Use when the user pastes feedback, describes a bug/feature/spec/doc to build, asks to run a backlog end-to-end, or invokes `/harness`. Supports both development (code + tests) and design (specs, docs, proposals) work. One subagent-gated task per session; state persists in a single plan JSON per work item."
---

# Harness

A lean, Claude-Code-native workflow for autonomous development and design work. Single skill, one subagent, zero Python, zero per-project configuration files. State lives in one JSON file per work item under `.claude/plans/` (or `~/.claude/plans/` if no project-local dir exists).

Principles drawn from: Anthropic's harness design (Mar 2026), Anthropic's effective harnesses (Nov 2025), OpenAI's Codex harness engineering (Feb 2026), and the Ralph Wiggum technique (Jul 2025). The research consensus, distilled:

1. Separate generator from evaluator — models grade themselves too generously.
2. State in files, not context — machine-mutable parts go in JSON.
3. One task per session — baseline-verify before building, commit after.
4. Evaluator gates completion against testable acceptance criteria; evaluator actively verifies, not just reads.
5. Calibrate evaluators with worked examples; weight critical criteria explicitly.
6. Search before build — the #1 silent failure mode is asserting absence without grep.
7. Capture capability gaps back into the repo when the loop exhausts.
8. Strip scaffolding that is not load-bearing.

## Invocation modes

| User says / types | Behavior |
|---|---|
| `/harness` with a request | Full flow: triage → clarify → plan → execute → evaluate → commit, one task at a time |
| `/harness next` | Pick the most recent plan (or prompt to choose), run exactly one next-available task, exit |
| `/harness plan "<request>"` | Triage + plan only; no execution. Useful before walking away |
| `/harness evaluate <slug> [task-id]` | Re-run the evaluator on a task without re-implementing |
| `/harness status` | Show active plans and task progress — reads `_index.json` (see `references/status-index.md`) |
| `/harness isolate <slug>` | Opt-in: run phases 5–7 inside an `EnterWorktree` so the mutation happens on a throwaway branch |
| Paste feedback/bugs into a fresh session | Auto-detect and offer to enter the flow |

For unattended batch runs, compose with the existing `loop` skill: `/loop 20m /harness next`. The harness does not own its own daemon.

## Phase map (main agent)

```
Intake → Triage → Clarify (if needed) → Plan → Execute one task → Evaluate → Commit → next task or exit
                                                      ↓ 2x FAIL
                                              Capability-gap capture
```

Each phase has a short section below. When a phase has nontrivial detail, follow the reference file it points to rather than expanding inline.

### 1. Intake

Read what the user gave you. Categorize the whole batch: is it bugs, feature work, a spec/doc to write, mixed? Do not assume — if the request is ambiguous, treat it as a triage case.

### 2. Triage

For each item, decide:
- **kind**: `bug | feature | improvement | chore | design | spec`
- **mode**: `dev` (code changes + verification) | `design` (prose/spec artifacts with rubric eval) | `mixed` (both)
- **priority**: 1..N

Present the triage as a numbered list and confirm ordering with the user before planning, unless there is only one item.

### 3. Clarify

Use `AskUserQuestion` to resolve real gaps. Rules:
- Max **4 questions**, max **2 rounds**.
- Every question has concrete options the user can pick from (don't make them free-type).
- Skip the phase entirely if the request is already specific.
- Never ask about style preferences the user's CLAUDE.md already answers.

### 4. Plan

See `references/plan-schema.md` for the full schema. Short version:

1. Pick a slug: `{fix|feat|improve|chore|design|spec}-{kebab}`, ≤ 40 chars.
2. Decide plan path:
   - If `.claude/plans/` exists in the project, use `.claude/plans/{slug}.json`.
   - Otherwise use `~/.claude/plans/{slug}.json`.
3. Discover the verification command (for `dev`/`mixed`):
   - Grep CLAUDE.md for `test` / `build` / `verify` hints.
   - Otherwise detect from project markers: `Makefile` → `make check` if that target exists; `package.json` scripts (prefer `test` + `typecheck` + `lint`); `Cargo.toml` → `cargo check && cargo test`; `pyproject.toml` → `pytest` (+ `ruff`/`mypy` if present); `go.mod` → `go test ./...`.
   - If no markers and the task is code-producing, ask once.
   - For pure design work, leave `verification` as `""`.
4. Decompose into tasks:
   - Each task should fit in ~1–2 hours of focused work.
   - Every task gets specific `acceptance_criteria` (dev) or `rubric_targets` (design). AC items that would ship-block a user go into object form with `critical: true`; everything else stays non-critical.
   - Every task gets a one-sentence `why` so the evaluator respects intent on close calls.
   - Set `depends_on` where ordering matters.
   - Ambition: favor one coherent deliverable over granular fragments. Defer how-to detail to execution.
5. Write the plan JSON; update `_index.json` (see `references/status-index.md`); echo the plan back to the user and confirm before executing.

### 5. Execute one task

Follow `references/session-protocol.md`. The core steps, abbreviated:

1. Read the plan JSON and pick the first task where `status: pending` and all `depends_on` are `complete`.
2. Flip it to `in_progress` and save.
3. **Baseline verify** — run `plan.verification` if set. If it fails, fix regressions from a prior session first; otherwise commit nothing and surface the break.
4. Implement:
   - **4a. Search before build** — grep/glob for existing utilities that match the task before writing new code.
   - **dev**: TDD — write/adjust tests first where feasible, then code to green.
   - **design**: draft the artifact against the rubric; read your own draft critically before handoff.
5. Re-run verification; iterate locally until green.
6. Self-audit: grep modified code for language-appropriate placeholder markers (`TODO`, `FIXME`, `NotImplementedError`, `pass` in new functions, `unimplemented!`, empty function bodies, etc.). Any hit = not done; fix or remove.
7. Append a short `log` entry. If the implementation hinges on a non-obvious invariant, capture the *why* there.
8. Hand to evaluator (phase 6).

### 6. Evaluate (hard gate)

Spawn the evaluator subagent via the `Agent` tool with `subagent_type: harness-evaluator`. Its definition lives at `~/.claude/agents/harness-evaluator.md` and it carries a skeptical, read-only posture in a fresh context.

Prompt template to fill in:

```
You are evaluating task "{task.id}: {task.title}" from plan {slug}.

Plan file: {absolute path to plan.json}
Guide file: {absolute path to this skill's references/evaluator-guide.md}
Mode: {dev | design | mixed}
Verification command (if set): {plan.verification}

Read the plan file to see the task's acceptance_criteria (dev) or rubric_targets (design) and the task's `why`.
Use git to inspect what changed since the last task's commit (or since plan.created if none):
  git log --oneline --since="{plan.created}" -- .
  git diff {previous commit}..HEAD -- {files touched}

Follow the Guide file above, including the step 0 environment probe and the three few-shot
examples. Use Playwright MCP tools if the diff touches UI files and an AC describes user-visible
behavior.

Return a verdict block in exactly this format:

VERDICT
overall: PASS | FAIL
verification: PASS | FAIL | SKIP
criteria: PASS | FAIL
criteria_critical: PASS | FAIL | SKIP
quality: PASS | FAIL
no_placeholders: PASS | FAIL
issues:
- {specific issue, one per line; cite ac ids where applicable}
notes: {one-paragraph summary}
END_VERDICT
```

Read the subagent's final message, extract the verdict block, and append it to `plan.tasks[*].verdicts[]`.

**Retry policy**: on `FAIL`, re-enter phase 5 with the evaluator's `issues:` injected into the implementer instructions, prioritizing critical-AC issues. Maximum **2 retry cycles**. After two failures, enter phase 6a — do not loop forever and do not silently mark complete.

### 6a. Capability-gap capture (retry exhaustion)

On 2 consecutive FAIL verdicts, stop the implement-evaluate loop and follow `references/session-protocol.md` step 9:

1. Append a `gap_notes` entry to the plan JSON describing the failure pattern (cite ≥1 verdict bullet).
2. Ask the user via `AskUserQuestion` between three named options (default is draft CLAUDE.md addition).
3. Execute the chosen option. If they pick "draft CLAUDE.md addition," propose a one-line addition to the nearest `CLAUDE.md`, show the diff, write only on approval, then retry with counter reset. This is the only code path that touches `CLAUDE.md`.

### 7. Commit

On `PASS`:

- **Interactive mode**: propose a one-sentence commit message, show staged files, and ask before committing. Respect the user's CLAUDE.md: one sentence, no Claude attribution, no multi-line body.
- **Batch mode** (invoked by `/loop` or `/harness next` in a non-interactive setting): commit with the same one-sentence, no-attribution rule. Do not push unless explicitly authorized.

Mark the task `complete` in the plan JSON after the commit succeeds. Refresh the plan's row in `_index.json`.

If `/harness isolate <slug>` was used, the commit lands on the worktree branch; surface the branch name to the user so they can merge when ready. Don't auto-merge to main.

### 8. Loop or exit

- Interactive: ask whether to continue with the next task or stop.
- `/harness next`: always exit here.
- Under `/loop`: exit; the outer loop re-invokes us.

## Rules that apply to every phase

- **Never self-evaluate.** A task is complete only after the `harness-evaluator` subagent returns PASS.
- **Never edit the plan JSON to fabricate progress.** Only the true status transitions are allowed: `pending → in_progress → complete`, or `→ blocked` with an explanatory `log` entry.
- **Never skip the subagent gate to save time.** If the user explicitly says skip-eval, record that in `plan.log` so the skip is auditable.
- **Anti-assumption rule.** Before claiming a symbol, file, utility, or feature is missing, run the grep that would find it. Log the command if the negative result is load-bearing.
- **Respect the user's global CLAUDE.md.** Commit rules, testing rules, language preferences apply here.
- **Prefer reading a file over asking a question.** Discovery beats clarification for things the repo already answers.
- **Files modified, not files mentioned.** Evaluator scopes to what `git diff` actually shows, not what the plan hints.
- **CLAUDE.md is writable only through the capability-gap-capture branch**, and only with explicit user approval.

## Subagent offload

Context is scarce. The main agent should delegate heavy reads.

- Spawn an `Explore` subagent when you need ≥ 3 related greps/globs OR expect to read > 10 files to answer one question.
- Spawn `Plan` when the task has multiple viable approaches and the tradeoff is non-obvious.
- Keep writes in the main context. Writes are cheap; reads are where context dies.
- Reserve the `harness-evaluator` subagent strictly for the phase 6 gate — never spawn it to self-grade.

## Optional: mechanical placeholder enforcement

For teams who want the placeholder self-audit enforced at tool-call time (not just by the evaluator), `references/hooks.md` documents an opt-in PostToolUse hook. It blocks Edit/Write calls that introduce new `TODO` / `FIXME` / `NotImplementedError` / `todo!` / `???` / `TBD` markers. Not installed by default. Pairs well with the `update-config` skill.

## References (load on demand)

- `references/plan-schema.md` — JSON structure, critical/non-critical ACs, `why` and `gap_notes` fields, allowed transitions.
- `references/session-protocol.md` — the step-by-step execution loop, including search-before-build, capture-the-why, capability-gap capture, and subagent offload.
- `references/evaluator-guide.md` — rubrics, active probe step 0, weighted criteria, three worked few-shot examples, verdict format.
- `references/status-index.md` — `_index.json` format and the `/harness status` read path.
- `references/hooks.md` — opt-in PostToolUse placeholder-scan recipe.

## What this harness deliberately does not do

- No dedicated daemon or Python runtime.
- No required project-local config file — the plan itself carries the verification command; the index is cheap and optional.
- No per-project subagents — one global `harness-evaluator` is sufficient.
- No compaction fiddling — Claude Code's automatic compaction is enough for single-task sessions; longer batches use the `loop` skill to get a fresh context per iteration.
- No build-flag matrix — one skill, invoked the same way regardless of language or stack.
- No writes to `CLAUDE.md` outside the gap-capture branch, and none without approval.
