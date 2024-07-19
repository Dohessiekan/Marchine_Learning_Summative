from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import joblib
import numpy as np

# Define the input data model
class PredictionInput(BaseModel):
    variance: float
    skewness: float
    curtosis: float
    entropy: float


# Create the FastAPI app
app = FastAPI()

@app.get('/')
def index():
    return {'message': 'ALU stress'}


# Load the pre-trained model
model = joblib.load("Bank_Note_Authentication.pkl")

@app.post('/predict')
def predict(input_data: PredictionInput):
    try:
        # Convert input data to numpy array for prediction
        data = np.array([[input_data.variance, input_data.skewness, input_data.curtosis, input_data.entropy]])
        
        # Make prediction
        prediction = model.predict(data)
        
        # Return the prediction
        return {"prediction": prediction[0]}
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    
    

if __name__ == '__main__':
    uvicorn.run(app, host='127.0.0.1', port=8000)