# harness

A Claude Code skill that drives structured software-or-design work through a **plan → implement → evaluate** loop with a skeptical subagent gate.

No Python. No per-project config files. State lives in one JSON per work item under `.claude/plans/` (project-local if present, else `~/.claude/plans/`).

## Why

Long-running agentic coding needs more than a prompt. The research consensus — from Anthropic's harness-design and effective-harnesses posts, OpenAI's Codex harness-engineering essay, and Huntley's Ralph Wiggum technique — converges on a handful of practices:

1. Separate the generator from the evaluator; models grade themselves too generously.
2. Put state in files, not context; JSON survives context resets.
3. One task per session; baseline-verify before building, commit after.
4. Evaluators actively verify (run the build, probe the UI) rather than read source.
5. Calibrate evaluators with worked examples; weight critical criteria explicitly.
6. Search before build; the #1 silent failure is asserting absence without grep.
7. When the loop exhausts, capture the capability gap back into the repo.
8. Strip scaffolding that isn't load-bearing.

This plugin is a Claude-Code-native implementation of those practices.

## Install

Via the marketplace at the repo root:

```bash
/plugin marketplace add mbarretta/mab-agent-skills
/plugin install mab-harness@mab-agent-skills
```

Or clone + symlink, see the [root README](../README.md#manual-install-no-marketplace).

## Usage

After install, the skill is discovered as `/harness` (or `mab-agent-skills:harness` depending on your install).

| You type | What happens |
|---|---|
| `/harness` with a request | Full flow: triage → clarify → plan → execute → evaluate → commit, one task at a time |
| `/harness next` | Pick the most recent plan, run exactly one next-available task, exit |
| `/harness plan "<request>"` | Triage + plan only; no execution |
| `/harness evaluate <slug> [task-id]` | Re-run the evaluator on a task without re-implementing |
| `/harness status` | List plans and task progress |
| `/harness isolate <slug>` | Opt-in: run phases 5–7 in a throwaway git worktree |
| Paste feedback into a fresh session | Auto-detect and offer to enter the flow |

For unattended batch runs, compose with the `loop` skill: `/loop 20m /harness next`.

## What's in the plugin

```
harness/
├── .claude-plugin/plugin.json
├── agents/
│   └── harness-evaluator.md           # Skeptical read-only subagent (the gate)
├── skills/harness/
│   ├── SKILL.md                       # Entry point, invocation modes, phase map
│   └── references/
│       ├── plan-schema.md             # JSON schema for the plan file
│       ├── session-protocol.md        # Step-by-step execution loop
│       ├── evaluator-guide.md         # Evaluator rubric + 3 few-shot examples
│       ├── hooks.md                   # Opt-in PostToolUse placeholder guard
│       └── status-index.md            # `_index.json` schema for `/harness status`
└── scripts/
    └── placeholder-guard.sh           # Opt-in hook script referenced by hooks.md
```

## Required and optional tools

- Required: Claude Code CLI, `git`, standard verification tooling for your language (the skill auto-detects `make`, `npm`, `cargo`, `pytest`, `go test`, etc.).
- Optional: `jq` (for the placeholder-guard hook). Playwright MCP plugin (for active UI verification during evaluation).

## Design notes

The skill deliberately does not:
- Ship a daemon or Python runtime.
- Require a project-local config file — the plan JSON carries the verification command.
- Use per-project subagents — one global `harness-evaluator` is sufficient.
- Fiddle with Claude Code's compaction — for long batches, compose with the `loop` skill instead.
- Touch `CLAUDE.md` outside the capability-gap-capture branch, and not without user approval.

## Research

The practices distilled here come from:

- Anthropic, *Harness Design for Long-Running Application Development* (Mar 2026).
- Anthropic, *Effective Harnesses for Long-Running Agents* (Nov 2025).
- OpenAI, *Harness Engineering for Codex* (Feb 2026).
- Geoffrey Huntley, *The Ralph Wiggum Technique* (Jul 2025).

The sibling repo [mbarretta/harness](https://github.com/mbarretta/harness) has the full research archive and the consolidated best-practices checklist this plugin was audited against.

## License

MIT. See [LICENSE](../LICENSE).
