# Define OS version and Working Directory
FROM node:20-slim AS builder
WORKDIR /app

# Copy Dependencies with clean install for efficiency
COPY package.json package-lock.json ./
RUN npm ci

# Copy the rest of the source files
COPY . .

# Build
RUN npm run build

# Runtime Stage

FROM nginx:1.27-alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]