import os
import pandas as pd
import torch
from transformers import T5Tokenizer, T5ForConditionalGeneration

# 📌 Definir ruta del dataset
CLEAN_DATA_PATH = os.path.abspath(os.path.join('data', 'Resume_clean.csv'))
MODEL_SUMMARY_PATH = os.path.abspath(os.path.join('models', 'resume_summarizer.pt'))

# 📌 Cargar datos limpios
df = pd.read_csv(CLEAN_DATA_PATH)

# 🔹 Mostrar información general del dataset
print("📌 Primeras filas del dataset:")
print(df.head())

print("\n📊 Información general del dataset:")
print(df.info())

# 🔹 Verificar valores nulos
print("\n⚠️ Valores nulos en el dataset:")
print(df.isnull().sum())

# 🔹 Distribución de categorías
print("\n🏷️ Categorías únicas y su distribución:")
print(df["Category"].value_counts())

# 🔹 Longitud promedio de los CVs
df["Length"] = df["Resume_clean"].apply(lambda x: len(str(x).split()))
avg_length = df["Length"].mean()
print(f"\n📏 Longitud promedio de los CVs: {avg_length:.2f} palabras")

# 🔹 Identificar CVs problemáticos
print("\n⚠️ CVs con menos de 20 palabras (posible problema):")
print(df[df["Length"] < 20][["Resume_clean", "Category"]])

# 🚀 Cargar modelo de resumen para inspección
print("\n🔍 Generando resúmenes de muestra...")
summary_model = T5ForConditionalGeneration.from_pretrained("t5-small")
summary_model.load_state_dict(torch.load(MODEL_SUMMARY_PATH))
summary_model.eval()
summary_tokenizer = T5Tokenizer.from_pretrained("t5-small")

# 🔹 Función para generar resumen
def summarize_resume(text):
    input_text = "summarize: " + text
    inputs = summary_tokenizer(input_text, return_tensors="pt", truncation=True, padding=True, max_length=512)
    summary_ids = summary_model.generate(inputs.input_ids, max_length=100, min_length=30, length_penalty=2.0, num_beams=4, early_stopping=True)
    return summary_tokenizer.decode(summary_ids[0], skip_special_tokens=True)

# 🔹 Mostrar algunos resúmenes de prueba
sample_resumes = df["Resume_clean"].sample(3, random_state=42)
for i, resume in enumerate(sample_resumes):
    summary = summarize_resume(resume)
    print(f"\n📜 Resumen {i+1}:\n{summary}\n")
