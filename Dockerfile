FROM curlimages/curl:8.19.0@sha256:c03110c736db81bbe1be0296f1f1608c81b954b01626bdfb0a8f84e5bd00ff3c AS fetch

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
