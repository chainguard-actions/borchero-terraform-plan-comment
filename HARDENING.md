<!-- markdownlint-disable -->

# Hardening Report: borchero--terraform-plan-comment/v2.6.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **borchero--terraform-plan-comment/v2.6.1** was hardened automatically. 3 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): `${{ github.ref_name }}` is directly interpolated inside a `run:` shell command in release.yml. The offending line is: `MAJOR=$(echo ${{ github.ref_name }} | cut -d'.' -f1 | cut -c2-)`. A tag name is attacker-influenced (e.g. a release tag could contain shell metacharacters), and YAML template substitution inserts the raw value before the shell ever sees it, enabling command injection.

Locations:

- `.github/workflows/release.yml:16`

### github-env-injection (severity: high)

In release.yml, the shell variable `$MAJOR` is derived from `${{ github.ref_name }}` (an attacker-influenced value) and then written directly to `$GITHUB_OUTPUT` via `echo "major=$MAJOR" >> $GITHUB_OUTPUT` without the required sanitization step (`printf '%s' "$MAJOR" | tr -d '\n\r'`). A newline embedded in the tag name could inject additional key=value pairs into the output context.

Locations:

- `.github/workflows/release.yml:17`

### unpinned-uses (severity: high)

All workflow files reference external actions using mutable version tags instead of pinned 40-character SHA commits, making them vulnerable to supply-chain attacks if a tag is moved or hijacked. Failing references include: chore.yml — `amannn/action-semantic-pull-request@v6`, `marocchino/sticky-pull-request-comment@v2` (×2), `release-drafter/release-drafter@v6`; ci.yml — `actions/checkout@v6`, `prefix-dev/setup-pixi@v0.9.4` (×2), `actions/cache@v5`; copilot-setup-steps.yml — `actions/checkout@v6`, `prefix-dev/setup-pixi@v0.9.4`; e2e.yml — `actions/checkout@v6`, `hashicorp/setup-terraform@v3`; release.yml — `actions/github-script@v8` (×2); stale.yml — `actions/stale@v10`.

Locations:

- `.github/workflows/chore.yml:22`
- `.github/workflows/chore.yml:33`
- `.github/workflows/chore.yml:44`
- `.github/workflows/chore.yml:55`
- `.github/workflows/ci.yml:17`
- `.github/workflows/ci.yml:19`
- `.github/workflows/ci.yml:24`
- `.github/workflows/ci.yml:32`
- `.github/workflows/ci.yml:34`
- `.github/workflows/copilot-setup-steps.yml:14`
- `.github/workflows/copilot-setup-steps.yml:16`
- `.github/workflows/e2e.yml:15`
- `.github/workflows/e2e.yml:17`
- `.github/workflows/release.yml:21`
- `.github/workflows/release.yml:28`
- `.github/workflows/stale.yml:14`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection, unpinned-uses

**Notes:**

Fixed all three findings: (1) script-injection in release.yml: moved `${{ github.ref_name }}` into an env var `REF_NAME` and used `printf '%s' "$REF_NAME"` in the shell command; (2) github-env-injection in release.yml: added `printf '%s' "$MAJOR" | tr -d '\n\r'` sanitization before writing to $GITHUB_OUTPUT; (3) unpinned-uses: pinned all 16 action references across chore.yml, ci.yml, copilot-setup-steps.yml, e2e.yml, release.yml, and stale.yml to their full 40-character commit SHAs with original tags preserved as comments.

