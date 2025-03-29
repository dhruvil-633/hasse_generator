from flask import Blueprint, render_template, request, jsonify
from .hasse import generate_hasse_diagram

bp = Blueprint('main', __name__)

@bp.route('/')
def index():
    return render_template('index.html')  # Make sure this line is exactly like this

@bp.route('/generate', methods=['POST'])
def generate():
    data = request.get_json()
    elements = data.get('elements', [])
    relations = data.get('relations', [])
    
    try:
        diagram_data = generate_hasse_diagram(elements, relations)
        return jsonify(diagram_data)  # This is correct for the API endpoint
    except Exception as e:
        return jsonify({'error': str(e)}), 400