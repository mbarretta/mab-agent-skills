# Session Protocol

How to execute exactly one task from a plan. Runs in the main agent's context; the evaluator runs in its own subagent context.

Each step is a discrete tool call or small set of calls. Don't merge steps — the structure is what keeps the session recoverable after a context reset.

## Pre-flight

- Verify `git status` is clean (or only contains changes from your current in-flight work). If it's dirty with unrelated work, stop and ask the user. Do not stash silently.
- If the plan references a repository but the working directory is not inside one, surface this and ask.
- If `/harness isolate <slug>` was invoked, spin up an `EnterWorktree` before step 2 and run the rest of the protocol inside it. The plan JSON is read/written in the main tree; only code mutations happen in the worktree.

## 1. Orient

Read the plan JSON. Identify:

- The first task where `status: pending` and every id in `depends_on` has `status: complete`.
- If none exists, report the blocking tasks and exit.
- The mode (`dev | design | mixed`) and the verification command.
- The task's `why` field. Keep it in mind — it shapes close calls.

Also `git log --oneline -10` so you know the recent commits. If the most recent commit was made by a prior harness run, read its message — it is your handoff note from the last session.

## 2. Claim

Edit the plan: set the chosen task `status` to `in_progress`. Append a `log` entry with ISO-8601 timestamp and one sentence like `"Claimed task N: {title}"`.

Save before writing any code. This is the checkpoint.

## 3. Baseline verify (dev / mixed only)

Run the `plan.verification` command via Bash.

- **If it passes**: continue. Good; the prior session ended clean.
- **If it fails**: the previous session left the tree broken. Do **not** begin new work on top of it. Options:
  1. Read recent commits, understand the break, fix it under the current task's banner if directly related.
  2. Otherwise, mark the current task `blocked`, add a log entry, and exit. The user needs to know.

Always make the distinction between "my session's failing work" and "a pre-existing failure" explicit in the log.

For pure design tasks, skip this step and instead read the current state of any referenced artifact before editing it.

## 4. Implement

Load the minimum context needed. If the task has `files[]`, read those first. Use Glob/Grep to fill in references. Avoid wholesale `ls -R`.

### 4a. Search before build (mandatory)

Before writing a new function, component, helper, or file, search the repo for existing implementations that match. Run at least one concrete grep or glob and note the result in your head (or in `plan.log` if the result is surprising). Examples:

- About to add `slugify()`? Grep for `slugify|kebab-case|to-slug` first.
- About to add a new React hook for fetch-with-retry? Grep for `useFetch|retry|swr|react-query` first.
- About to create a new script under `scripts/`? Glob `scripts/**/*` before naming yours.

The rule is "look before you leap." If something already exists, reuse or extend it. If it doesn't, proceed. Skipping this step is the single most common harness failure mode; don't.

### 4b. Produce the change

**Dev / mixed:**
- If you are adding behavior, start with a failing test that expresses an acceptance criterion. Then write code until it passes. Do not invert the order.
- If you are fixing a bug, reproduce it in a test first. Then fix.
- Keep edits local to the task. Resist scope expansion — if you see a separate issue, capture it in `plan.log` and leave it.
- Keep critical AC items front-of-mind: they control the verdict. Non-critical items should still pass; if you have to trade, trade against non-critical first.

**Design / mixed:**
- Draft against the `rubric_targets`. Open with the single sentence the reader should take away. Keep to the word count.
- Read your own draft critically once before handoff — does each `must_cover` bullet get real coverage, not lip-service?

## 5. Verify

Re-run `plan.verification`. If it fails, iterate locally until green. Do not hand a failing build to the evaluator — it is a waste of their pass.

If the command is slow (> 2 minutes), run a narrower subset while iterating, then the full command before handoff.

## 6. Self-audit

Inspect what `git diff` shows. Grep the diff for placeholder markers language-appropriate to the file types you touched:

- JS/TS: `TODO`, `FIXME`, `XXX`, `throw new Error("not implemented")`, suspicious bare `return;`.
- Python: `TODO`, `FIXME`, `pass` in a function you wrote (not in `except`/`class`), `...` as a body, `raise NotImplementedError`.
- Go: `TODO`, `FIXME`, `// nolint`, empty function bodies.
- Rust: `todo!`, `unimplemented!`, `unreachable!`.
- Design docs: "lorem", `???`, `TBD`, empty headings.

Any hit that is new (not pre-existing) must be resolved before handoff. If you really mean it, a `TODO(owner)` with an owner can stay — but the evaluator will still flag it.

## 7. Log (capture the why)

Append one concise `log` entry summarizing what you changed. Two or three sentences, not a commit message — this is for the *next session's* Ralph to read.

If the implementation hinges on a non-obvious invariant, choice, or surprise, capture the *why* in the same entry. Examples of things worth capturing:

- "Used `Map` instead of `Object` because keys include dotted paths that collide with prototype methods."
- "Declined to memoize the selector — profile showed the cost was in the fetch, not the derive."
- "Test uses a fixed date (2026-01-01) because `Date.now()` made the golden file nondeterministic."

Skip the log-the-why if the change is obvious. The bar is "would a smart reader six months from now ask why this?"

## 8. Hand to evaluator

Invoke the `harness-evaluator` subagent via the `Agent` tool using the prompt template in `SKILL.md`. Wait for its verdict block.

Parse the block. Append the verdict to `plan.tasks[].verdicts[]`. The verdict's `criteria_critical` field drives whether the user is hard-blocked — any FAIL there means the overall verdict is FAIL regardless of other fields.

- **PASS** → proceed to commit (SKILL.md phase 7).
- **FAIL** → re-enter this protocol at step 4, but:
  - Carry the evaluator's `issues:` list into the implementer's mind — address each explicitly, prioritizing critical-AC issues.
  - Count the retry. After 2 failed evaluations on the same task, stop and enter step 9.

## 9. Capability-gap capture (retry exhaustion only)

When the evaluator has returned FAIL twice in a row on the same task, do not keep grinding. Something deeper is off — the task is underspecified, the repo has an implicit convention the agent keeps missing, or the task exceeds current model capability.

Do this, in order:

1. Append a `gap_notes` entry to the plan JSON: timestamp, `task_id`, one-paragraph `note` describing the pattern of failure (quote at least one verdict bullet).
2. Surface the situation to the user with three named options via `AskUserQuestion`:
   - **Draft CLAUDE.md addition** (default) — propose a one-line addition to the nearest `CLAUDE.md` that would have prevented the failure mode. Show the diff, ask before writing.
   - **Escalate context** — load more files (full-dir read of the affected package, related tests, linked specs) and re-enter step 4 with a retry counter reset to 0.
   - **Abort** — mark the task `blocked`, write a log entry explaining why, exit.

3. Execute the chosen option. If the user picks "draft CLAUDE.md addition" and approves the diff, write it, then re-enter step 4 with retries reset.

This is the only path that touches `CLAUDE.md`. Never modify `CLAUDE.md` without going through this branch and the user approving.

## Subagent offload

The main agent's context is scarce. Delegate reads that would bloat it.

Rules of thumb:

- Spawn an `Explore` subagent when you need ≥ 3 related greps/globs OR expect to read > 10 files to answer one question.
- Spawn `Plan` when the task has multiple viable approaches and the tradeoff is non-obvious — get a plan back, then execute in the main context.
- Keep writes in the main context. Writes are the cheap part; reads are where context goes to die.
- Never spawn the harness-evaluator yourself to self-grade. That subagent is reserved for the phase 8 gate.

## Anti-assumption rule

Before claiming "X does not exist" or "there is no Y in this codebase," run the grep that would find it. Paste the command you ran into `plan.log` if the negative result is load-bearing (e.g., "no existing CSV utility, so adding one" — the grep should confirm).

The most common silent failure in agentic coding is the agent asserting absence without checking. Don't do it.

## Never-do list

- Never mark a task `complete` without a PASS verdict.
- Never edit `acceptance_criteria` or `rubric_targets` to pass an evaluation.
- Never skip `git log` at the start — handoff state matters.
- Never run with a dirty tree from unrelated work.
- Never batch two tasks into one session — one task in, one task out.
- Never fabricate verdicts in the JSON; only the evaluator subagent's output populates `verdicts[]`.
- Never modify `CLAUDE.md` outside the step-9 gap-capture branch and without explicit user approval.
- Never claim a symbol or file is missing without a grep to back it up.
