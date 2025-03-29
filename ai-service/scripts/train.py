import os
import pandas as pd
import joblib
import torch
import numpy as np
from transformers import (
    BartTokenizer, BartForConditionalGeneration,  # 🔹 Corrección aquí (BART en vez de T5)
    BertTokenizer, BertModel
)
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.decomposition import PCA
from sklearn.metrics import accuracy_score, classification_report

# 📌 Definir rutas
CLEAN_DATA_PATH = os.path.abspath(os.path.join('data', 'Resume_clean.csv'))
MODEL_SUMMARY_PATH = os.path.abspath(os.path.join('models', 'resume_summarizer.pt'))
MODEL_CLASSIFIER_PATH = os.path.abspath(os.path.join('models', 'resume_classifier.pkl'))
BERT_MODEL_PATH = os.path.abspath(os.path.join('models', 'bert_model.pt'))

# 📌 Cargar datos limpios
df = pd.read_csv(CLEAN_DATA_PATH)

# 🔹 División de datos para clasificación
X_train, X_test, y_train, y_test = train_test_split(df['Resume_clean'], df['Category'], 
                                                    test_size=0.2, stratify=df['Category'], random_state=42)

# 🚀 1️⃣ **Modelo de resumen mejorado con BART**
print("📌 Cargando modelo de resumen BART...")
summary_model = BartForConditionalGeneration.from_pretrained("facebook/bart-large-cnn")  # ✅ Corrección aquí
summary_tokenizer = BartTokenizer.from_pretrained("facebook/bart-large-cnn")  # ✅ Corrección aquí

# Guardar modelo de resumen
os.makedirs(os.path.dirname(MODEL_SUMMARY_PATH), exist_ok=True)
torch.save(summary_model.state_dict(), MODEL_SUMMARY_PATH)
print(f"✔️ Modelo de resumen guardado en: {MODEL_SUMMARY_PATH}")

# 🚀 2️⃣ **Modelo de clasificación con BERT + RandomForest**
print("📌 Entrenando modelo de clasificación...")

# 🔹 Cargar modelo BERT y tokenizer
bert_tokenizer = BertTokenizer.from_pretrained("bert-base-uncased")
bert_model = BertModel.from_pretrained("bert-base-uncased")

# 🔹 Función para extraer embeddings de BERT
def extract_bert_embeddings(text_list, tokenizer, model):
    inputs = tokenizer(text_list, padding=True, truncation=True, return_tensors="pt", max_length=512)
    with torch.no_grad():
        outputs = model(**inputs)
    return outputs.last_hidden_state.mean(dim=1).numpy()  # Promediar todas las palabras

# 🔹 Convertir textos en embeddings
X_train_emb = np.vstack([extract_bert_embeddings([text], bert_tokenizer, bert_model) for text in X_train.tolist()])
X_test_emb = np.vstack([extract_bert_embeddings([text], bert_tokenizer, bert_model) for text in X_test.tolist()])

# 🔹 Reducir dimensiones con PCA (de 768 a 256)
pca = PCA(n_components=256)
X_train_emb = pca.fit_transform(X_train_emb)
X_test_emb = pca.transform(X_test_emb)

# 🔹 Entrenar clasificador Random Forest mejorado
classifier = RandomForestClassifier(n_estimators=500, max_depth=20, random_state=42, class_weight="balanced")
classifier.fit(X_train_emb, y_train)

# 🔹 Evaluación del modelo
y_pred = classifier.predict(X_test_emb)
accuracy = accuracy_score(y_test, y_pred)
print(f'✔️ Precisión del modelo de clasificación: {accuracy:.4f}')
print('\n📊 Reporte de clasificación:\n', classification_report(y_test, y_pred, zero_division=1))

# Guardar modelo de clasificación
joblib.dump(classifier, MODEL_CLASSIFIER_PATH)
print(f"✔️ Modelo de clasificación guardado en: {MODEL_CLASSIFIER_PATH}")

# Guardar modelo BERT
torch.save(bert_model.state_dict(), BERT_MODEL_PATH)
print(f"✔️ Modelo BERT guardado en: {BERT_MODEL_PATH}")
