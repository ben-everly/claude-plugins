---
name: commit
description: Use when you want to commit current changes. Accepts optional hint text to guide the commit message.
allowed-tools: Bash(git add:*), Bash(git diff:*), Bash(git log:*), Bash(git commit:*)
---

# /commit

Create a conventional commit for the current changes. This command depends on the `conventional-commits` skill for message formatting rules.

**Arguments:** Optional hint text describing the purpose of the change (e.g. `/commit fixing the auth bug`, `/commit add user avatar upload`). Use this to guide the commit type, scope, and description.

## Context

The following is gathered before the command runs. If nothing is staged, all changes are staged with `git add -A` first (already-staged changes are left as-is and committed alone).

- Staged diff: !`git diff --cached --quiet && { git add -A; echo "[auto-staged all changes]"; }; git diff --cached --quiet && echo "NO_CHANGES" || git diff --cached`
- Changed files: !`git diff --cached --stat`
- Recent commits (for scope/convention): !`git log --oneline -20`

## Process

Follow these steps exactly:

1. **Check for changes:**
   - If the staged diff above is `NO_CHANGES`, the working tree is clean. Inform the user there is nothing to commit and stop.

2. **Analyze the diff:**
   - Examine the staged diff and changed files above to understand what was done and why.

3. **Assess project complexity for scope decision:**
   - Use the recent commit history above to determine if scopes are already in use — if so, follow the established convention.
   - Only include a scope if the project has distinct domains/modules and the change targets a specific one.

4. **Generate the commit message:**
   - Apply the `conventional-commits` skill to craft the message.
   - Use the user's hint (if provided) to inform the type, scope, and description.
   - Always include the type and description.
   - Include a scope only if warranted per step 3.
   - Include a body only if the commit is large or the description alone doesn't capture the full context.
   - Include footers only when applicable (breaking changes, issue refs, etc.).

5. **Commit:**
   - Run `git commit` with the generated message.
   - Use a HEREDOC to pass the message:
     ```bash
     git commit -m "$(cat <<'EOF'
type(scope): description

Multi-line body goes here. The blank line above
separating description from body is required.
EOF
)"
     ```
   - Do NOT ask for confirmation. Just commit.

6. **Report:**
   - Show the user the commit hash and message.
   - If the staged diff above started with `[auto-staged all changes]`, mention that files were auto-staged.
