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
