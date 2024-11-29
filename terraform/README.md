# uv-fastapi-ecs

A demo repository showing how to use UV package manager with FastAPI, running behind Nginx in Docker, designed for AWS ECS deployment.

## Features

- FastAPI application with health checks
- UV package manager for fast, reliable Python dependency management
- Nginx reverse proxy configuration
- Separate containers for FastAPI and Nginx in both local and ECS setups
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
└── terraform/               # Infrastructure as code for AWS ECS
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

2. Start the development environment:

```bash
docker compose up --build
```

The application will be available at:

- http://localhost/ - Main application
- http://localhost/health - Health check endpoint

### Development Features

- Hot reload enabled for FastAPI application
- Separate containers for FastAPI and Nginx
- Volume mounting for live code updates
- Health checks configured for both services

## Testing ECS Configuration Locally

To test the ECS configuration (FastAPI and Nginx in separate containers):

1. Build the FastAPI and Nginx Docker images:

```bash
docker build -t fastapi-local -f Dockerfile .
docker build -t nginx-local -f Dockerfile.local .
```

2. Run the containers:

```bash
docker run --name fastapi -d -p 8000:8000 fastapi-local
docker run --name nginx -d -p 80:80 --link fastapi nginx-local
```

3. Test the setup:

```bash
curl localhost
curl localhost/health
```

## Understanding the Setup

### Local Development

- Uses separate containers for FastAPI and Nginx.
- Nginx proxies requests to the FastAPI container via Docker networking.
- Code changes reflect immediately due to volume mounting.

### ECS Configuration

- FastAPI and Nginx are deployed as separate containers in the same ECS task definition.
- Nginx proxies requests to FastAPI over the task's internal network.

## API Endpoints

- `GET /`: Returns a welcome message
- `GET /health`: Health check endpoint (returns 200 OK if the service is healthy)

## Python Dependencies

Dependencies are managed through `pyproject.toml`:

- FastAPI: Web framework
- Uvicorn: ASGI server

UV package manager is used for fast, reliable dependency installation.

## Next Steps

Future updates will include:

- Improved monitoring and logging with CloudWatch and Prometheus
- CI/CD pipeline setup with AWS CodePipeline
- Advanced deployment strategies (e.g., blue/green deployments)

## Contributing

Feel free to open issues or submit pull requests.

## License

[MIT License](LICENSE)

---
