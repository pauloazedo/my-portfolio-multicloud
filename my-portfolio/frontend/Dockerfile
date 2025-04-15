# my-portfolio/frontend/Dockerfile

# Step 1: Build the app
FROM node:18.20.2-slim AS builder

WORKDIR /app

# Copy config and env
COPY package*.json ./
COPY tsconfig.json ./
COPY next.config.ts ./
COPY tailwind.config.js ./
COPY postcss.config.js ./
COPY eslint.config.mjs ./
COPY .env.production .env.production

RUN npm ci

# Copy the rest and build
COPY . .
RUN npm run build

# Step 2: Run the app with Node.js
FROM node:18.20.2-slim

WORKDIR /app
ENV NODE_ENV=production

# Install curl for healthcheck
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Copy build artifacts from builder
COPY --from=builder /app ./

# Install only production dependencies
RUN npm ci --omit=dev

# Expose Next.js default port
EXPOSE 3000

# Define healthcheck for container status
HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
  CMD curl -f http://localhost:3000/api/healthz || exit 1

# Start the app
CMD ["npm", "start"]
