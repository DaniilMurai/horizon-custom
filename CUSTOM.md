# Horizon custom build

This repository is an **unofficial** build of [Horizon](https://github.com/horizon-rust/horizon)
(Minecraft: Java Edition rewritten in Rust). It is not made, endorsed or supported by the Horizon
project. The code is Horizon's, under its MIT licence ([LICENSE](LICENSE)), with a few changes on top.

## Branches

| Branch | What it is |
|---|---|
| `upstream` | Horizon's `main`, copied as it is. Never edited here. |
| `main` | `upstream` plus the changes below. This is what gets built. |

## What is changed

- **Play without an owner.** The launcher starts the game offline when no signed-in account owns
  Minecraft: Java Edition, and the owner screen is optional. "From my install" is offered when
  preparing without an owner.
- **No self-update for custom builds.** A build outside Horizon's release pipeline shows
  "<version> · Custom" and never replaces itself with an official release.
- **X-ray extra.** An X-ray option with a block picker, a rebindable key (X by default) and
  full-bright ores.

Mojang's game files are never part of this repository.

## Keeping up with Horizon

The workflow [custom-sync](.github/workflows/custom-sync.yml) runs every day and opens an issue when
Horizon has a launcher release `main` does not have yet, saying whether merging it would conflict.

To update, on a computer with Rust installed:

```sh
git switch main && git pull
tools/update-custom.sh --check     # what is new, and would it conflict (changes nothing)
tools/update-custom.sh             # merge it into a sync/launcher-X branch and run the checks
```

- A conflict stops the script and lists the files. Fix them, `git add` and `git commit`, then run
  `tools/update-custom.sh --verify`. `git rerere` is switched on by the script: a conflict fixed once is
  fixed the same way the next time.
- When the checks pass: push the `sync/` branch, open a pull request into `main` and merge it.
- Keep `upstream` a copy of Horizon's main: `git push origin refs/official/main:refs/heads/upstream`.
- The tests that pin our changes (`custom_build_*` in `launcher/src/account/tests.rs`, `launcher/tests/owner_gate.rs`)
  fail when an update brings the owner gate back.
- A new place that builds a `Mesher` (a test, an example) needs `xray: None` for the X-ray extra; the
  compile check in the script finds them.
