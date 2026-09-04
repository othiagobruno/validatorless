#!/usr/bin/env bash
# Resolve the version to publish from pubspec.yaml.
#
# Policy:
# - If this commit already changed `version:` vs HEAD^, keep that version
#   (so a PR that set 1.3.0 publishes 1.3.0 instead of bumping again).
# - Otherwise apply a patch bump (1.3.0 -> 1.3.1) and append CHANGELOG.md.
#
# Outputs (stdout and $GITHUB_OUTPUT when set):
#   version=<semver>
#   bumped=true|false
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

extract_version() {
  grep -E '^version:' | head -n 1 | awk '{print $2}' | tr -d "\"'" | tr -d '\r'
}

write_output() {
  local key="$1"
  local value="$2"
  echo "${key}=${value}"
  if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
    echo "${key}=${value}" >> "$GITHUB_OUTPUT"
  fi
}

current="$(extract_version < pubspec.yaml)"
if [[ -z "$current" ]]; then
  echo "::error::Could not read version from pubspec.yaml" >&2
  exit 1
fi

previous=""
if git rev-parse --verify --quiet HEAD^ >/dev/null && git cat-file -e HEAD^:pubspec.yaml 2>/dev/null; then
  previous="$(git show HEAD^:pubspec.yaml | extract_version || true)"
fi

if [[ -n "$previous" && "$current" != "$previous" ]]; then
  echo "pubspec.yaml version already changed: ${previous} -> ${current} (publishing as-is)"
  write_output version "$current"
  write_output bumped false
  exit 0
fi

core="${current%%-*}"
core="${core%%+*}"
IFS='.' read -r major minor patch <<< "$core"
if [[ -z "${major:-}" || -z "${minor:-}" || -z "${patch:-}" || ! "$patch" =~ ^[0-9]+$ ]]; then
  echo "::error::Cannot patch-bump unparseable version: ${current}" >&2
  exit 1
fi

new_version="${major}.${minor}.$((patch + 1))"
echo "No version change vs previous commit (${previous:-none}); patch-bumping to ${new_version}"

sed -i -E "s/^version:[[:space:]]+.*/version: ${new_version}/" pubspec.yaml

if [[ -f CHANGELOG.md ]] && ! grep -qE "^## \[${new_version}\]" CHANGELOG.md; then
  notes=""
  if last_tag="$(git describe --tags --abbrev=0 2>/dev/null)"; then
    notes="$(git log "${last_tag}..HEAD" --pretty=format:'- %s' --no-merges \
      | grep -vE 'chore: bump version|\[skip ci\]|\[ci skip\]' || true)"
  fi
  if [[ -z "${notes}" ]]; then
    notes="- Automated patch release."
  fi

  if [[ -s CHANGELOG.md && "$(tail -c 1 CHANGELOG.md | wc -l)" -eq 0 ]]; then
    printf '\n' >> CHANGELOG.md
  fi

  {
    printf '\n## [%s] - Patch release\n\n' "$new_version"
    printf '%s\n' "$notes"
  } >> CHANGELOG.md
fi

write_output version "$new_version"
write_output bumped true
