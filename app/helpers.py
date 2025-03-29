def validate_poset(elements, relations):
    """Validate poset input data"""
    if len(elements) != len(set(elements)):
        raise ValueError("Duplicate elements found")
    
    for a, b in relations:
        if a not in elements or b not in elements:
            raise ValueError(f"Invalid relation between {a} and {b}")
    
    # Check for cycles
    graph = {e: [] for e in elements}
    for a, b in relations:
        graph[a].append(b)
    
    visited = set()
    
    def has_cycle(node, stack):
        if node in stack:
            return True
        if node in visited:
            return False
            
        visited.add(node)
        stack.add(node)
        
        for neighbor in graph.get(node, []):
            if has_cycle(neighbor, stack):
                return True
                
        stack.remove(node)
        return False
    
    for node in elements:
        if has_cycle(node, set()):
            raise ValueError("Cycle detected in relations")