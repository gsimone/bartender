# Bartender

A late-night sobriety check for [Claude Code](https://docs.claude.com/en/docs/claude-code) and [Codex](https://github.com/openai/codex). When it's late, or you've been at it too long, and you're about to do something with consequences, the skill interrupts with a quick comprehension check pulled from your own recent work — plus a small math twist as a cognitive baseline.

If you flunk it twice, the skill takes the keys, stashes the work, and tells you to go to bed.

## What it does

- **Triggers** before high-consequence actions: `git commit`, `git push --force`, deploys, migrations, mass deletions, large multi-file rewrites.
- **Conditions:** local time past 23:00, OR session running 6+ hours. One condition = soft check, both = full protocol with escalation.
- **Asks two questions:** one pulled from recent git activity ("what does the function you just committed actually do?"), and one 2-digit × 1-digit multiplication.
- **Escalates** in three rounds: gentle → concerned → refusal. After Round 3 it stashes the work to a WIP branch and writes a `TOMORROW.md` for future-you.
- **Anti-bypass:** if you push back on the skill mid-session, that's stronger signal to run it, not weaker. The impaired user is the one who'd want to disable it.
- **Override:** real production incidents skip the protocol entirely. The skill is for voluntary late-night coding, not on-call work.

## Install

One command, both tools:

```bash
curl -fsSL https://raw.githubusercontent.com/<owner>/<repo>/main/install.sh | bash
```

Flags:

```bash
# Just one tool
curl -fsSL https://raw.githubusercontent.com/<owner>/<repo>/main/install.sh | bash -s -- --claude-only
curl -fsSL https://raw.githubusercontent.com/<owner>/<repo>/main/install.sh | bash -s -- --codex-only
```

Or manually:

- **Claude Code:** copy `SKILL.md` to `~/.claude/skills/bartender/SKILL.md`
- **Codex:** copy `codex/bartender.md` to `~/.codex/prompts/bartender.md`

## Use

### Claude Code

You don't invoke it. The skill triggers automatically based on the conditions above. Restart your session once after install so Claude Code picks up the new skill.

### Codex

Type `/bartender` to run the check manually. Codex doesn't have skill auto-triggering, so it's an explicit slash command.

## How it works

Bartender is a prompt, not a tool. The repo contains two files:

- `SKILL.md` — the Claude Code skill. Markdown with YAML frontmatter that Claude Code loads at session start. The `description` field is what Claude consults to decide when to invoke the skill, which is why this skill triggers on time-of-day and session-length signals combined with high-consequence actions.
- `codex/bartender.md` — the Codex custom prompt. Plain markdown injected when you type `/bartender`.

## Uninstall

```bash
rm -rf ~/.claude/skills/bartender ~/.codex/prompts/bartender.md
```

## License

MIT. See [LICENSE](./LICENSE).
