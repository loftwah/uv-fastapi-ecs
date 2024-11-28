# uv-fastapi-ecs

A demo repository showing how to use UV package manager with FastAPI, running behind Nginx in Docker, designed for AWS ECS deployment.

## Features

- FastAPI application with health checks
- UV package manager for fast, reliable Python dependency management
- Nginx reverse proxy configuration
- Separate local development and ECS production setups
- Multi-stage Docker builds for optimized images
- Docker Compose for local development

## Project Structure

```plaintext
.
├── app
│   └── main.py                # FastAPI application
├── nginx
│   ├── nginx.conf.ecs        # Nginx config for ECS
│   └── nginx.conf.local      # Nginx config for local development
├── Dockerfile                # FastAPI Dockerfile
├── Dockerfile.local          # Nginx Dockerfile for local dev
├── Dockerfile.nginx          # Nginx Dockerfile for ECS
├── docker-compose.yml        # Local development setup
├── pyproject.toml           # Python dependencies
└── start.sh                 # Script to run FastAPI and Nginx in ECS
```

## Prerequisites

- Docker
- Docker Compose
- Python 3.13 (for local development)
- At least 2GB of free RAM
- At least 5GB of free disk space

## Local Development

1. Clone the repository:

```bash
git clone https://github.com/loftwah/uv-fastapi-ecs.git
cd uv-fastapi-ecs
```

2. Make the start script executable:

```bash
chmod +x start.sh
```

3. Start the development environment:

```bash
docker compose up --build
```

The application will be available at:

- http://localhost/ - Main application
- http://localhost/health - Health check endpoint

### Development Features

- Hot reload enabled for FastAPI application
- Separate containers for API and Nginx
- Volume mounting for live code updates
- Health checks configured for both services

## Testing ECS Configuration Locally

To test the ECS configuration (combined FastAPI and Nginx in single container):

```bash
# Build the ECS image
docker compose up --build

# Test with cURL
curl localhost
curl localhost/health
```

## Understanding the Setup

### Local Development

- Uses separate containers for FastAPI and Nginx
- Nginx proxies requests to FastAPI container using Docker network
- Code changes reflect immediately due to volume mounting

### ECS Configuration

- Combines FastAPI and Nginx in a single container
- Uses `start.sh` script to run both services
- Nginx proxies to localhost since both services are in same container

## API Endpoints

- `GET /`: Returns a welcome message
- `GET /health`: Health check endpoint (returns 200 OK if service is healthy)

## Python Dependencies

Dependencies are managed through `pyproject.toml`:

- FastAPI: Web framework
- Uvicorn: ASGI server

UV package manager is used for fast, reliable dependency installation.

## Next Steps

Future updates will include:

- AWS ECS deployment configuration
- Terraform infrastructure as code
- CI/CD pipeline setup
- Monitoring and logging configuration

## Contributing

Feel free to open issues or submit pull requests.

## License

[MIT License](LICENSE)
