#!/usr/bin/env bash
# Brings this custom build up to Horizon's newest launcher release, keeping our changes (CUSTOM.md).
#
#   tools/update-custom.sh --check            what is new upstream, and would it conflict (changes nothing)
#   tools/update-custom.sh                    merge the newest upstream launcher release into a sync branch
#   tools/update-custom.sh --tag launcher@0.2.50   a given release instead of the newest
#   tools/update-custom.sh --verify           the checks, on the current branch (after a merge or a manual fix)
#   tools/update-custom.sh --no-verify        merge, without running the checks after it
#
# A merge that conflicts stops with the conflicted files listed and exit code 2. Fix them, `git add`
# them, `git commit`, then run `tools/update-custom.sh --verify`. `git rerere` is on, so a conflict
# fixed once is fixed the same way next time.
#
# Exit codes: 0 done (or nothing to do), 2 conflicts, 3 the checks failed, 1 anything else.
set -euo pipefail

OFFICIAL_URL=${OFFICIAL_URL:-https://github.com/horizon-rust/horizon.git}
cd "$(git rev-parse --show-toplevel)"

mode=merge
run_checks=yes
tag=
while [[ $# -gt 0 ]]; do
  case $1 in
    --check) mode=check ;;
    --verify) mode=verify ;;
    --no-verify) run_checks= ;;
    --tag) tag=${2:?--tag needs a value}; shift ;;
    -h | --help) sed -n '2,14p' "$0"; exit 0 ;;
    *) echo "unknown argument: $1" >&2; exit 1 ;;
  esac
  shift
done

say() { printf '%s\n' "$*"; }

verify() {
  say "== fmt"
  cargo fmt --all -- --check
  say "== launcher tests"
  (cd launcher && cargo test)
  say "== game and examples still compile (a new Mesher field breaks them first)"
  cargo check -p horizon-client -p horizon-client-render --lib --bins --tests --examples
  say "== render crate tests"
  cargo test -p horizon-client-render --lib
}

if [[ $mode == verify ]]; then
  verify || { say "The checks failed."; exit 3; }
  say "The checks passed."
  exit 0
fi

# Horizon's own refs go under refs/official/, never into our branches or tags.
git fetch --quiet "$OFFICIAL_URL" \
  '+refs/heads/main:refs/official/main' \
  '+refs/tags/launcher@*:refs/official/tags/launcher@*'

if [[ -z $tag ]]; then
  tag=$(git for-each-ref --format='%(refname:strip=3)' 'refs/official/tags/launcher@*' | sort -V | tail -1)
fi
[[ -n $tag ]] || { say "No launcher@ release found upstream." >&2; exit 1; }
target=$(git rev-parse --verify "refs/official/tags/$tag^{commit}")

if git merge-base --is-ancestor "$target" HEAD; then
  say "Up to date: $tag is already in $(git rev-parse --abbrev-ref HEAD)."
  exit 0
fi

new=$(git rev-list --count "HEAD..$target")
say "Upstream $tag ($(git rev-parse --short "$target")) brings $new commits we do not have."
conflict_lines=$(git merge-tree --write-tree --name-only HEAD "$target" 2>/dev/null | grep '^CONFLICT' || true)
if [[ -n $conflict_lines ]]; then
  say "It would conflict in:"
  say "$conflict_lines"
else
  say "It merges cleanly."
fi
[[ $mode == check ]] && exit 0

if [[ -n $(git status --porcelain --untracked-files=no) ]]; then
  say "The working tree has uncommitted changes: commit or set them aside first." >&2
  exit 1
fi
git config rerere.enabled true
git config rerere.autoupdate true

branch="sync/${tag//@/-}"
git switch -c "$branch"
say "On branch $branch, merging $tag"
if ! git merge --no-ff -m "Merge upstream $tag into the custom build" "$target"; then
  # rerere may have fixed every conflict the way we fixed it before: those are staged already.
  left=$(git diff --name-only --diff-filter=U)
  if [[ -n $left ]]; then
    say ""
    say "Conflicts in:"
    say "$left"
    say "Fix them, git add, git commit, then run tools/update-custom.sh --verify"
    exit 2
  fi
  say "Every conflict was fixed by a recorded resolution (rerere)."
  git commit --no-edit --quiet
fi
if [[ -z $run_checks ]]; then
  say "Merged: $branch (checks not run)."
  exit 0
fi
verify || { say "The merge is in $branch but the checks failed."; exit 3; }
say "Merged and checked: $branch. Push it and open a pull request into main."
say "Then refresh the copy of Horizon main: git push <remote> refs/official/main:refs/heads/upstream"
