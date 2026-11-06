# Horizon, custom build

An **unofficial** build of the [Horizon](https://github.com/horizon-rust/horizon) launcher and game
(Minecraft: Java Edition rewritten in Rust), with a few changes on top. It is not made, endorsed or
supported by the Horizon project, Mojang or Microsoft. The code is Horizon's, under its MIT licence
([LICENSE](../LICENSE)). What is changed is listed in [CUSTOM.md](../CUSTOM.md).

## Download

Take the files from the [latest release](https://github.com/DaniilMurai/horizon-custom/releases/latest):

| Platform | File | Needs |
| --- | --- | --- |
| Windows x64 | [`horizon-launcher-setup.exe`](https://github.com/DaniilMurai/horizon-custom/releases/latest/download/horizon-launcher-setup.exe) | Windows 10 or 11, a GPU with Vulkan or DirectX 12 |
| macOS, Apple silicon (M1 or later) | [`horizon-launcher-macos-arm64.dmg`](https://github.com/DaniilMurai/horizon-custom/releases/latest/download/horizon-launcher-macos-arm64.dmg) | macOS 12 or later |
| macOS, Intel | [`horizon-launcher-macos-x64.dmg`](https://github.com/DaniilMurai/horizon-custom/releases/latest/download/horizon-launcher-macos-x64.dmg) | macOS 12 or later |
| Linux x86-64 | [`horizon-launcher-linux-x86_64.AppImage`](https://github.com/DaniilMurai/horizon-custom/releases/latest/download/horizon-launcher-linux-x86_64.AppImage) | a glibc distribution, X11 or Wayland, a GPU with Vulkan or OpenGL 3.3 |

Not sure which Mac you have? Apple menu → About This Mac: "Chip: Apple M…" is Apple silicon, "Processor: Intel…" is Intel.

Other downloads on the release page: `.zip` files with the program alone (Windows, macOS) and a `.tar.gz` (Linux).
Windows on Arm has no build here.

## Install

The builds are **not signed by Apple or Microsoft**, so each system asks before opening one the first time.
That is expected. Download only from this repository's [releases](https://github.com/DaniilMurai/horizon-custom/releases).

### macOS

1. Open the `.dmg` and drag **Horizon** onto **Applications**.
2. Open Horizon from Applications. macOS says it cannot verify the app: close the message.
3. Open **System Settings → Privacy & Security**, scroll to the **Security** section and click **Open Anyway**
   next to "Horizon was blocked", then confirm. (On macOS 14 and earlier, Control-click Horizon → **Open** works.)
4. If macOS says the app is "damaged" instead, remove the download mark and open it again:

   ```sh
   xattr -dr com.apple.quarantine /Applications/Horizon.app
   ```

You do this once; later starts open normally.

### Windows

1. Run `horizon-launcher-setup.exe`. It installs for your user only and needs no administrator rights.
2. If Windows shows **Windows protected your PC**, click **More info → Run anyway**.

Prefer no installer? Unzip `horizon-launcher-windows-x64.zip` anywhere and run `horizon-launcher.exe`.

### Linux

```sh
chmod +x horizon-launcher-linux-x86_64.AppImage
./horizon-launcher-linux-x86_64.AppImage
```

The graphics driver and system libraries come from your machine: a working Vulkan driver (or OpenGL 3.3) is needed.

## Check a download (optional)

`SHA256SUMS` on the release page lists the SHA-256 of every file. Put it in the same folder as the file and run:

```sh
shasum -a 256 -c SHA256SUMS --ignore-missing      # macOS
sha256sum -c SHA256SUMS --ignore-missing          # Linux
```

On Windows, `certutil -hashfile <file> SHA256` prints the value to compare by eye.

## First start

The launcher shows its Home page. Horizon builds its game files from **your own copy of Minecraft: Java Edition**,
and contains none of Mojang's files:

- **From my install** uses a Minecraft: Java Edition already installed on this computer.
- **Sign in** with a Microsoft account that owns Minecraft: Java Edition to have the launcher fetch it.

Your worlds and settings stay where Horizon keeps them; this build uses the same folders as the official launcher.

## What is different

- **Play without an owner.** Play starts the game, offline, when no account that owns Minecraft is signed in.
  The owner screen is an optional sign-in, not a gate. The game files still have to come from a Minecraft: Java Edition.
- **No self-update.** The window shows "0.2.x · Custom" and never replaces itself with an official release.
  New versions come from this page: watch the repository (**Watch → Custom → Releases**) to hear of them.
- **X-ray** in the game, when it is built from this repository (not in the launcher's downloads).

Everything else is Horizon's. Its [documentation](https://playhorizon.dev/docs/) applies.

## Updating

Install the newer release over the old one: on macOS replace Horizon in Applications, on Windows run the new setup,
on Linux replace the AppImage. Your worlds and settings are kept.

## Problems

Open an [issue here](https://github.com/DaniilMurai/horizon-custom/issues). Please do not report this build's
problems to Horizon: they have not seen its changes. If something also happens with Horizon's official launcher,
that is theirs to hear about.

## For maintainers

[CUSTOM.md](../CUSTOM.md) explains how the build is kept on top of Horizon (`tools/update-custom.sh`, the daily
check) and releases are made by pushing a tag such as `v0.2.47-custom.2`
([custom-release.yml](workflows/custom-release.yml)).
