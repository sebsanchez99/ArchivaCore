import os
import pandas as pd

CLEAN_DATA_PATH = os.path.abspath(os.path.join('data', 'Resume_clean.csv'))

df = pd.read_csv(CLEAN_DATA_PATH)

# Mostrar las primeras filas
print("Primeras filas del dataset:")
print(df.head())

# Ver la estructura del dataset
print("\nInformación general del dataset:")
print(df.info())

# Ver cuántos valores nulos hay por columna
print("\nValores nulos en el dataset:")
print(df.isnull().sum())

# Mostrar las categorías disponibles
print("\nCategorías únicas en la columna 'Category':")
print(df["Category"].unique())