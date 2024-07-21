BANKNOTE PREDICTION AND AUTHENTICATION

Welcome to the banknote authentication app, this repository containt three directories, first it is an API about the Banknote prediction, we have another about the Linear_regression model, then we have a banknote_app.

Let see how the API is working and what we need to do it :

Requirements:
To install the necessary dependencies for the machine learning model.

pip install -r requirements.txt

The model will be saved as a .pkl file.

Set up and Installation

After setting up the Backend, run fastapi run dev main to take you to a local host. Navigate to /docs/predict and try out the end point. After that you can start to creat your flutter project:

Overview:
The machine learning model predicts if the note is fake or genuine. on the bankNote we have the variance, skewness, curtosis, entropy. It uses Logistic regression to make the predictions. The model was trained using Banknote data and is deployed as an API endpoint on Render.com.

Endpoint

The deployed on rendee API endpoint for the model is: https://marchine-learning-summative-1.onrender.com/predict -FastAPI swagger end point: http://127.0.0.1:8000/docs#/default/predict_predict_post

Key Features
Input variance, skewness ,curtosis,entropy . Button to prediction. Display the result. Usage Running the Model If you wish to run the model locally, ensure you have all dependencies installed, then execute your Python script or Jupyter notebook containing the model code.

Running the Flutter App To run the Flutter app, navigate to the app directory and use the following command: Flutter run

Here you have the description of my project.
