# Step 1: Build the app
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./
COPY tsconfig.json ./
COPY next.config.ts ./
COPY tailwind.config.js ./
COPY postcss.config.js ./
COPY eslint.config.mjs ./

RUN npm ci

COPY . .

RUN npm run build

# Step 2: Run the app with Node.js
FROM node:18-alpine

WORKDIR /app
ENV NODE_ENV=production

COPY --from=builder /app ./

# Install only production dependencies
RUN npm ci --omit=dev

EXPOSE 3000

CMD ["npm", "start"]