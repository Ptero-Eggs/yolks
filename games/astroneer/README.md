# Astroneer

Astroneer dedicated server image, running the native Windows server under Wine
via [AstroTuxLauncher](https://github.com/JoeJoeTV/AstroTuxLauncher).

The launcher adds an RCON console, player monitoring, Discord/ntfy
notifications and graceful saves on top of running the server.

Built on the [`wine_latest`](../../wine/latest) yolk, which supplies Wine,
`xvfb` and `rcon`.

## Usage

The first boot runs the launcher's `install` command, which downloads the
dedicated server from Steam. Every boot after that runs `start`. The entrypoint
picks between them by checking for `AstroneerServer/AstroServer.exe`.

Encryption is disabled (`DisableEncryption = true`), so clients must set
`net.AllowEncryption=False` in their own `Engine.ini`.

## Configuration

The entrypoint renders `launcher.toml` from environment variables. These are
supplied by the egg in
[game-eggs](https://github.com/pterodactyl/game-eggs); see
`astroneer/astrotux_launcher` there for the variable list.
