FROM node:20-alpine AS base

# Build stage
FROM base AS build
WORKDIR /app

# Copy package files
COPY package.json package-lock.json* ./

# Install dependencies with npm install (more flexible than ci)
RUN npm install --frozen-lockfile || npm install

# Copy source files
COPY . .

# Build the application
RUN npm run build

# Runtime stage
FROM base AS runtime
WORKDIR /app

# Copy package files
COPY package.json package-lock.json* ./

# Install only production dependencies
RUN npm install --production --frozen-lockfile || npm install --production

# Copy built application from build stage
COPY --from=build /app/dist ./dist

# Expose port
EXPOSE 4321

# Set environment to production
ENV HOST=0.0.0.0
ENV PORT=4321
ENV NODE_ENV=production

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=30s --retries=3 \
  CMD node -e "require('http').get('http://localhost:4321', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

# Start the application
CMD ["node", "./dist/server/entry.mjs"]
