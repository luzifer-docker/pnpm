# luzifer-docker/pnpm

Minimal `scratch`-based image containing only `pnpm` and a `pnpx` wrapper in `/usr/bin/`. It is intended as a utility image to either copy those binaries into another image or make them available temporarily during a BuildKit step.

## Contents

- `/usr/bin/pnpm`
- `/usr/bin/pnpx`
- `pnpx` is a compatibility wrapper that executes `pnpm dlx`

## Use Cases

### Copy pnpm into another image

If you want to install `pnpm` into your own image, copy the full rootfs from this image:

```dockerfile
COPY --from=ghcr.io/luzifer-docker/pnpm:v<version> / /
```

This works because the image only contains the installed binaries under `/usr/bin/`.

### Mount pnpm temporarily during build

If you only need `pnpm` for a single BuildKit `RUN` step, mount both binaries explicitly:

```dockerfile
RUN --mount=type=bind,from=ghcr.io/luzifer-docker/pnpm:v<version>,source=/usr/bin/pnpm,target=/usr/bin/pnpm \
    --mount=type=bind,from=ghcr.io/luzifer-docker/pnpm:v<version>,source=/usr/bin/pnpx,target=/usr/bin/pnpx \
    pnpm --version && pnpx cowsay hello
```

This keeps `pnpm` and `pnpx` available only for that build step without adding them to the final image.

## Versioning

Use `ghcr.io/luzifer-docker/pnpm:v<version>` where `<version>` matches the bundled upstream `pnpm` release number.
