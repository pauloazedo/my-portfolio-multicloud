# my-portfolio/frontend/Dockerfile

# Step 1: Build the app
FROM node:18.20.2-slim AS builder

WORKDIR /app

# Copy config files and environment
COPY package*.json ./
COPY tsconfig.json ./
COPY next.config.ts ./
COPY tailwind.config.js ./
COPY postcss.config.js ./
COPY eslint.config.mjs ./
COPY .env.production .env.production

RUN npm ci

# Copy source code and build
COPY . .
RUN npm run build

# Step 2: Run the app in production
FROM node:18.20.2-slim

WORKDIR /app
ENV NODE_ENV=production

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app ./
RUN npm ci --omit=dev

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
  CMD curl -f http://localhost:3000/ || exit 1

CMD ["npm", "start"]
