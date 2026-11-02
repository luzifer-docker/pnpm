FROM curlimages/curl:8.23.0@sha256:3fb7e13e5d179a845c97d78204f3f1064d1907037f26a3ebf91710571151fd93 AS fetch

ARG PNPM_VERSION=v11.28.10

WORKDIR /rootfs/

RUN install -dm0755 /rootfs/usr/share/pnpm
RUN curl -sSfL "https://github.com/pnpm/pnpm/releases/download/${PNPM_VERSION}/pnpm-linux-x64.tar.gz" | \
      tar -xz -C /rootfs/usr/share/pnpm --strip-components=1 dist

RUN install -Dm755 /dev/stdin /rootfs/usr/bin/pnpm <<-'EOF'
  #!/bin/sh
  exec node /usr/share/pnpm/pnpm.mjs "$@"
EOF

RUN install -Dm755 /dev/stdin /rootfs/usr/bin/pnpx <<-'EOF'
  #!/bin/sh
  exec pnpm dlx "$@"
EOF

FROM scratch
COPY --from=fetch /rootfs/ /
