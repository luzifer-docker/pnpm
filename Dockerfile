FROM curlimages/curl:8.22.0@sha256:58adaa4e8dca9c988bae2aba4ab3434a0bb2da16bbe3f92dec39ec7785166777 AS fetch

ARG PNPM_VERSION=v12.4.0

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
