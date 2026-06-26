FROM curlimages/curl:8.20.0@sha256:b3f1fb2a51d923260350d21b8654bbc607164a987e2f7c84a0ac199a67df812a AS fetch

ARG PNPM_VERSION=v11.9.0

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
