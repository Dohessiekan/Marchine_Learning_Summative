from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import joblib
import numpy as np

# Define the input data model
class PredictionInput(BaseModel):
    age: float
    bmi: float
    children: int
    sex: int
    smoker: int
    region: int

# Create the FastAPI app
app = FastAPI()

@app.get('/')
def index():
    return {'message': 'Welcome to the Insurance Prediction API'}

# Load the pre-trained model
model = joblib.load("Bank_Note_Authentication.pkl")

@app.post('/predict')
def predict(input_data: PredictionInput):
    try:
        # Convert input data to numpy array for prediction
        data = np.array([[input_data.age, input_data.bmi, input_data.children, input_data.sex, input_data.smoker, input_data.region]])
        
        # Log the input data for debugging
        print(f"Input data: {data}")
        
        # Make prediction
        prediction = model.predict(data)
        
        # Log the prediction for debugging
        print(f"Prediction: {prediction}")
        
        # Return the prediction
        return {"prediction": float(prediction[0])}
    
    except Exception as e:
        # Log the error for debugging
        print(f"Error: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == '__main__':
    import uvicorn
    uvicorn.run(app, host='127.0.0.1', port=8000, reload=True)
