---
description: Create a git commit
---
## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -10`

## Your task

1. Ensure that there is already staged file, the file staging is done manually by user, you shouldn't stage it by yourself, if there's no file staged reconfirm with the user
2. Analyze the diff content of the staged file to understand the nature and purpose of the changes
3. Generate 3 commit message candidates based on the changes
   - Each candidate should be concise, clear, and capture the essence of the changes
   - Prefer Conventional Commits format (feat:, fix:, docs:, refactor:, etc.)
4. Select the most appropriate commit message from the 3 candidates and explain the reasoning for your choice
5. Execute git commit using the selected commit message

## Constraints

- DO NOT add co-authorship footer to commits
