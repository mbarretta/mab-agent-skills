# mab-agent-skills

A personal [Claude Code](https://docs.anthropic.com/en/docs/claude-code) plugin marketplace — skills, agents, and recipes I want to carry between environments without hand-copying files.

## Install

### As a marketplace (recommended)

Add this repo as a Claude Code marketplace, then install plugins individually:

```bash
/plugin marketplace add mbarretta/mab-agent-skills
/plugin install mab-harness@mab-agent-skills
```

Claude Code stores plugin files under `~/.claude/plugins/cache/mab-agent-skills/…`; skills and agents appear automatically.

### Manual install (no marketplace)

If you just want one skill without the plugin machinery, clone and symlink:

```bash
git clone https://github.com/mbarretta/mab-agent-skills ~/src/mab-agent-skills

# harness
ln -s ~/src/mab-agent-skills/mab-harness/skills/harness ~/.claude/skills/harness
ln -s ~/src/mab-agent-skills/mab-harness/agents/harness-evaluator.md ~/.claude/agents/harness-evaluator.md
```

## Plugins in this marketplace

| Plugin | What it does |
|---|---|
| [mab-harness](./mab-harness/) | Plan → implement → evaluate loop with a skeptical subagent gate. Plan JSON state, critical/non-critical acceptance criteria, active evaluator verification (Playwright when UI touched), capability-gap capture on retry exhaustion. Distilled from Anthropic / OpenAI / Ralph Wiggum research. |

## Requirements

- Claude Code CLI ≥ 1.0 (plugin support).
- `git` for commit/verify flows used by plugins.
- `jq` for the optional `placeholder-guard.sh` hook.
- Playwright MCP plugin (`/plugin install playwright@claude-plugins-official`) if you want the harness evaluator to probe UI acceptance criteria in a browser. Optional — evaluator reports `SKIP` when missing.

## Contributing / tinkering

This is a personal repo but pull requests and issues are welcome if something is useful to you. Each plugin has its own README with install / usage / design notes.

## License

MIT. See [LICENSE](./LICENSE).
