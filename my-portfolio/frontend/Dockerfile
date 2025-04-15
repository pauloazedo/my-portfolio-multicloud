# my-portfolio/frontend/Dockerfile

# Step 1: Build the app
FROM node:18-alpine AS builder

WORKDIR /app

# Copy core configs and install deps
COPY package*.json ./
COPY tsconfig.json ./
COPY next.config.ts ./
COPY tailwind.config.js ./
COPY postcss.config.js ./
COPY eslint.config.mjs ./

RUN npm ci

# Copy full source and build
COPY . .
RUN npm run build

# Step 2: Run the app with Node.js
FROM node:18-alpine

WORKDIR /app
ENV NODE_ENV=production

# Copy build artifacts from builder stage
COPY --from=builder /app ./

# Install only production dependencies
RUN npm ci --omit=dev

# Expose default Next.js port
EXPOSE 3000

# Define container health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
  CMD curl -f http://localhost:3000/healthz || exit 1

# Start the app
CMD ["npm", "start"]
