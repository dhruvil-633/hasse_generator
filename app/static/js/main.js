document.getElementById('generate-btn').addEventListener('click', async () =
    const elements = document.getElementById('elements').value
        .split(',')
        .map(e =
        .filter(e =

    const relationsText = document.getElementById('relations').value;
    const relations = relationsText.split('\n')
        .map(line =
        .filter(line =
        .map(line =
            const parts = line.split('≤').map(p =
            return [parts[0], parts[1]];
        });

    try {
        const response = await fetch('/generate', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ elements, relations })
        });

        const data = await response.json();
        if (response.ok) {
            renderDiagram(data);
        } else {
        }
    } catch (error) {
        alert(`Error: ${error.message}`);
    }
});

function renderDiagram(diagramData) {
    // Use a library like vis.js, D3.js, or Cytoscape.js to render the diagram
    const container = document.getElementById('diagram-container');
    container.innerHTML = '<p>Diagram would be rendered here</p>';
    console.log('Diagram data:', diagramData);
    // Actual rendering implementation would go here
}
