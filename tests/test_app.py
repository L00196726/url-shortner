import pytest
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
    assert data["short_url"] == "short_url"

# Test: redirect - success
def test_redirect_success(client):
    response = client.get("/abc")

    # Flask converts redirect target URL
    assert response.status_code == 302
    assert response.location == "https://www.atu.ie"