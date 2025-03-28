import os
import pandas as pd
import joblib
import torch
from transformers import (
    T5Tokenizer, T5ForConditionalGeneration, 
    BertTokenizer, BertModel
)
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, classification_report

# 📌 Definir rutas
CLEAN_DATA_PATH = os.path.abspath(os.path.join('data', 'Resume_clean.csv'))
MODEL_SUMMARY_PATH = os.path.abspath(os.path.join('models', 'resume_summarizer.pt'))
MODEL_CLASSIFIER_PATH = os.path.abspath(os.path.join('models', 'resume_classifier.pkl'))
BERT_MODEL_PATH = os.path.abspath(os.path.join('models', 'bert_model.pt'))

# 📌 Cargar datos limpios
df = pd.read_csv(CLEAN_DATA_PATH)

# 🔹 División de datos para clasificación
X_train, X_test, y_train, y_test = train_test_split(df['Resume_clean'], df['Category'], test_size=0.2, random_state=42)

# 🚀 1️⃣ Modelo de resumen con T5/BART (NO necesita entrenamiento)
print("Cargando modelo de resumen...")
summary_model = T5ForConditionalGeneration.from_pretrained("t5-small")
summary_tokenizer = T5Tokenizer.from_pretrained("t5-small")

# Guardar modelo de resumen (Torch)
os.makedirs(os.path.dirname(MODEL_SUMMARY_PATH), exist_ok=True)
torch.save(summary_model.state_dict(), MODEL_SUMMARY_PATH)
print(f"✔️ Modelo de resumen guardado en: {MODEL_SUMMARY_PATH}")

# 🚀 2️⃣ Modelo de clasificación con BERT + RandomForest
print("Entrenando modelo de clasificación...")
bert_tokenizer = BertTokenizer.from_pretrained("bert-base-uncased")
bert_model = BertModel.from_pretrained("bert-base-uncased")

# 🔹 Extraer embeddings de BERT
def extract_bert_embeddings(text_list, tokenizer, model):
    inputs = tokenizer(text_list, padding=True, truncation=True, return_tensors="pt")
    with torch.no_grad():
        outputs = model(**inputs)
    return outputs.last_hidden_state[:, 0, :].numpy()  # Solo el embedding [CLS]

# 🔹 Convertir textos en embeddings
X_train_emb = extract_bert_embeddings(X_train.tolist(), bert_tokenizer, bert_model)
X_test_emb = extract_bert_embeddings(X_test.tolist(), bert_tokenizer, bert_model)

# 🔹 Entrenar clasificador Random Forest
classifier = RandomForestClassifier(n_estimators=100, random_state=42)
classifier.fit(X_train_emb, y_train)

# 🔹 Evaluación del modelo
y_pred = classifier.predict(X_test_emb)
accuracy = accuracy_score(y_test, y_pred)
print(f'✔️ Precisión del modelo de clasificación: {accuracy:.4f}')
print('\nReporte de clasificación:\n', classification_report(y_test, y_pred))

# Guardar modelo de clasificación
joblib.dump(classifier, MODEL_CLASSIFIER_PATH)
print(f"✔️ Modelo de clasificación guardado en: {MODEL_CLASSIFIER_PATH}")

# Guardar modelo BERT (necesario para extracción de embeddings en producción)
torch.save(bert_model.state_dict(), BERT_MODEL_PATH)
print(f"✔️ Modelo BERT guardado en: {BERT_MODEL_PATH}")