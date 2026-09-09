# syntax=docker/dockerfile:1

# latest node-bullseye image 9 February 2024
FROM docker.io/node:26-trixie-slim
WORKDIR /app

# Install node dependencies and update vulnerable packages
RUN npm install --ignore-scripts  --global npm@12.0.2 && \
    npm install --ignore-scripts  --global npx --force && \
    npm cache clean --force && \
    npm install --ignore-scripts  --global @security-alert/sarif-to-comment@1.11.1 --omit=dev --no-audit --no-fund

# Remove unnecessary cache and temp files to reduce attack surface
RUN rm -rf /root/.npm /root/.cache

# Install jq and dependency security patches
RUN apt-get update && apt-get install --no-install-recommends -y \
        e2fsprogs=1.47.2-3+b12 \
        jq=1.7.1-6+deb13u3 \
        libcom-err2=1.47.2-3+b12 \
        libss2=1.47.2-3+b12 \
        libsystemd0=257.13-1~deb13u1 \
        libudev1=257.13-1~deb13u1 \
        logsave=1.47.2-3+b12 \
        perl-base=5.40.1-6 \
        && \
    rm -rf /var/lib/apt/lists/*

COPY ./entrypoint.sh ./entrypoint.sh
USER node
ENTRYPOINT ["bash", "/app/entrypoint.sh"]
