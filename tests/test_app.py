import pytest
import re
from unittest.mock import patch, MagicMock
from app import app  # import the app


@pytest.fixture
def client():
    app.config["TESTING"] = True
    return app.test_client()


# Test: /shorten - success
def test_shorten_success(client):
    response = client.post(
        "/shorten",
        json={"url": "https://example.com"}
    )

    assert response.status_code == 201
    data = response.get_json()
    assert data["long_url"] == "long_url"
    assert re.match(r"^http://localhost:5000/.+", data["short_url"])
    assert "code" in data
    assert "created_at" in data

# Test: redirect - success
def test_redirect_success(client):
    response = client.get("/abc")

    # Flask converts redirect target URL
    assert response.status_code == 302
    assert response.location == "https://www.atu.ie"

# Test: /health - success
def test_health_success(client):
    response = client.get("/health")

    assert response.status_code == 200
    data = response.get_json()

    assert data["status"] == "ok"