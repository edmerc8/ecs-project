# ----------------------------------------------------------------------
# Stage 1: The Fetcher (Secure Asset Download)
# ----------------------------------------------------------------------
FROM debian:bookworm-slim AS fetcher

# Install ca-certificates to fix the SSL error (exit code 60) and curl
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl && \
    mkdir -p /certs && \
    # Download the AWS RDS Root CA bundle securely
    curl -sS https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem -o /certs/global-bundle.pem

# ----------------------------------------------------------------------
# Stage 2: The Build Base (Testing & Dev Dependencies)
# ----------------------------------------------------------------------

# Define OS version and Working Directory
FROM node:20-slim AS build_base
# conventional linux path for system packages
WORKDIR /usr/src/app

# Copy Dependencies with clean install for efficiency
COPY package.json package-lock.json ./
RUN npm ci

# Copy the rest of the source files
COPY . .

# Run Tests
# If tests fail, it will stop here

RUN npm run test



# ----------------------------------------------------------------------
# Stage 2: The Final Production Runtime
# Creates the smallest possible image, excluding dev dependencies and test files.
# ----------------------------------------------------------------------
FROM node:20-slim AS production

# Set Node environment to production for enhanced performance 
ENV NODE_ENV=production

WORKDIR /usr/src/app

# Copy RDS Certificate from fetcher stage
COPY --from=fetcher /certs/global-bundle.pem ./src/certs/

# 1. Copy only the dependency files from the build_base stage
COPY --from=build_base /usr/src/app/package.json ./
COPY --from=build_base /usr/src/app/package-lock.json ./

# 2. Install ONLY production dependencies (small image size)
RUN npm ci --production

# 3. Copy only the final source code (excluding test/spec files)
COPY src ./src

# Set the API port defined in your Node.js application
EXPOSE 3000

# Final startup command to run the API server
CMD [ "node", "src/index.js" ]