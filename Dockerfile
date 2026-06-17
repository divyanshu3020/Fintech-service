# Context is the monorepo root
FROM oven/bun:1 AS builder

WORKDIR /app

# Copy root configurations
COPY package.json bun.lock turbo.json ./

# Copy shared database package and the specific service
COPY packages/database ./packages/database
COPY services/fintech-service ./services/fintech-service

# Install all dependencies (frozen lockfile to ensure deterministic installation)
RUN bun install --frozen-lockfile

# Generate Prisma Client for the database package
RUN cd packages/database && bun run generate

# Build the specific service
RUN cd services/fintech-service && bun run build

# Final lightweight stage
FROM oven/bun:1-slim

WORKDIR /app

# Copy the monorepo node_modules (which includes installed prisma binaries)
COPY --from=builder /app/node_modules ./node_modules

# Copy the shared database package (contains the generated Prisma client)
COPY --from=builder /app/packages/database ./packages/database

# Copy the built service artifacts
COPY --from=builder /app/services/fintech-service/package.json ./services/fintech-service/package.json
COPY --from=builder /app/services/fintech-service/dist ./services/fintech-service/dist

WORKDIR /app/services/fintech-service

# Expose standard port for fastify applications
EXPOSE 3000

# Start the built application
CMD ["bun", "run", "./dist/index.js"]
