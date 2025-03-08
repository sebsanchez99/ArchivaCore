import os
import pandas as pd
import joblib
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.naive_bayes import MultinomialNB
from sklearn.pipeline import Pipeline
from sklearn.metrics import accuracy_score, classification_report

# Rutas
CLEAN_DATA_PATH = os.path.abspath(os.path.join('data', 'Resume_clean.csv'))
MODEL_PATH = os.path.abspath(os.path.join('models', 'resume_classifier.pkl'))

# Cargar datos limpios
df = pd.read_csv(CLEAN_DATA_PATH)

# Dividir en entrenamiento y prueba
X_train, X_test, y_train, y_test = train_test_split(df['Resume_str'], df['Category'], test_size=0.2, random_state=42)

# Crear pipeline de entrenamiento
pipeline = Pipeline([
    ('tfidf', TfidfVectorizer(max_features=5000)),
    ('classifier', MultinomialNB())
])

# Entrenar modelo
pipeline.fit(X_train, y_train)

# Evaluar modelo
y_pred = pipeline.predict(X_test)
accuracy = accuracy_score(y_test, y_pred)
print(f'✔️ Precisión del modelo: {accuracy:.4f}')

# Guardar modelo
os.makedirs(os.path.dirname(MODEL_PATH), exist_ok=True)
joblib.dump(pipeline, MODEL_PATH)
print(f'✔️ Modelo guardado en: {MODEL_PATH}')

# Mostrar reporte de clasificación
print('\nReporte de clasificación: \n', classification_report(y_test, y_pred))
