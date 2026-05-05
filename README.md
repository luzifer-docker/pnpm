# luzifer-docker/pnpm

Minimal `scratch`-based image containing the pnpm ESM distribution in `/usr/share/pnpm/` and wrapper scripts in `/usr/bin/`. It is intended as a utility image to copy pnpm into another image.

## Contents

- `/usr/share/pnpm/`
- `/usr/bin/pnpm`
- `/usr/bin/pnpx`
- `pnpm` is a wrapper that executes `node /usr/share/pnpm/pnpm.mjs`
- `pnpx` is a compatibility wrapper that executes `pnpm dlx`

## Use Cases

### Copy pnpm into another image

If you want to install `pnpm` into your own image, copy the full rootfs from this image:

```dockerfile
COPY --from=ghcr.io/luzifer-docker/pnpm:v<version> / /
```

The target image must provide `node` on `PATH`, as pnpm is packaged as an ESM module and the `pnpm` wrapper executes it through Node.js.

### Mount pnpm temporarily during build

Temporary bind-mount usage is no longer the practical default. The wrappers depend on both `/usr/share/pnpm/` and a Node.js runtime in the target image, so copying the full rootfs is the recommended integration path.

## Versioning

Use `ghcr.io/luzifer-docker/pnpm:v<version>` where `<version>` matches the packaged upstream `pnpm` release number.
