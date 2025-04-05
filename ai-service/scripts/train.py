import os
import pandas as pd
import joblib
import torch
from transformers import T5Tokenizer, T5ForConditionalGeneration
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.naive_bayes import MultinomialNB
from sklearn.pipeline import Pipeline
from sklearn.metrics import accuracy_score, classification_report
from sklearn.metrics.pairwise import cosine_similarity

# 📁 Rutas
CLEAN_DATA_PATH = os.path.abspath(os.path.join('data', 'Resume_clean.csv'))
MODEL_CLASSIFIER_PATH = os.path.abspath(os.path.join('models', 'resume_classifier.pkl'))
MODEL_SUMMARIZER_PATH = os.path.abspath(os.path.join('models', 'resume_summarizer.pt'))

# 📌 Cargar dataset limpio
df = pd.read_csv(CLEAN_DATA_PATH)

# 🔹 División de datos
X_train, X_test, y_train, y_test = train_test_split(df['Resume_str'], df['Category'], test_size=0.2, random_state=42)

# 🚀 1️⃣ Modelo de clasificación (TF-IDF + Naive Bayes)
pipeline = Pipeline([
    ('tfidf', TfidfVectorizer(max_features=5000)),
    ('classifier', MultinomialNB())
])
pipeline.fit(X_train, y_train)

# 📊 Evaluación
y_pred = pipeline.predict(X_test)
accuracy = accuracy_score(y_test, y_pred)
print(f'✔️ Precisión del modelo: {accuracy:.4f}')
print('\n📊 Reporte de clasificación:\n', classification_report(y_test, y_pred))

# 💾 Guardar modelo
os.makedirs(os.path.dirname(MODEL_CLASSIFIER_PATH), exist_ok=True)
joblib.dump(pipeline, MODEL_CLASSIFIER_PATH)
print(f'✔️ Modelo de clasificación guardado en: {MODEL_CLASSIFIER_PATH}')

# 🚀 2️⃣ Modelo de resumen con T5
print("Cargando modelo T5 para resumen...")
summarizer_model = T5ForConditionalGeneration.from_pretrained("t5-small")
summarizer_tokenizer = T5Tokenizer.from_pretrained("t5-small")

# 💾 Guardar modelo T5
torch.save(summarizer_model.state_dict(), MODEL_SUMMARIZER_PATH)
print(f'✔️ Modelo de resumen guardado en: {MODEL_SUMMARIZER_PATH}')

# 🧠 3️⃣ Función para analizar idoneidad a una oferta
def evaluate_fit(resume_text, job_description, vectorizer):
    vectors = vectorizer.transform([resume_text, job_description])
    similarity = cosine_similarity(vectors[0], vectors[1])[0][0]
    return similarity

# ✅ 4️⃣ Función para dar explicación
def explain_fit(score, threshold=0.35):
    if score >= threshold:
        return f"👍 Este perfil es adecuado para la oferta (similaridad: {score:.2f})."
    else:
        return f"👎 Este perfil no es muy adecuado para la oferta (similaridad: {score:.2f})."

# 🔍 Ejemplo rápido
example_resume = X_test.iloc[0]
job_offer = "Looking for a software engineer with Python, REST APIs and cloud experience."

similarity_score = evaluate_fit(example_resume, job_offer, pipeline.named_steps['tfidf'])
print(explain_fit(similarity_score))
