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
        
        # Make prediction (get continuous output)
        continuous_output = model.predict(data)
        
        # Apply threshold of 0.5 to get binary output
        binary_prediction = (continuous_output > 0.5).astype(int)
        
        # Return the prediction
        return {"prediction": int(binary_prediction[0])}
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == '__main__':
    import uvicorn
    uvicorn.run(app, host='127.0.0.1', port=8000)
