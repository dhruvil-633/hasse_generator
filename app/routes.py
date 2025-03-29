from flask import Blueprint, request, jsonify, current_app, render_template
from .hasse import generate_hasse_diagram

bp = Blueprint('main', __name__)

# Add this route
@bp.route('/')
def index():
    return render_template('index.html')

@bp.route('/generate', methods=['POST'])
def generate():
    # Validate request content type
    if not request.is_json:
        return jsonify({'error': 'Request must be JSON'}), 415
        
    try:
        data = request.get_json()
        
        # Validate request structure
        if not isinstance(data, dict):
            return jsonify({'error': 'Invalid request format'}), 400
            
        # Validate elements
        if 'elements' not in data or not isinstance(data['elements'], list):
            return jsonify({'error': 'Elements must be provided as a list'}), 400
            
        elements = []
        seen_elements = set()
        for i, e in enumerate(data['elements']):
            try:
                element = str(e).strip()
                if not element:
                    raise ValueError("Empty element")
                if element in seen_elements:
                    raise ValueError("Duplicate element")
                elements.append(element)
                seen_elements.add(element)
            except (TypeError, ValueError) as ve:
                return jsonify({
                    'error': f'Invalid element at position {i}: {str(ve)}'
                }), 400
        
        # Validate relations
        if 'relations' not in data or not isinstance(data['relations'], list):
            return jsonify({'error': 'Relations must be provided as a list'}), 400
            
        relations = []
        for i, rel in enumerate(data['relations']):
            try:
                # Handle both list and string formats
                if isinstance(rel, list):
                    if len(rel) != 2:
                        raise ValueError("Relation must have exactly 2 elements")
                    from_elem, to_elem = str(rel[0]).strip(), str(rel[1]).strip()
                elif isinstance(rel, str):
                    parts = [p.strip() for p in rel.split('≤') if p.strip()]
                    if len(parts) != 2:
                        parts = [p.strip() for p in rel.split('<=') if p.strip()]  # Also support <= syntax
                        if len(parts) != 2:
                            raise ValueError("Must use format 'a ≤ b' or 'a <= b'")
                    from_elem, to_elem = parts[0], parts[1]
                else:
                    raise ValueError("Invalid relation format")
                
                # Validate relation content
                if not from_elem or not to_elem:
                    raise ValueError("Empty element in relation")
                if from_elem not in seen_elements:
                    raise ValueError(f"'{from_elem}' not in elements list")
                if to_elem not in seen_elements:
                    raise ValueError(f"'{to_elem}' not in elements list")
                if from_elem == to_elem:
                    raise ValueError("Self-relations are not allowed")
                
                relations.append((from_elem, to_elem))
                
            except (TypeError, ValueError) as ve:
                return jsonify({
                    'error': f'Invalid relation at position {i}: {str(ve)}'
                }), 400
        
        # Generate diagram
        diagram_data = generate_hasse_diagram(elements, relations)
        return jsonify(diagram_data)
        
    except Exception as e:
        # Log the unexpected error for debugging
        current_app.logger.error(f"Unexpected error: {str(e)}")
        return jsonify({
            'error': 'An unexpected error occurred',
            'details': str(e)
        }), 500