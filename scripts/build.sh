#!/usr/bin/env bash
set -e

IMAGE_NAME="matheusmaximo/url-shortener"
TAG=$(git rev-parse --short HEAD)
TEST_ENV=".venv"
COVERAGE_THRESHOLD=90

echo "Running tests..."
if [ ! -d "$TEST_ENV" ]; then
    python3 -m venv $TEST_ENV
fi

source $TEST_ENV/bin/activate
pip install -r app/requirements.txt
pip install -r tests/requirements-test.txt

pytest -v --cov=app --cov-report=term --cov-fail-under=$COVERAGE_THRESHOLD

echo "Building Docker image..."
docker build -t ${IMAGE_NAME}:${TAG} -t ${IMAGE_NAME}:latest .

echo "Build complete: ${IMAGE_NAME}:${TAG}"

echo "Pushing to Docker Hub..."
docker push ${IMAGE_NAME}:${TAG}
docker push ${IMAGE_NAME}:latest