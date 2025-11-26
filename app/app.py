import uuid
from datetime import datetime, timezone

from flask import Flask, jsonify, redirect

app = Flask(__name__)

# API method to generate a short URL
@app.route("/shorten", methods=["POST"])
def shorten():
    return jsonify({
        "code": str(uuid.uuid4()),
        "short_url": "short_url",
        "long_url": "long_url",
        "created_at": datetime.now(timezone.utc).isoformat() + "Z"
    }), 201

# API method to get a shortened URL
@app.route("/<code>", methods=["GET"])
def get(code):
    return redirect("https://www.atu.ie", code=302)

# Health check method for the Kubernetes to determine if the POD is healthy
@app.route("/health")
def health():
    return jsonify({"status": "ok"}), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)