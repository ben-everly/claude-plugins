---
name: commit
description: Use when you want to commit current changes. Accepts optional hint text to guide the commit message.
---

# /commit

Create a conventional commit for the current changes. This command depends on the `conventional-commits` skill for message formatting rules.

**Arguments:** Optional hint text describing the purpose of the change (e.g. `/commit fixing the auth bug`, `/commit add user avatar upload`). Use this to guide the commit type, scope, and description.

## Process

Follow these steps exactly:

1. **Check for staged changes:**
   - Run `git diff --cached --stat` to check if anything is staged.
   - If there ARE staged changes, proceed to step 3.
   - If there are NO staged changes, proceed to step 2.

2. **Stage all changes:**
   - Run `git add -A` to stage everything.
   - If there are still no changes after staging (clean working tree), inform the user there is nothing to commit and stop.

3. **Analyze the diff:**
   - Run `git diff --cached` to see the full staged diff.
   - If coming from step 2, also run `git diff --cached --stat` to see which files changed (if coming from step 1, reuse the stat output from there).
   - Examine the changes to understand what was done and why.

4. **Assess project complexity for scope decision:**
   - Look at the repository structure to determine if scopes are warranted.
   - If the project appears to have distinct domains/modules, check recent commit history (`git log --oneline -20`) to see if scopes are already in use — if so, follow the established convention.
   - Only include a scope if the project has distinct domains/modules and the change targets a specific one.

5. **Generate the commit message:**
   - Apply the `conventional-commits` skill to craft the message.
   - Use the user's hint (if provided) to inform the type, scope, and description.
   - Always include the type and description.
   - Include a scope only if warranted per step 4.
   - Include a body only if the commit is large or the description alone doesn't capture the full context.
   - Include footers only when applicable (breaking changes, issue refs, etc.).

6. **Commit:**
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

7. **Report:**
   - Show the user the commit hash and message.
   - If files were auto-staged in step 2, mention that.
