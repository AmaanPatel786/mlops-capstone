from fastapi import FastAPI
from pydantic import BaseModel
import pandas as pd
import joblib

# Directly load the pickle
MODEL_PATH = r"models/rf_model.pkl"
model = joblib.load(MODEL_PATH)

app = FastAPI(title="MLOps Capstone Model API")

class InputData(BaseModel):
    features: list  # Example: [5.1, 3.5, 1.4, 0.2]

@app.get("/")
def root():
    return {"message": "MLOps Capstone API is running!"}

@app.post("/predict")
def predict(data: InputData):
    try:
        X = pd.DataFrame([data.features])
        prediction = model.predict(X)
        return {"prediction": prediction.tolist()}
    except Exception as e:
        return {"error": str(e)}
