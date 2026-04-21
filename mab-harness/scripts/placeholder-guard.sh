#!/usr/bin/env bash
# PostToolUse hook: flag new placeholder markers in Edit/Write output.
# Exits 0 to allow; exits 2 with a message to block & remind the agent.
# See ../skills/harness/references/hooks.md for install instructions.

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
