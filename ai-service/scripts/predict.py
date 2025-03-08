import os
import joblib

MODEL_PATH = os.path.abspath(os.path.join('models', 'resume_classifier.pkl'))

pipeline = joblib.load(MODEL_PATH)

def predict_resume_category(text):
    category = pipeline.predict([text])[0]
    return category

resume_text = """
    HR specialist with a strong background in talent acquisition, employee relations, and organizational development. 
    Worked in multinational companies managing recruitment processes and performance evaluations.
"""
predicted_category = predict_resume_category(resume_text)
print(f"Categoría Predicha: {predicted_category}")