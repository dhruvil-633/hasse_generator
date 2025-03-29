def generate_hasse_diagram(elements, relations):
    """Generate Hasse diagram with transitive reduction"""
    # Convert to sets for faster lookups
    element_set = set(elements)
    
    # Validate and normalize relations
    validated_relations = []
    for a, b in relations:
        if a not in element_set:
            raise ValueError(f"Element '{a}' not found in elements list")
        if b not in element_set:
            raise ValueError(f"Element '{b}' not found in elements list")
        if a == b:
            raise ValueError(f"Self-relation not allowed: '{a} ≤ {b}'")
        validated_relations.append((a, b))
    
    # Remove duplicate relations
    unique_relations = list(set(validated_relations))
    
    # Transitive reduction
    edges = set(unique_relations)
    for a, b in list(edges):
        for _, c in [e for e in edges if e[0] == b]:
            if (a, c) in edges:
                edges.remove((a, c))
    
    # Calculate levels
    levels = {e: 0 for e in elements}
    changed = True
    while changed:
        changed = False
        for a, b in edges:
            if levels[a] >= levels[b]:
                levels[b] = levels[a] + 1
                changed = True
    
    return {
        'nodes': [{'id': e, 'label': e, 'level': levels[e]} for e in elements],
        'edges': [{'from': a, 'to': b} for a, b in edges]
    }