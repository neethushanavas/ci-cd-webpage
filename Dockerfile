# Use a smaller Python base image
FROM python:3.12-alpine AS build

ENV AWS_DEFAULT_REGION=us-east-1

WORKDIR /app

# Combine the RUN commands to reduce layers, and clean up after installing
RUN apk update && apk add --no-cache curl && \
    pip install --no-cache-dir boto3 flask && \
    rm -rf /var/cache/apk/*

# Stage 2: Final stage
FROM python:3.12-alpine

WORKDIR /app

# Copy only necessary artifacts from the build stage
COPY --from=build /app /app


EXPOSE 5000

CMD ["python3", "app.py"]

