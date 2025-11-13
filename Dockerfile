FROM node:20-alpine AS base

# Build stage
FROM base AS build
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy source files
COPY . .

# Build the application
RUN npm run build

# Runtime stage
FROM base AS runtime
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install only production dependencies
RUN npm ci --omit=dev

# Copy built application from build stage
COPY --from=build /app/dist ./dist

# Expose port
EXPOSE 4321

# Set environment to production
ENV HOST=0.0.0.0
ENV PORT=4321
ENV NODE_ENV=production

# Start the application
CMD ["node", "./dist/server/entry.mjs"]
