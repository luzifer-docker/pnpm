FROM curlimages/curl:8.19.0@sha256:b066cbf876d50a5d024927878a586c4a39c985325ded195e2e231f4abdddf3c8 AS fetch

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
