@echo off
REM Hasse Diagram Generator Project Structure Creator for Windows

REM Create directories
mkdir hasse-diagram-generator
mkdir hasse-diagram-generator\app
mkdir hasse-diagram-generator\app\static
mkdir hasse-diagram-generator\app\static\css
mkdir hasse-diagram-generator\app\static\js
mkdir hasse-diagram-generator\app\static\images
mkdir hasse-diagram-generator\app\templates
mkdir hasse-diagram-generator\venv

REM Create Python files
echo from flask import Flask> hasse-diagram-generator\app\__init__.py
echo.>> hasse-diagram-generator\app\__init__.py
echo def create_app(config_class='config'):>> hasse-diagram-generator\app\__init__.py
echo     app = Flask(__name__)>> hasse-diagram-generator\app\__init__.py
echo     app.config.from_object(config_class)>> hasse-diagram-generator\app\__init__.py
echo.>> hasse-diagram-generator\app\__init__.py
echo     from app import routes>> hasse-diagram-generator\app\__init__.py
echo     app.register_blueprint(routes.bp)>> hasse-diagram-generator\app\__init__.py
echo.>> hasse-diagram-generator\app\__init__.py
echo     return app>> hasse-diagram-generator\app\__init__.py

echo from flask import Blueprint, render_template, request, jsonify> hasse-diagram-generator\app\routes.py
echo from .hasse import generate_hasse_diagram>> hasse-diagram-generator\app\routes.py
echo.>> hasse-diagram-generator\app\routes.py
echo bp = Blueprint('main', __name__)>> hasse-diagram-generator\app\routes.py
echo.>> hasse-diagram-generator\app\routes.py
echo @bp.route('/')>> hasse-diagram-generator\app\routes.py
echo def index():>> hasse-diagram-generator\app\routes.py
echo     return render_template('index.html')>> hasse-diagram-generator\app\routes.py
echo.>> hasse-diagram-generator\app\routes.py
echo @bp.route('/generate', methods=['POST'])>> hasse-diagram-generator\app\routes.py
echo def generate():>> hasse-diagram-generator\app\routes.py
echo     data = request.get_json()>> hasse-diagram-generator\app\routes.py
echo     elements = data.get('elements', [])>> hasse-diagram-generator\app\routes.py
echo     relations = data.get('relations', [])>> hasse-diagram-generator\app\routes.py
echo.>> hasse-diagram-generator\app\routes.py
echo     try:>> hasse-diagram-generator\app\routes.py
echo         diagram_data = generate_hasse_diagram(elements, relations)>> hasse-diagram-generator\app\routes.py
echo         return jsonify(diagram_data)>> hasse-diagram-generator\app\routes.py
echo     except Exception as e:>> hasse-diagram-generator\app\routes.py
echo         return jsonify({'error': str(e)}), 400>> hasse-diagram-generator\app\routes.py

echo def generate_hasse_diagram(elements, relations):> hasse-diagram-generator\app\hasse.py
echo     """>> hasse-diagram-generator\app\hasse.py
echo     Generate Hasse diagram data structure from elements and relations>> hasse-diagram-generator\app\hasse.py
echo     Returns a dictionary with nodes and edges for visualization>> hasse-diagram-generator\app\hasse.py
echo     """>> hasse-diagram-generator\app\hasse.py
echo     # Implementation of Hasse diagram algorithm>> hasse-diagram-generator\app\hasse.py
echo     # This would include transitive reduction, etc.>> hasse-diagram-generator\app\hasse.py
echo.>> hasse-diagram-generator\app\hasse.py
echo     # Placeholder return structure>> hasse-diagram-generator\app\hasse.py
echo     return {>> hasse-diagram-generator\app\hasse.py
echo         'nodes': [{'id': e, 'label': e} for e in elements],>> hasse-diagram-generator\app\hasse.py
echo         'edges': [{'from': r[0], 'to': r[1]} for r in relations]>> hasse-diagram-generator\app\hasse.py
echo     }>> hasse-diagram-generator\app\hasse.py

REM Create HTML templates
echo ^<!DOCTYPE html^>> hasse-diagram-generator\app\templates\base.html
echo ^<html lang="en"^>^> hasse-diagram-generator\app\templates\base.html
echo ^<head^>^> hasse-diagram-generator\app\templates\base.html
echo     ^<meta charset="UTF-8"^>^> hasse-diagram-generator\app\templates\base.html
echo     ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^>^> hasse-diagram-generator\app\templates\base.html
echo     ^<title^>Hasse Diagram Generator^</title^>^> hasse-diagram-generator\app\templates\base.html
echo     ^<link rel="stylesheet" href="{{ url_for('static', filename='css/style.css') }}"^>^> hasse-diagram-generator\app\templates\base.html
echo ^</head^>^> hasse-diagram-generator\app\templates\base.html
echo ^<body^>^> hasse-diagram-generator\app\templates\base.html
echo     ^<header^>^> hasse-diagram-generator\app\templates\base.html
echo         ^<h1^>Hasse Diagram Generator^</h1^>^> hasse-diagram-generator\app\templates\base.html
echo     ^</header^>^> hasse-diagram-generator\app\templates\base.html
echo     ^<main^>^> hasse-diagram-generator\app\templates\base.html
echo         {% block content %}{% endblock %}>> hasse-diagram-generator\app\templates\base.html
echo     ^</main^>^> hasse-diagram-generator\app\templates\base.html
echo     ^<footer^>^> hasse-diagram-generator\app\templates\base.html
echo         ^<p^>Hasse Diagram Generator ^&copy; 2023^</p^>^> hasse-diagram-generator\app\templates\base.html
echo     ^</footer^>^> hasse-diagram-generator\app\templates\base.html
echo     ^<script src="{{ url_for('static', filename='js/main.js') }}"^>^</script^>^> hasse-diagram-generator\app\templates\base.html
echo ^</body^>^> hasse-diagram-generator\app\templates\base.html
echo ^</html^>^> hasse-diagram-generator\app\templates\base.html

echo {% extends "base.html" %} > hasse-diagram-generator\app\templates\index.html
echo.>> hasse-diagram-generator\app\templates\index.html
echo {% block content %}>> hasse-diagram-generator\app\templates\index.html
echo ^<div class="input-section"^>^> hasse-diagram-generator\app\templates\index.html
echo     ^<h2^>Enter Your Poset^</h2^>^> hasse-diagram-generator\app\templates\index.html
echo     ^<div class="input-group"^>^> hasse-diagram-generator\app\templates\index.html
echo         ^<label for="elements"^>Elements (comma separated):^</label^>^> hasse-diagram-generator\app\templates\index.html
echo         ^<input type="text" id="elements" placeholder="a, b, c, d"^>^> hasse-diagram-generator\app\templates\index.html
echo     ^</div^>^> hasse-diagram-generator\app\templates\index.html
echo     ^<div class="input-group"^>^> hasse-diagram-generator\app\templates\index.html
echo         ^<label for="relations"^>Relations (one per line, format: a ^≤ b):^</label^>^> hasse-diagram-generator\app\templates\index.html
echo         ^<textarea id="relations" rows="5" placeholder="a ^≤ b&#10;b ^≤ c"^>^</textarea^>^> hasse-diagram-generator\app\templates\index.html
echo     ^</div^>^> hasse-diagram-generator\app\templates\index.html
echo     ^<button id="generate-btn"^>Generate Hasse Diagram^</button^>^> hasse-diagram-generator\app\templates\index.html
echo ^</div^>^> hasse-diagram-generator\app\templates\index.html
echo ^<div class="visualization-section"^>^> hasse-diagram-generator\app\templates\index.html
echo     ^<div id="diagram-container"^>^</div^>^> hasse-diagram-generator\app\templates\index.html
echo ^</div^>^> hasse-diagram-generator\app\templates\index.html
echo {% endblock %}>> hasse-diagram-generator\app\templates\index.html

REM Create static files
type nul > hasse-diagram-generator\app\static\css\style.css
type nul > hasse-diagram-generator\app\static\js\main.js

echo document.getElementById('generate-btn').addEventListener('click', async () => {> hasse-diagram-generator\app\static\js\main.js
echo     const elements = document.getElementById('elements').value>> hasse-diagram-generator\app\static\js\main.js
echo         .split(',')>> hasse-diagram-generator\app\static\js\main.js
echo         .map(e => e.trim())>> hasse-diagram-generator\app\static\js\main.js
echo         .filter(e => e.length > 0);>> hasse-diagram-generator\app\static\js\main.js
echo.>> hasse-diagram-generator\app\static\js\main.js
echo     const relationsText = document.getElementById('relations').value;>> hasse-diagram-generator\app\static\js\main.js
echo     const relations = relationsText.split('\n')>> hasse-diagram-generator\app\static\js\main.js
echo         .map(line => line.trim())>> hasse-diagram-generator\app\static\js\main.js
echo         .filter(line => line.length > 0)>> hasse-diagram-generator\app\static\js\main.js
echo         .map(line => {>> hasse-diagram-generator\app\static\js\main.js
echo             const parts = line.split('^≤').map(p => p.trim());>> hasse-diagram-generator\app\static\js\main.js
echo             return [parts[0], parts[1]];>> hasse-diagram-generator\app\static\js\main.js
echo         });>> hasse-diagram-generator\app\static\js\main.js
echo.>> hasse-diagram-generator\app\static\js\main.js
echo     try {>> hasse-diagram-generator\app\static\js\main.js
echo         const response = await fetch('/generate', {>> hasse-diagram-generator\app\static\js\main.js
echo             method: 'POST',>> hasse-diagram-generator\app\static\js\main.js
echo             headers: {>> hasse-diagram-generator\app\static\js\main.js
echo                 'Content-Type': 'application/json',>> hasse-diagram-generator\app\static\js\main.js
echo             },>> hasse-diagram-generator\app\static\js\main.js
echo             body: JSON.stringify({ elements, relations })>> hasse-diagram-generator\app\static\js\main.js
echo         });>> hasse-diagram-generator\app\static\js\main.js
echo.>> hasse-diagram-generator\app\static\js\main.js
echo         const data = await response.json();>> hasse-diagram-generator\app\static\js\main.js
echo         if (response.ok) {>> hasse-diagram-generator\app\static\js\main.js
echo             renderDiagram(data);>> hasse-diagram-generator\app\static\js\main.js
echo         } else {>> hasse-diagram-generator\app\static\js\main.js
echo             throw new Error(data.error || 'Unknown error');>> hasse-diagram-generator\app\static\js\main.js
echo         }>> hasse-diagram-generator\app\static\js\main.js
echo     } catch (error) {>> hasse-diagram-generator\app\static\js\main.js
echo         alert(`Error: ${error.message}`);>> hasse-diagram-generator\app\static\js\main.js
echo     }>> hasse-diagram-generator\app\static\js\main.js
echo });>> hasse-diagram-generator\app\static\js\main.js
echo.>> hasse-diagram-generator\app\static\js\main.js
echo function renderDiagram(diagramData) {>> hasse-diagram-generator\app\static\js\main.js
echo     // Use a library like vis.js, D3.js, or Cytoscape.js to render the diagram>> hasse-diagram-generator\app\static\js\main.js
echo     const container = document.getElementById('diagram-container');>> hasse-diagram-generator\app\static\js\main.js
echo     container.innerHTML = '^<p^>Diagram would be rendered here^</p^>';>> hasse-diagram-generator\app\static\js\main.js
echo     console.log('Diagram data:', diagramData);>> hasse-diagram-generator\app\static\js\main.js
echo     // Actual rendering implementation would go here>> hasse-diagram-generator\app\static\js\main.js
echo }>> hasse-diagram-generator\app\static\js\main.js

REM Create config and other files
echo import os> hasse-diagram-generator\config.py
echo.>> hasse-diagram-generator\config.py
echo class Config:>> hasse-diagram-generator\config.py
echo     SECRET_KEY = os.environ.get('SECRET_KEY') or 'dev-key-123'>> hasse-diagram-generator\config.py
echo     DEBUG = False>> hasse-diagram-generator\config.py
echo.>> hasse-diagram-generator\config.py
echo class DevelopmentConfig(Config):>> hasse-diagram-generator\config.py
echo     DEBUG = True>> hasse-diagram-generator\config.py
echo.>> hasse-diagram-generator\config.py
echo class ProductionConfig(Config):>> hasse-diagram-generator\config.py
echo     pass>> hasse-diagram-generator\config.py

echo from app import create_app> hasse-diagram-generator\wsgi.py
echo.>> hasse-diagram-generator\wsgi.py
echo app = create_app()>> hasse-diagram-generator\wsgi.py
echo.>> hasse-diagram-generator\wsgi.py
echo if __name__ == "__main__":>> hasse-diagram-generator\wsgi.py
echo     app.run()>> hasse-diagram-generator\wsgi.py

echo Flask==2.3.2> hasse-diagram-generator\requirements.txt
echo python-dotenv==1.0.0>> hasse-diagram-generator\requirements.txt

echo # Hasse Diagram Generator> hasse-diagram-generator\README.md
echo.>> hasse-diagram-generator\README.md
echo A web application for generating Hasse diagrams from partially ordered sets.>> hasse-diagram-generator\README.md
echo.>> hasse-diagram-generator\README.md
echo ## Installation>> hasse-diagram-generator\README.md
echo.>> hasse-diagram-generator\README.md
echo 1. Create a virtual environment:>> hasse-diagram-generator\README.md
echo ```bash>> hasse-diagram-generator\README.md
echo python -m venv venv>> hasse-diagram-generator\README.md
echo venv\Scripts\activate>> hasse-diagram-generator\README.md
echo ```>> hasse-diagram-generator\README.md
echo.>> hasse-diagram-generator\README.md
echo 2. Install dependencies:>> hasse-diagram-generator\README.md
echo ```bash>> hasse-diagram-generator\README.md
echo pip install -r requirements.txt>> hasse-diagram-generator\README.md
echo ```>> hasse-diagram-generator\README.md
echo.>> hasse-diagram-generator\README.md
echo 3. Run the development server:>> hasse-diagram-generator\README.md
echo ```bash>> hasse-diagram-generator\README.md
echo set FLASK_APP=app>> hasse-diagram-generator\README.md
echo set FLASK_ENV=development>> hasse-diagram-generator\README.md
echo flask run>> hasse-diagram-generator\README.md
echo ```>> hasse-diagram-generator\README.md
echo.>> hasse-diagram-generator\README.md
echo ## Production Deployment>> hasse-diagram-generator\README.md
echo.>> hasse-diagram-generator\README.md
echo Using Waitress (Windows-compatible):>> hasse-diagram-generator\README.md
echo ```bash>> hasse-diagram-generator\README.md
echo pip install waitress>> hasse-diagram-generator\README.md
echo waitress-serve --listen=*:5000 wsgi:app>> hasse-diagram-generator\README.md
echo ```>> hasse-diagram-generator\README.md

echo venv/> hasse-diagram-generator\.gitignore
echo __pycache__/>> hasse-diagram-generator\.gitignore
echo *.pyc>> hasse-diagram-generator\.gitignore
echo *.pyo>> hasse-diagram-generator\.gitignore
echo *.pyd>> hasse-diagram-generator\.gitignore
echo .env>> hasse-diagram-generator\.gitignore

echo Project structure created successfully!
echo To get started:
echo 1. cd hasse-diagram-generator
echo 2. python -m venv venv
echo 3. venv\Scripts\activate
echo 4. pip install -r requirements.txt
echo 5. set FLASK_APP=app
echo 6. set FLASK_ENV=development
echo 7. flask run