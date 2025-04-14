import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.svm import SVC
import pickle
import os

# Load the training dataset
df = pd.read_csv('datasets/training.csv')  # Adjust if your path is different

# Split features and target
X = df.drop('prognosis', axis=1)
y = df['prognosis']

# Split into training and testing sets (optional)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Train the Support Vector Classifier model
model = SVC(kernel='linear', probability=True)
model.fit(X_train, y_train)

# Ensure the 'models' directory exists
os.makedirs('models', exist_ok=True)

# Save the trained model to a file
with open('models/svc.pkl', 'wb') as f:
    pickle.dump(model, f)

print("✅ Model trained and saved successfully as models/svc.pkl")
