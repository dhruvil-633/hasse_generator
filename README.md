# Hasse Diagram Generator

A web application for generating Hasse diagrams from partially ordered sets.

## Installation

1. Create a virtual environment:
```bash
python -m venv venv
venv\Scripts\activate
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

3. Run the development server:
```bash
set FLASK_APP=app
set FLASK_ENV=development
flask run
```

## Production Deployment

Using Waitress (Windows-compatible):
```bash
pip install waitress
waitress-serve --listen=*:5000 wsgi:app
```
