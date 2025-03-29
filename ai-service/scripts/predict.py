import os
import joblib
import torch
import spacy
import nltk
from nltk.corpus import wordnet
from transformers import (
    T5Tokenizer, T5ForConditionalGeneration,
    BertTokenizer, BertModel, pipeline
)

# 📌 Descargar recursos de NLP
nltk.download('wordnet')

# 📌 Cargar modelo de lenguaje en inglés de spaCy
nlp = spacy.load("en_core_web_sm")

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

# 🔹 Diccionario de habilidades con sinónimos
TECH_SKILLS = {
    "python": {"python", "py"},
    "data": {"data", "dataset", "big data"},
    "machine learning": {"machine learning", "ml", "deep learning", "artificial intelligence"},
    "cloud": {"cloud", "cloud computing", "aws", "azure", "gcp"},
    "computing": {"computing", "distributed systems", "high-performance computing"},
    "analysis": {"analysis", "data analysis", "analytics", "business intelligence"},
    "kubernetes": {"kubernetes", "k8s", "container orchestration"}
}

# 🔹 Función para extraer sinónimos desde WordNet
def get_synonyms(word):
    synonyms = set()
    for syn in wordnet.synsets(word):
        for lemma in syn.lemmas():
            synonyms.add(lemma.name().lower())
    return synonyms

# 🔹 Función para extraer habilidades del texto con spaCy y sinónimos
def extract_skills(text):
    doc = nlp(text.lower())
    found_skills = set()

    # Verificar palabras exactas
    for token in doc:
        for key, synonyms in TECH_SKILLS.items():
            if token.text in synonyms:
                found_skills.add(key)

    # Verificar entidades nombradas
    for ent in doc.ents:
        for key, synonyms in TECH_SKILLS.items():
            if ent.text.lower() in synonyms:
                found_skills.add(key)

    return found_skills

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
    """Identifica los requisitos cumplidos y faltantes comparando palabras clave y habilidades detectadas."""
    cv_skills = extract_skills(cv_text)
    job_skills = extract_skills(job_text)

    matched = cv_skills.intersection(job_skills)
    missing = job_skills - cv_skills

    compatibility = len(matched) / len(job_skills) * 100 if job_skills else 0

    return round(compatibility, 2), list(matched), list(missing)

# 🔹 Función para generar una justificación con T5
def generate_ai_justification(cv_text, job_text, compatibility):
    prompt = f"Given a resume: {cv_text} and a job offer: {job_text}, explain if the candidate is suitable. The compatibility is {compatibility} percent."
    response = justification_model(prompt, max_length=100, do_sample=True)
    return response[0]['generated_text']

# 📝 Ejemplo de CV y oferta de trabajo
resume_text = """
Experienced software engineer with expertise in artificial intelligence, cloud technologies, and software development. 
Strong background in deep learning, automation, and distributed systems.
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
