# Build stage
FROM python:3.13-slim-bookworm AS builder

COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/

WORKDIR /build

COPY pyproject.toml .
RUN uv pip install --system -r pyproject.toml --compile-bytecode

# Final stage
FROM python:3.13-slim-bookworm

# Install nginx
RUN apt-get update && \
    apt-get install -y nginx && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy Python packages and application code
COPY --from=builder /usr/local/lib/python3.13/site-packages /usr/local/lib/python3.13/site-packages
COPY ./app app/

# Copy nginx configuration for ECS
COPY nginx/nginx.conf.ecs /etc/nginx/conf.d/default.conf

# Copy start script
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 80

CMD ["/start.sh"]