<!-- markdownlint-disable -->

# Hardening Report: borchero--terraform-plan-comment/v2.6.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **borchero--terraform-plan-comment/v2.6.0** was hardened automatically. 3 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): The `run:` block in the 'Get major version' step directly interpolates `${{ github.ref_name }}` into a shell command string: `MAJOR=$(echo ${{ github.ref_name }} | cut -d'.' -f1 | cut -c2-)`. A crafted release tag name could inject arbitrary shell commands. The value should be passed via an `env:` variable and double-quoted in the shell.

Locations:

- `.github/workflows/release.yml:20`

### github-env-injection (severity: high)

The 'Get major version' step writes `$MAJOR` to `$GITHUB_OUTPUT` without sanitization. `$MAJOR` is derived directly from `${{ github.ref_name }}` (an attacker-controllable value via a crafted tag name) without applying `printf '%s' ... | tr -d '\n\r'` before the write. A newline in the tag name could inject arbitrary key-value pairs into the output context.

Locations:

- `.github/workflows/release.yml:21`

### unpinned-uses (severity: high)

Multiple workflow files reference external actions using mutable version tags instead of immutable 40-character commit SHA hashes, making them vulnerable to supply-chain attacks if the tag is moved or the upstream repository is compromised.

- chore.yml: `amannn/action-semantic-pull-request@v6` (line 26), `marocchino/sticky-pull-request-comment@v2` (lines 35, 47), `release-drafter/release-drafter@v6` (line 57)
- ci.yml: `actions/checkout@v6` (lines 19, 36), `prefix-dev/setup-pixi@v0.9.3` (lines 21, 38), `actions/cache@v4` (line 27)
- copilot-setup-steps.yml: `actions/checkout@v6` (line 14), `prefix-dev/setup-pixi@v0.9.3` (line 16)
- e2e.yml: `actions/checkout@v6` (line 14), `hashicorp/setup-terraform@v3` (line 16)
- release.yml: `actions/github-script@v8` (lines 23, 30)
- stale.yml: `actions/stale@v10` (line 14)

Locations:

- `.github/workflows/chore.yml:26`
- `.github/workflows/chore.yml:35`
- `.github/workflows/chore.yml:47`
- `.github/workflows/chore.yml:57`
- `.github/workflows/ci.yml:19`
- `.github/workflows/ci.yml:21`
- `.github/workflows/ci.yml:27`
- `.github/workflows/ci.yml:36`
- `.github/workflows/ci.yml:38`
- `.github/workflows/copilot-setup-steps.yml:14`
- `.github/workflows/copilot-setup-steps.yml:16`
- `.github/workflows/e2e.yml:14`
- `.github/workflows/e2e.yml:16`
- `.github/workflows/release.yml:23`
- `.github/workflows/release.yml:30`
- `.github/workflows/stale.yml:14`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection, unpinned-uses

**Notes:**

Fixed all three findings across 6 workflow files:

1. script-injection (release.yml): Moved `${{ github.ref_name }}` into an `env:` block as `REF_NAME` and referenced it double-quoted in the shell using `printf '%s' "$REF_NAME"`.

2. github-env-injection (release.yml): Added `printf '%s' "$MAJOR" | tr -d '\n\r'` sanitization before writing to `$GITHUB_OUTPUT`, and quoted `"$GITHUB_OUTPUT"`.

3. unpinned-uses: Pinned all 9 unique actions to their immutable 40-character commit SHAs with original tags preserved as inline comments: amannn/action-semantic-pull-request@48f256284bd46cdaab1048c3721360e808335d50, marocchino/sticky-pull-request-comment@773744901bac0e8cbb5a0dc842800d45e9b2b405, release-drafter/release-drafter@6a93d829887aa2e0748befe2e808c66c0ec6e4c7, actions/checkout@d23441a48e516b6c34aea4fa41551a30e30af803, prefix-dev/setup-pixi@82d477f15f3a381dbcc8adc1206ce643fe110fb7, actions/cache@0057852bfaa89a56745cba8c7296529d2fc39830, hashicorp/setup-terraform@b9cd54a3c349d3f38e8881555d616ced269862dd, actions/github-script@ed597411d8f924073f98dfc5c65a23a2325f34cd, actions/stale@1e223db275d687790206a7acac4d1a11bd6fe629.

