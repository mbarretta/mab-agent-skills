# se-leader

Work planning system for a Sales Engineering leader. Covers the full rhythm of the job: quarterly goal-setting, weekly execution, team development, and market intelligence.

Built around the reality that SE leaders are simultaneously managing pipeline, people, and product feedback — all at once.

## Install

```
/plugin install se-leader@mab-agent-skills
```

## Skills

### `se-leader`

Triggered by phrases like "help me plan my week at work", "how's the quarter looking?", "what should I focus on this week?", "what does my team need?", "help me plan the quarter", "review pipeline", or "what are we not ready for in the field?".

**Modes:**

| Mode | Description |
|------|-------------|
| **Quarterly Setup** | Decompose quota → pipeline coverage target → pipegen gap → activity plan → team goals → build list. Produces a `work/WORK_PLAN.md` that persists across the quarter. |
| **Weekly Review** | Pipeline health → pipegen activity tracking → team coaching priorities (with Obsidian 1:1 context if configured) → market signals → personal top 3. ~20-30 min. |
| **Market Intelligence** | Structured capture of customer signals, competitive encounters, product gaps, and objection patterns. Synthesizes into a field intelligence report for Product/PMM. |
| **Quarter Close** | Retrospective (goal scorecard + team assessment + field intelligence summary) + feed-forward into next quarter's setup. |

**Persistent state:** `work/WORK_PLAN.md` in your workspace — read and updated each session.

**Obsidian integration:** Create `work/CONFIG.md` with your vault path and 1:1 folder name, and the Weekly Review will pull recent 1:1 notes for coaching context automatically.

```markdown
obsidian_vault: /path/to/your/vault
1:1_folder: 1:1s
```

**Reference files bundled:**
- `metrics.md` — SE leader KPIs (pipeline, pipegen, team health, market intelligence), leading vs. lagging, healthy ranges, how to present field intel to Product
- `quarterly-planning.md` — Quota decomposition math, pipeline coverage ratios, pipegen activity planning, anti-patterns
- `team-development.md` — SE growth arc, 1:1 framework, coaching (GROW model), enablement planning, retention signals, IDPs

## Connection to life-goals

The `se-leader` skill reads `goals/GOALS.md` from the `life-goals` plugin (if installed) to align quarterly work priorities with career domain goals — so work planning is grounded in the larger system, not just quota.
