# NixOS & ZNC based IRC Bouncer for RasbperryPi

**Warning: Work in progress**

Quickly roll your own self-hosted IRC bouncer thanks to the power of
[ZNC](https://znc.in) and [NixOS](https://nixos.org).

This mainly targets RasberryPi boards but should be usable as a NixOS module
as well.

Currently tested with RasberryPi 2 & 3 boards. Support for RasberryPi 0, 1 and 4
is planned as well.

## Build

To build a mutable version (that allows to change its config via
`webadmin` or `controlpanel` modules) use the provided `nix-build` wrapper.

```bash
./bouncer_build
```

## Flash

To flash to SD card use the following command with `mmcblk_X_` pointing to your
SD card (you can find the correct device via `dmesg`, typically it's `mmcblk0`
if you only have one card reader).

```bash
dd if=$( echo pibouncer/sd-image/nixos-sd-image-*img ) of=/dev/mmcblkX bs=1M
```

Default IRC port of the ZNC bouncer is SSL enabled `6697`.
