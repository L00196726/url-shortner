# url-shortner
This is a sample implementation of URL Shortner to be used on IaC CA2 Lab Terraform and DevOps Software Engineer Lab 3

## Requirements
This repo requires:
* docker
* python
* github

## Build Steps
Run `./scripts/build.sh`

## Running locally
* Create a virtual environment
```
python3 -m venv venv
source venv/bin/activate
pip install -r app/requirements.txt
```
* Execute the app `export FLASK_APP=app/app.py; python3 app/app.py`
### Send requests
* Get URL
```
curl -I http://localhost:5000/uuidcode
```
* Post URL
```
curl -X POST http://localhost:5000/shorten \
     -H "Content-Type: application/json" \
     -d '{"url": "https://example.com"}'
```
* Health check
```
curl http://localhost:5000/health
```

## Run unit-tests locally
Run `pytest -v` on root
