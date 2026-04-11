FROM curlimages/curl:8.19.0@sha256:9a6f6a17667960e077f1b153009aaf18ac99a622221084e1938a45a06fff057a AS fetch

ARG PNPM_VERSION=v10.33.0

WORKDIR /rootfs/
RUN curl -sSfL "https://github.com/pnpm/pnpm/releases/download/${PNPM_VERSION}/pnpm-linuxstatic-x64" | \
      install -Dm755 /dev/stdin /rootfs/usr/bin/pnpm
RUN install -Dm755 /dev/stdin /rootfs/usr/bin/pnpx <<-EOF
  #!/bin/sh
  exec pnpm dlx "$@"
EOF

FROM scratch
COPY --from=fetch /rootfs/ /
