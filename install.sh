#!/usr/bin/env bash
#
# Bartender installer — Claude Code + Codex
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/<owner>/<repo>/main/install.sh | bash
#
# Flags (when run locally):
#   --claude-only    install only for Claude Code
#   --codex-only     install only for Codex
#   --local          copy from the current checkout instead of downloading

set -euo pipefail

REPO="${BARTENDER_REPO:-<owner>/<repo>}"
BRANCH="${BARTENDER_BRANCH:-main}"
BASE="https://raw.githubusercontent.com/${REPO}/${BRANCH}"

MODE="both"
SOURCE="remote"

for arg in "$@"; do
  case "$arg" in
    --claude-only) MODE="claude" ;;
    --codex-only)  MODE="codex"  ;;
    --local)       SOURCE="local" ;;
    -h|--help)
      sed -n '1,16p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *)
      echo "unknown argument: $arg" >&2
      exit 1
      ;;
  esac
done

fetch() {
  # $1 = source path relative to repo root, $2 = destination absolute path
  if [[ "$SOURCE" == "local" ]]; then
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cp "${script_dir}/$1" "$2"
  else
    curl -fsSL "${BASE}/$1" -o "$2"
  fi
}

install_claude() {
  local dir="${HOME}/.claude/skills/bartender"
  mkdir -p "$dir"
  fetch "SKILL.md" "${dir}/SKILL.md"
  echo "[ok] Claude Code  -> ${dir}/SKILL.md"
}

install_codex() {
  local dir="${HOME}/.codex/prompts"
  mkdir -p "$dir"
  fetch "codex/bartender.md" "${dir}/bartender.md"
  echo "[ok] Codex        -> ${dir}/bartender.md"
}

echo "Installing Bartender..."

case "$MODE" in
  claude) install_claude ;;
  codex)  install_codex  ;;
  both)   install_claude; install_codex ;;
esac

cat <<'EOF'

Bartender is installed.

  Claude Code: restart your session. The skill triggers automatically when
               it's late or you've been at it for a while.
  Codex:       type /bartender in a session.

Get some sleep.
EOF
