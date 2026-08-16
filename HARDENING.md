<!-- markdownlint-disable -->

# Hardening Report: borchero--terraform-plan-comment/v2.5.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **borchero--terraform-plan-comment/v2.5.2** was hardened automatically. 3 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): The `run:` block in the 'Get major version' step of release.yml directly interpolates `${{ github.ref_name }}` into a shell command: `MAJOR=$(echo ${{ github.ref_name }} | cut -d'.' -f1 | cut -c2-)`. A release tag name is attacker-influenced and this substitution happens before the shell sees the string, enabling command injection.

Locations:

- `.github/workflows/release.yml:20`

### github-env-injection (severity: high)

The 'Get major version' step writes `$MAJOR` — a value derived from the unsanitized `${{ github.ref_name }}` expression — to `$GITHUB_OUTPUT` without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`). A newline embedded in the release tag name could inject arbitrary key=value pairs into the output file.

Locations:

- `.github/workflows/release.yml:21`

### unpinned-uses (severity: high)

All `uses:` references across workflow files use mutable tags instead of full 40-character SHA commit hashes, making the workflows vulnerable to supply-chain attacks if any referenced action is compromised or its tag is moved. Unpinned references found:
- chore.yml: `amannn/action-semantic-pull-request@v6`, `marocchino/sticky-pull-request-comment@v2` (×2), `release-drafter/release-drafter@v6`
- ci.yml: `actions/checkout@v6`, `prefix-dev/setup-pixi@v0.9.3`, `actions/cache@v4`, `actions/checkout@v6`, `prefix-dev/setup-pixi@v0.9.3`
- copilot-setup-steps.yml: `actions/checkout@v6`, `prefix-dev/setup-pixi@v0.9.3`
- e2e.yml: `actions/checkout@v6`, `hashicorp/setup-terraform@v3`
- release.yml: `actions/github-script@v8` (×2)
- stale.yml: `actions/stale@v10`

Locations:

- `.github/workflows/chore.yml:26`
- `.github/workflows/chore.yml:33`
- `.github/workflows/chore.yml:43`
- `.github/workflows/chore.yml:52`
- `.github/workflows/ci.yml:16`
- `.github/workflows/ci.yml:18`
- `.github/workflows/ci.yml:23`
- `.github/workflows/ci.yml:30`
- `.github/workflows/ci.yml:32`
- `.github/workflows/copilot-setup-steps.yml:14`
- `.github/workflows/copilot-setup-steps.yml:16`
- `.github/workflows/e2e.yml:15`
- `.github/workflows/e2e.yml:17`
- `.github/workflows/release.yml:23`
- `.github/workflows/release.yml:31`
- `.github/workflows/stale.yml:14`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection, unpinned-uses

**Notes:**

Fixed all three findings across 6 workflow files:

1. script-injection (release.yml): Moved `${{ github.ref_name }}` into the step's `env:` block as `REF_NAME` and updated the shell command to use `$REF_NAME` safely via `printf '%s' "$REF_NAME"`.

2. github-env-injection (release.yml): Added `printf '%s' "$MAJOR" | tr -d '\n\r'` sanitization before writing to `$GITHUB_OUTPUT`, and quoted `$GITHUB_OUTPUT` properly.

3. unpinned-uses: Pinned all 16 unpinned action references across chore.yml, ci.yml, copilot-setup-steps.yml, e2e.yml, release.yml, and stale.yml to their full 40-character SHA commit hashes, with inline tag comments for readability. SHAs resolved via lookup_action_sha.

