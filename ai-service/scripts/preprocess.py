import os
import pandas as pd
import string
import re
import nltk
from nltk.corpus import stopwords
from nltk.stem import WordNetLemmatizer

# Descargar recursos de NLTK si no están disponibles
nltk.download('stopwords')
nltk.download('wordnet')

# Configuración de archivos
DATA_PATH = os.path.abspath(os.path.join('data', 'Resume.csv'))
CLEAN_DATA_PATH = os.path.abspath(os.path.join('data', 'Resume_clean.csv'))

# Cargar el dataset con manejo de codificación
df = pd.read_csv(DATA_PATH, encoding="utf-8")

# Eliminar filas con valores nulos en 'Resume_str'
df = df.dropna(subset=['Resume_str'])

# Eliminar columna 'Resume_html' si no se usará
df = df.drop(columns=['Resume_html'], errors='ignore')

# Rellenar valores nulos restantes en Resume_str (por seguridad)
df['Resume_str'] = df['Resume_str'].fillna('')

# Configurar lematizador y stopwords
stop_words = set(stopwords.words('english'))
lemmatizer = WordNetLemmatizer()

def clean_text(text):
    text = text.lower()  
    text = re.sub(r'\d+', '', text)  # Eliminar números
    text = text.translate(str.maketrans('', '', string.punctuation))  # Eliminar puntuación
    text = re.sub(r'\s+', ' ', text).strip()  # Eliminar espacios extra
    words = text.split()
    words = [word for word in words if word not in stop_words]  # Eliminar stopwords
    words = [lemmatizer.lemmatize(word) for word in words]  # Lematización
    return ' '.join(words)

# Aplicar limpieza de texto
df['Resume_clean'] = df['Resume_str'].apply(clean_text)

# Eliminar filas donde Resume_clean sea nulo o vacío
df = df.dropna(subset=['Resume_clean'])
df = df[df['Resume_clean'].str.strip() != '']

# Guardar el dataset limpio
os.makedirs(os.path.dirname(CLEAN_DATA_PATH), exist_ok=True)
df.to_csv(CLEAN_DATA_PATH, index=False, encoding="utf-8")

print("Limpieza completada. Archivo guardado en:", CLEAN_DATA_PATH)

