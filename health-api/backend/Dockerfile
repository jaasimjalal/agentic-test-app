FROM node:20-alpine AS base

# Install dependencies for building
RUN apk add --no-cache tini

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production && npm cache clean --force

# Copy built application
COPY dist ./dist

# Use tini for proper signal handling
ENTRYPOINT ["/sbin/tini", "--"]

# Run the application
CMD ["node", "dist/server.js"]

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

FROM node:20-alpine AS builder

WORKDIR /app

# Copy source files
COPY . .

# Install dev dependencies and build
RUN npm ci && npm run build

# Copy build output to production stage
FROM base

COPY --from=builder /app/dist /app/dist

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S healthapi -u 1001

# Set ownership
RUN chown -R healthapi:nodejs /app

USER healthapi

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1

EXPOSE 3000