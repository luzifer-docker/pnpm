FROM curlimages/curl:8.20.0@sha256:b3f1fb2a51d923260350d21b8654bbc607164a987e2f7c84a0ac199a67df812a AS fetch

ARG PNPM_VERSION=v11.0.6

WORKDIR /rootfs/
RUN curl -sSfL "https://github.com/pnpm/pnpm/releases/download/${PNPM_VERSION}/pnpm-linuxstatic-x64" | \
      install -Dm755 /dev/stdin /rootfs/usr/bin/pnpm
RUN install -Dm755 /dev/stdin /rootfs/usr/bin/pnpx <<-EOF
  #!/bin/sh
  exec pnpm dlx "$@"
EOF

FROM scratch
COPY --from=fetch /rootfs/ /
