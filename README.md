# MLOps Capstone - mlops-capstone

This repository is a complete end-to-end MLOps capstone example (Iris dataset).
It includes data versioning with DVC, MLflow instrumented training, FastAPI serving,
Dockerfile, GitHub Actions CI workflow, a simple Terraform example, and a monitoring script.

## Contents
- data/ (dvc-tracked dataset.csv)
- src/ (preprocess, train, monitor)
- app.py (FastAPI app)
- Dockerfile
- .gitignore
- src/requirements.txt
- .github/workflows/ci.yml
- terraform/ (main.tf, variables.tf)
- dvc.yaml (optional pipeline)

See below for how to run the project locally.
