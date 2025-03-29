document.addEventListener('DOMContentLoaded', function() {
    // Constants and DOM Elements
    const container = document.getElementById('diagram-container');
    const elementsInput = document.getElementById('elements');
    const relationsInput = document.getElementById('relations');
    const generateBtn = document.getElementById('generate-btn');
    const loadExampleBtn = document.getElementById('load-example');
    const clearBtn = document.getElementById('clear-btn');
    const fitBtn = document.getElementById('fit-btn');
    let network = null;

    // Event Listeners
    generateBtn.addEventListener('click', generateDiagram);
    loadExampleBtn.addEventListener('click', loadExample);
    clearBtn.addEventListener('click', clearAll);
    if (fitBtn) fitBtn.addEventListener('click', fitToView);

    // Main Diagram Generation Function
    async function generateDiagram() {
        try {
            setLoadingState(true);
            clearErrors();
            
            const elements = getElements();
            const relations = getRelations(elements);
            
            const diagramData = await sendToServer(elements, relations);
            renderDiagram(diagramData);
            
        } catch (error) {
            showError(error.message);
        } finally {
            setLoadingState(false);
        }
    }

    // Input Processing Functions
    function getElements() {
        const input = elementsInput.value.trim();
        if (!input) throw new Error("Please enter at least one element");

        const elements = input.split(',')
            .map(e => e.trim())
            .filter(e => e.length > 0);
            
        if (elements.length === 0) {
            throw new Error("Please enter valid elements");
        }
        
        const uniqueElements = [...new Set(elements)];
        if (uniqueElements.length !== elements.length) {
            throw new Error("Duplicate elements found");
        }
        
        return elements;
    }

    function getRelations(elements) {
        const elementSet = new Set(elements);
        const input = relationsInput.value.trim();
        if (!input) return [];

        return input.split('\n')
            .map(line => line.trim())
            .filter(line => line.length > 0)
            .map((line, i) => {
                try {
                    // Handle multiple relation formats
                    let separator = '≤';
                    if (line.includes('<=')) separator = '<=';
                    
                    const parts = line.split(separator).map(p => p.trim());
                    if (parts.length !== 2 || !parts[0] || !parts[1]) {
                        throw new Error(`Invalid format in line ${i+1}`);
                    }
                    
                    const [from, to] = parts;
                    
                    if (from === to) {
                        throw new Error(`Self-loop not allowed: "${from} ≤ ${to}"`);
                    }
                    if (!elementSet.has(from)) {
                        throw new Error(`"${from}" not in elements`);
                    }
                    if (!elementSet.has(to)) {
                        throw new Error(`"${to}" not in elements`);
                    }
                    
                    return { from, to, original: line };
                } catch (err) {
                    throw new Error(`Error in relation "${line}": ${err.message}`);
                }
            });
    }

    // Server Communication
    async function sendToServer(elements, relations) {
        try {
            const response = await fetch('/generate', {
                method: 'POST',
                headers: { 
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                },
                body: JSON.stringify({
                    elements: elements,
                    relations: relations.map(rel => [rel.from, rel.to])
                })
            });
            
            if (!response.ok) {
                const error = await response.json();
                throw new Error(error.error || `Server error: ${response.status}`);
            }
            
            return await response.json();
        } catch (error) {
            throw new Error(`Request failed: ${error.message}`);
        }
    }
    // Visualization Functions
    function renderDiagram(data) {
        if (!data?.nodes || !data?.edges) {
            throw new Error('Invalid diagram data from server');
        }

        container.innerHTML = '';
        
        const nodes = new vis.DataSet(data.nodes.map(node => ({
            id: node.id,
            label: node.label,
            level: node.level || 0,
            shape: 'box',
            margin: 10,
            font: { size: 16 },
            widthConstraint: { maximum: 150 },
            color: {
                background: '#e3f2fd',
                border: '#2196f3',
                highlight: {
                    background: '#bbdefb',
                    border: '#2196f3'
                }
            }
        })));

        const edges = new vis.DataSet(data.edges.map(edge => ({
            from: edge.from,
            to: edge.to,
            arrows: 'to',
            width: 2,
            color: '#2c3e50',
            smooth: { type: 'curvedCW', roundness: 0.2 }
        })));

        if (network) network.destroy();
        
        network = new vis.Network(container, { nodes, edges }, {
            layout: {
                hierarchical: {
                    direction: 'UD',
                    sortMethod: 'directed',
                    nodeSpacing: 150,
                    levelSeparation: 100
                }
            },
            physics: {
                hierarchicalRepulsion: {
                    nodeDistance: 200
                }
            },
            interaction: {
                tooltipDelay: 200,
                hideEdgesOnDrag: true
            }
        });
    }

    // UI Helper Functions
    function setLoadingState(isLoading) {
        generateBtn.disabled = isLoading;
        generateBtn.innerHTML = isLoading 
            ? '<span class="spinner"></span> Generating...' 
            : 'Generate Diagram';
    }

    function showError(message) {
        const errorDiv = document.createElement('div');
        errorDiv.className = 'error-message';
        errorDiv.innerHTML = `
            <div class="error-content">
                <span>${message}</span>
                <button class="close-btn" aria-label="Close error">&times;</button>
            </div>
        `;
        
        errorDiv.querySelector('.close-btn').addEventListener('click', () => {
            errorDiv.classList.add('fade-out');
            setTimeout(() => errorDiv.remove(), 300);
        });
        
        const errorContainer = document.getElementById('error-container');
        errorContainer.prepend(errorDiv);
        
        setTimeout(() => {
            if (errorDiv.parentNode) {
                errorDiv.classList.add('fade-out');
                setTimeout(() => errorDiv.remove(), 300);
            }
        }, 8000);
    }

    function clearErrors() {
        document.getElementById('error-container').innerHTML = '';
    }

    // Example and Utility Functions
    function loadExample() {
        elementsInput.value = 'a, b, c, d, e';
        relationsInput.value = [
            'a ≤ b',
            'a ≤ c',
            'b ≤ d',
            'c ≤ d',
            'd ≤ e'
        ].join('\n');
    }

    function clearAll() {
        elementsInput.value = '';
        relationsInput.value = '';
        clearDiagram();
    }

    function clearDiagram() {
        container.innerHTML = `
            <div class="empty-state">
                <div class="empty-icon">📊</div>
                <h4>No diagram generated</h4>
                <p>Enter elements and relations above</p>
            </div>
        `;
        if (network) {
            network.destroy();
            network = null;
        }
    }

    function fitToView() {
        if (network) {
            network.fit({
                animation: {
                    duration: 500,
                    easingFunction: 'easeInOutQuad'
                }
            });
        }
    }

    // Initialize
    clearDiagram();
});