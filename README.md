# luzifer-docker/pnpm

Minimal `scratch`-based image containing the statically linked pnpm binary and its distribution files. It is intended as a utility image to copy pnpm into another image.

## Contents

- `/usr/share/pnpm/`
- `/usr/bin/pnpm`
- `/usr/bin/pnpx`
- `pnpm` is a symlink to `/usr/share/pnpm/pnpm`
- `pnpx` is a compatibility wrapper that executes `pnpm dlx`

## Use Cases

### Copy pnpm into another image

If you want to install `pnpm` into your own image, copy the full rootfs from this image:

```dockerfile
COPY --from=ghcr.io/luzifer-docker/pnpm:v<version> / /
```

The pnpm binary itself is statically linked and does not require Node.js in the target image. Package lifecycle scripts can still require a shell, Node.js, or other interpreters and tools. The `pnpx` compatibility wrapper requires `/bin/sh`.

### Mount pnpm temporarily during build

The pnpm binary can run directly from the `scratch` image. Operations executing package lifecycle scripts need a suitable target image providing their required runtime tools. Copying the full rootfs remains the recommended integration path because pnpm depends on both `/usr/bin/pnpm` and `/usr/share/pnpm/`.

## Versioning

Use `ghcr.io/luzifer-docker/pnpm:v<version>` where `<version>` matches the packaged upstream `pnpm` release number.
