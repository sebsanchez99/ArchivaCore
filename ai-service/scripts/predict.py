import os
import joblib
import torch
from transformers import (
    T5Tokenizer, T5ForConditionalGeneration,
    BertTokenizer, BertModel, pipeline
)

# 📌 Definir rutas
MODEL_SUMMARY_PATH = os.path.abspath(os.path.join('models', 'resume_summarizer.pt'))
MODEL_CLASSIFIER_PATH = os.path.abspath(os.path.join('models', 'resume_classifier.pkl'))
BERT_MODEL_PATH = os.path.abspath(os.path.join('models', 'bert_model.pt'))

# 📌 Cargar modelos
print("🔄 Cargando modelos...")

# 🔹 Modelo de resumen (T5)
summary_model = T5ForConditionalGeneration.from_pretrained("t5-small")
summary_model.load_state_dict(torch.load(MODEL_SUMMARY_PATH, map_location=torch.device('cpu')))
summary_model.eval()
summary_tokenizer = T5Tokenizer.from_pretrained("t5-small")

# 🔹 Modelo BERT para embeddings
bert_tokenizer = BertTokenizer.from_pretrained("bert-base-uncased")
bert_model = BertModel.from_pretrained("bert-base-uncased")
bert_model.load_state_dict(torch.load(BERT_MODEL_PATH, map_location=torch.device('cpu')))
bert_model.eval()

# 🔹 Clasificador Random Forest
classifier = joblib.load(MODEL_CLASSIFIER_PATH)

# 🔹 Modelo de generación de texto (T5 para justificación)
justification_model = pipeline("text2text-generation", model="t5-small")

# 🔹 Función para generar resumen del CV
def summarize_resume(text):
    input_text = "summarize: " + text
    inputs = summary_tokenizer(input_text, return_tensors="pt", truncation=True, padding=True, max_length=512)
    summary_ids = summary_model.generate(inputs.input_ids, max_length=100, min_length=30, length_penalty=2.0, num_beams=4, early_stopping=True)
    return summary_tokenizer.decode(summary_ids[0], skip_special_tokens=True)

# 🔹 Función para extraer embeddings BERT (optimizada con mean pooling)
def extract_bert_embeddings(text):
    inputs = bert_tokenizer(text, padding=True, truncation=True, return_tensors="pt")
    with torch.no_grad():
        outputs = bert_model(**inputs)
    embeddings = outputs.last_hidden_state.mean(dim=1).numpy()  # Mean pooling
    return embeddings.reshape(1, -1)  # Asegurar que tenga la forma correcta para el clasificador

# 🔹 Función para predecir categoría del CV
def predict_resume_category(text):
    embeddings = extract_bert_embeddings(text)
    category = classifier.predict(embeddings)[0]
    return category

# 🔹 Función para analizar compatibilidad
def analyze_compatibility(cv_text, job_text):
    """Identifica los requisitos cumplidos y faltantes comparando palabras clave."""
    cv_words = set(cv_text.lower().split())
    job_words = set(job_text.lower().split())

    matched = cv_words.intersection(job_words)
    missing = job_words - cv_words

    compatibility = len(matched) / len(job_words) * 100 if job_words else 0

    return round(compatibility, 2), list(matched), list(missing)

# 🔹 Nueva función para generar una justificación con T5
def generate_ai_justification(cv_text, job_text, compatibility):
    prompt = f"Given a resume: {cv_text} and a job offer: {job_text}, explain if the candidate is suitable. The compatibility is {compatibility} percent."
    response = justification_model(prompt, max_length=100, do_sample=True)
    return response[0]['generated_text']

# 📝 Ejemplo de CV y oferta de trabajo
resume_text = """
Experienced Data Scientist specializing in Machine Learning, NLP, and AI projects.
Worked in various industries applying data science to solve complex problems.
Familiar with Python, Deep Learning, and TensorFlow.
"""
job_offer_text = """
Looking for a Machine Learning Engineer with expertise in Python, Data Analysis, Cloud Computing, and Kubernetes.
"""

# 🔹 Ejecutar análisis
print("\n🔍 Analizando CV...\n")

# 1️⃣ Generar resumen
resume_summary = summarize_resume(resume_text)
print(f"📜 Resumen del CV:\n{resume_summary}\n")

# 2️⃣ Predecir categoría
predicted_category = predict_resume_category(resume_text)
print(f"🏷️ Categoría Predicha: {predicted_category}\n")

# 3️⃣ Analizar compatibilidad
compatibility, matched_requirements, missing_requirements = analyze_compatibility(resume_text, job_offer_text)
print(f"✅ Compatibilidad: {compatibility}%")
print(f"✔️ Requisitos cumplidos: {matched_requirements}")
print(f"❌ Requisitos faltantes: {missing_requirements}\n")

# 4️⃣ Generar justificación con T5
justification = generate_ai_justification(resume_text, job_offer_text, compatibility)
print(f"🤖 Justificación:\n{justification}\n")
