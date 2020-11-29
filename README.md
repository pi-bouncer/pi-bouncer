# NixOS & ZNC based IRC Bouncer for RasbperryPi

**Warning: Work in progress**

Quickly roll your own self-hosted IRC bouncer thanks to the power of
[ZNC](https://znc.in) and [NixOS](https://nixos.org).

This mainly targets RasberryPi boards but should be usable as a NixOS module
as well.

Currently tested with RasberryPi 2 & 3 boards. Support for RasberryPi 0, 1 and 4
is planned as well.

## Configuring

You can base your configuration on the [example.nix](./example.nix) which
allows to build SD image for RaspberryPi 2 & 3.

It configures ZNC with mutable config - it allows to change its config via
`webadmin` or `controlpanel` modules. Further configuration made via Nix
won't overwrite existing configuration.

To switch to immutable configuration set

```nix
services.znc.mutable = false;
```

which replaces ZNC config on start to match Nix configuration.
This can be useful to bootstrap the installation and possibly switching
to `mutable = true` when initial config is in place.

## Build

To cross compile SD image use the provided `nix-build` wrapper.

```bash
./bouncer_cross_build
```

This cross compiles the image from e.g. `x86` to `armv7l` using [with-cross.nix](./with-cross.nix).

## Flash

To flash to SD card use the following command with `mmcblk_X_` pointing to your
SD card (you can find the correct device via `dmesg`, typically it's `mmcblk0`
if you only have one card reader).

```bash
dd if=$( echo pibouncer/sd-image/nixos-sd-image-*img ) of=/dev/mmcblkX bs=1M
```

Default IRC port of the ZNC bouncer is SSL enabled `6697`.

## Update

For updating RaspberryPi based bouncers it is possible to use
```bash
nixos-rebuild --build-host localhost --target-host ssh://bouncerIP
```

[bouncer_cross_update](./bounce_cross_update) is a complete example
which tries to reach `bouncer` host.

## TOR/SASL setup

Setting `pibouncer.tor.enable = True;` option forces ZNC to use TOR
for all outgoing connections. This allows connecting to IRC servers over
TOR and access to hidden services - SSH and IRC/web interface on `pibouncer.port`.

For freenode, use `zettel.freenode.net` with port 6697 and SSL enabled.
This address is mapped to `.onion` address via `MapAddress` in [modules/tor.nix](./modules/tor.nix).

Before switching to TOR connection, it is required to create a certificate and add its
fingerprint to IRC services. Certificate can be generated using [gencert](./gencert) script
which creates a self-signed certificate valid for 10 years. It's not required to provide
all the certificate information, defaults will do just fine.

After certificate creation, the script will output instructions where to put your certificate on the filesystem
and a command usable in your IRC client for adding fingerprint to services via `NickServ`.

For `example` user, then end of the output would be:

```
Now copy secrets/example.pem to ZNC cert plugin data dir
(typically /var/lib/znc/users/example/moddata/cert/user.pem)
e.g.:
# cp secrets/example.pem /var/lib/znc/users/example/moddata/cert/user.pem

To add certificate to services use:
/msg NickServ cert add <actual_fingerprint>
```

All that remains now is to set SASL mechanism to EXTERNAL so it will use our certificate.
This can be done via web interface or using following command for IRC client connected to ZNC.

```
/query *sasl Mechanism EXTERNAL
```

Tested against freenode, for other networks instructions might differ.

### Accessing hidden services

When `pibouncer.tor.enable` is set to `true`, two hidden services are setup automically, one for SSH access
and one for ZNC (`pibouncer.port`).

You can find your pi-bouncers onion address with

`cat /var/lib/tor/onion/pibouncer/hostname`

## Resources

Based on following upstream documentation:

* https://freenode.net/kb/answer/chat
* https://freenode.net/kb/answer/certfp
* https://wiki.znc.in/Cert
* https://wiki.znc.in/Sasl
