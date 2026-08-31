FROM curlimages/curl:8.21.0@sha256:7c12af72ceb38b7432ab85e1a265cff6ae58e06f95539d539b654f2cfa64bb13 AS fetch

ARG PNPM_VERSION=v12.1.0

WORKDIR /rootfs/

RUN install -dm0755 /rootfs/usr/share/pnpm
RUN curl -sSfL "https://github.com/pnpm/pnpm/releases/download/${PNPM_VERSION}/pnpm-linux-x64-musl.tar.gz" | \
      tar -xz -C /rootfs/usr/share/pnpm

RUN <<-EOF
  install -dm0755 /rootfs/usr/bin
  ln -sf /usr/share/pnpm/pnpm /rootfs/usr/bin/pnpm
EOF

RUN install -Dm755 /dev/stdin /rootfs/usr/bin/pnpx <<-'EOF'
  #!/bin/sh
  exec pnpm dlx "$@"
EOF

FROM scratch
COPY --from=fetch /rootfs/ /
