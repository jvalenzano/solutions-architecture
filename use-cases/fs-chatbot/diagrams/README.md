# Architecture Diagrams

## Overview
This directory contains the architectural diagrams for the Forest Service Chatbot system.

## Directory Structure
- \c4-models/\: C4 model diagrams (Context, Container, Component)
  - \source/\: PlantUML source files
  - \endered/png/\: PNG format diagrams
  - \endered/svg/\: SVG format diagrams
- \sequence/\: Sequence diagrams
  - \source/\: PlantUML source files
  - \endered/png/\: PNG format diagrams
  - \endered/svg/\: SVG format diagrams

## Diagram Types
### DEPLOYMENT (L4)
- Category: c4-models
- Purpose: Deployment diagram mapping software components to infrastructure
- Source: \$(System.Collections.Hashtable.category)/source/deployment.puml\
- Rendered: \$(System.Collections.Hashtable.category)/rendered/[png|svg]/deployment.[png|svg]\
 ### DATA-INTEGRATION (L3)
- Category: c4-models
- Purpose: Component diagram focusing on the data integration container
- Source: \$(System.Collections.Hashtable.category)/source/data-integration.puml\
- Rendered: \$(System.Collections.Hashtable.category)/rendered/[png|svg]/data-integration.[png|svg]\
 ### SYSTEM-CONTEXT (L1)
- Category: c4-models
- Purpose: System Context diagram showing the chatbot system in relation to its users and external systems
- Source: \$(System.Collections.Hashtable.category)/source/system-context.puml\
- Rendered: \$(System.Collections.Hashtable.category)/rendered/[png|svg]/system-context.[png|svg]\
 ### TRAIL-STATUS (sequence)
- Category: sequence
- Purpose: Sequence diagram showing the trail status inquiry flow
- Source: \$(System.Collections.Hashtable.category)/source/trail-status.puml\
- Rendered: \$(System.Collections.Hashtable.category)/rendered/[png|svg]/trail-status.[png|svg]\
 ### CONTAINER (L2)
- Category: c4-models
- Purpose: Container diagram showing the high-level technical components of the system
- Source: \$(System.Collections.Hashtable.category)/source/container.puml\
- Rendered: \$(System.Collections.Hashtable.category)/rendered/[png|svg]/container.[png|svg]\


## Updating Diagrams
1. Modify the source .puml file in the appropriate source directory
2. Run the update-diagrams.ps1 script to regenerate renders
3. Commit both source and rendered versions

## Tools
- PlantUML is required for diagram generation
- VS Code with PlantUML extension recommended for editing
