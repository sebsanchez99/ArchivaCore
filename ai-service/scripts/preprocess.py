import os
import pandas as pd
import spacy
import string
import re

# 📌 Cargar modelo spaCy en inglés
nlp = spacy.load("en_core_web_sm")

# 📌 Configuración de archivos
DATA_PATH = os.path.abspath(os.path.join('data', 'Resume.csv'))
CLEAN_DATA_PATH = os.path.abspath(os.path.join('data', 'Resume_clean.csv'))

# 📌 Cargar el dataset con manejo de codificación
df = pd.read_csv(DATA_PATH, encoding="utf-8")

# 🔹 Eliminar filas con valores nulos en 'Resume_str'
df = df.dropna(subset=['Resume_str'])

# 🔹 Eliminar columna 'Resume_html' si no se usará
df = df.drop(columns=['Resume_html'], errors='ignore')

# 🔹 Rellenar valores nulos restantes en Resume_str (por seguridad)
df['Resume_str'] = df['Resume_str'].fillna('')

# 🔹 Stopwords personalizadas (evitar eliminar palabras clave)
custom_stopwords = set(nlp.Defaults.stop_words) - {"software", "data", "engineer", "developer"}

# 🔹 Función para limpiar y lematizar texto con spaCy
def clean_text(text):
    text = text.lower()
    text = re.sub(r'\d+', ' NUM ', text)  # Reemplazar números en vez de eliminarlos
    text = text.translate(str.maketrans('', '', string.punctuation))  # Eliminar puntuación
    text = re.sub(r'\s+', ' ', text).strip()  # Eliminar espacios extra

    # Procesar con spaCy
    doc = nlp(text)
    words = [token.lemma_ for token in doc if token.text.lower() not in custom_stopwords]
    
    return ' '.join(words)

# 🔹 Aplicar limpieza de texto
df['Resume_clean'] = df['Resume_str'].apply(clean_text)

# 🔹 Eliminar filas donde Resume_clean sea nulo o vacío
df = df.dropna(subset=['Resume_clean'])
df = df[df['Resume_clean'].str.strip() != '']

# 📊 Comprobación de filas eliminadas
print(f"🔍 Filas eliminadas después de limpieza: {df[df['Resume_clean'].str.strip() == ''].shape[0]}")

# 📌 Guardar el dataset limpio
os.makedirs(os.path.dirname(CLEAN_DATA_PATH), exist_ok=True)
df.to_csv(CLEAN_DATA_PATH, index=False, encoding="utf-8")

print("✅ Limpieza completada. Archivo guardado en:", CLEAN_DATA_PATH)
