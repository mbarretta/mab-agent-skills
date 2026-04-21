# Opt-in Hook: Placeholder Guard

The evaluator already fails any task whose diff introduces placeholder markers. But evaluators are invoked once per task, after implementation — catches happen after the wasted effort.

Users who want placeholder hits caught **at the moment of Edit/Write** can install a PostToolUse hook. It's opt-in, not shipped with the skill, and lives in `settings.json` — the same place the harness has otherwise avoided touching.

**Install only if** you've hit the failure mode at least once. Premature hooks are friction.

## What it does

- Runs after every `Edit` or `Write` tool call.
- Greps the file content that was just written for placeholder markers.
- If any new placeholder is detected, returns a non-zero exit with a reminder. Claude Code surfaces the exit payload as a tool-call error, which the main agent will see and correct.

Covered markers (regex, word-boundary where sensible):
- `TODO`, `FIXME`, `XXX`, `HACK`
- `NotImplementedError`, `todo!()`, `unimplemented!()`
- `throw new Error("not implemented")`
- `TBD`, `???`, `lorem ipsum`
- Bare `pass` as a function body (Python), bare `...` (Python), empty markdown headings

## Snippet for `~/.claude/settings.json` (or project `.claude/settings.json`)

```jsonc
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/skills/harness/scripts/placeholder-guard.sh"
          }
        ]
      }
    ]
  }
}
```

The `command` points at a small shell script (no Python, no deps beyond `grep` and `jq`). Keep the script under the skill's `scripts/` subdirectory so it's discoverable and lives with the skill.

## Reference script

Save as `~/.claude/skills/harness/scripts/placeholder-guard.sh`, make it executable (`chmod +x`):

```bash
#!/usr/bin/env bash
# PostToolUse hook: flag new placeholder markers in Edit/Write output.
# Exits 0 to allow; exits 2 with a message to block & reminder the agent.

set -euo pipefail

payload=$(cat)                     # Claude Code pipes the tool-call JSON on stdin
tool_name=$(jq -r '.tool_name // ""' <<<"$payload")
file_path=$(jq -r '.tool_input.file_path // ""' <<<"$payload")

# Only care about Edit/Write with a file path on disk
[[ "$tool_name" == "Edit" || "$tool_name" == "Write" ]] || exit 0
[[ -f "$file_path" ]] || exit 0

# Placeholder patterns. Keep these tight — false positives are friction.
patterns=(
  '\bTODO\b' '\bFIXME\b' '\bXXX\b' '\bHACK\b'
  'NotImplementedError' 'todo!\(\)' 'unimplemented!\(\)' 'unreachable!\(\)'
  'throw new Error\("not implemented"\)'
  '\bTBD\b' '\?\?\?' '[Ll]orem ipsum'
)

hits=()
for p in "${patterns[@]}"; do
  if grep -nE "$p" "$file_path" >/dev/null 2>&1; then
    line=$(grep -nE "$p" "$file_path" | head -1)
    hits+=("$p -> $line")
  fi
done

if [[ ${#hits[@]} -gt 0 ]]; then
  {
    echo "harness: placeholder markers found in $file_path"
    printf '  - %s\n' "${hits[@]}"
    echo "Remove them or finish the implementation before continuing."
  } >&2
  exit 2
fi

exit 0
```

Notes:
- Exit 2 is Claude Code's block-and-explain signal for hooks; the message on stderr is shown to the main agent.
- This deliberately does not try to distinguish "new" vs "pre-existing" markers — if the file currently contains one after your edit, the author needs to look. Hooks don't need git context to be useful.
- If this is too aggressive for your repo (e.g., lots of legitimate `TODO(owner)` survivors), either narrow the patterns above or skip the hook and rely on the evaluator's diff-scoped check.

## Wiring it up

The easiest path is the `update-config` skill:

```
/update-config add a PostToolUse hook matching Edit|Write that runs ~/.claude/skills/harness/scripts/placeholder-guard.sh
```

…or edit `~/.claude/settings.json` manually with the snippet above.

To remove later, delete the entry from `settings.json`. No other state to clean up.

## Scope

Per-project override: if you want the hook only on specific repos, put the snippet in `.claude/settings.json` at the project root instead of the global one. The guard script stays where it is (under the skill directory) — only the hook registration differs.

Does not write to or rely on the plan JSON. Independent of whether `/harness` is the current flow — the hook fires on every Edit/Write, harness or not. That is the intended blast radius; if you want harness-only scope, the evaluator already provides it.
