# SoftU2F with fingerprint

This project aims to support U2F / FIDO2 using fingerprint reader on Linux (via libfprint). The goal is to have the same user experience with 2FA using Windows Hello.

This project is based on https://github.com/danstiner/rust-u2f with minor modification (see my fork: https://github.com/ngxson/rust-u2f-pkexec)

## Requirements

1. The command `fprintd-verify` works on your computer
2. Dbus (GNOME, KDE,...)
3. `uhid` support (verify using `ls -la /dev/uhid`)
4. Docker and docker compose installed

## Install

Make a new `docker-compose.yml` file:

```yml
version: '3'
services:
  softu2f-fprintd:
    image: ngxson/softu2f-fprintd-docker
    container_name: softu2f-fprintd
    network_mode: host  # fix for "unix:abstract" dbus socket
    restart: unless-stopped
    environment:
      - USER
      - XDG_RUNTIME_DIR
      - DBUS_SESSION_BUS_ADDRESS
      - HOME=/data
    volumes:
      - softu2f-fprintd-volume:/data
      - /run/user:/run/user
      - /var/run/dbus:/var/run/dbus
      - /var/lib/fprint/:/var/lib/fprint/:ro
    devices:
      - /dev/uhid
volumes:
  softu2f-fprintd-volume:
```

Then, run it using:

```bash
docker compose up -d
```

⚠️ Do NOT run it using `sudo`. If you get permission denied, follow post-installation step of Docker: https://docs.docker.com/engine/install/linux-postinstall/

Finally, go to https://webauthn.io/ to test it out.
