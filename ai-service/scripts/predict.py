import os
import joblib
import torch
from transformers import T5Tokenizer, T5ForConditionalGeneration
from sentence_transformers import SentenceTransformer, util

# 📁 Rutas
MODEL_CLASSIFIER_PATH = os.path.abspath(os.path.join('models', 'resume_classifier.pkl'))
MODEL_SUMMARIZER_PATH = os.path.abspath(os.path.join('models', 'resume_summarizer.pt'))

# 📌 Cargar modelos
print("📦 Cargando modelos...")
pipeline = joblib.load(MODEL_CLASSIFIER_PATH)
classifier = pipeline.named_steps['classifier']

# 🔹 Cargar modelo T5 y tokenizer
tokenizer = T5Tokenizer.from_pretrained("t5-small")
model = T5ForConditionalGeneration.from_pretrained("t5-small")
model.load_state_dict(torch.load(MODEL_SUMMARIZER_PATH, map_location=torch.device('cpu')))
model.eval()

# 🔹 Cargar modelo de embeddings semánticos
semantic_model = SentenceTransformer('all-MiniLM-L6-v2')

# 🧠 Función para generar resumen
def summarize_resume(resume_text, max_length=100):
    input_text = "summarize: " + resume_text
    inputs = tokenizer.encode(input_text, return_tensors="pt", max_length=512, truncation=True)
    summary_ids = model.generate(inputs, max_length=max_length, min_length=20, length_penalty=2.0, num_beams=4, early_stopping=True)
    return tokenizer.decode(summary_ids[0], skip_special_tokens=True)

# 🎯 Evaluar similitud semántica con oferta
def evaluate_fit_semantically(resume_summary, job_description):
    emb_resume = semantic_model.encode(resume_summary, convert_to_tensor=True)
    emb_offer = semantic_model.encode(job_description, convert_to_tensor=True)
    similarity = util.pytorch_cos_sim(emb_resume, emb_offer).item()
    return similarity

# 🧾 Explicación basada en similitud
def explain_fit(score, threshold=0.65):
    if score >= threshold:
        return f"👍 El perfil es adecuado para la oferta (similaridad: {score:.2f})."
    else:
        return f"👎 El perfil no es muy adecuado para la oferta (similaridad: {score:.2f})."

# 📤 Función principal
def analyze_resume(resume_text: str, job_offer: str):
    print("\n🚀 Analizando currículum...\n")

    # 🔸 Generar resumen
    summary = summarize_resume(resume_text)
    print("📄 Resumen del currículum:\n", summary)

    # 🔸 Clasificar categoría
    category = pipeline.predict([resume_text])[0]
    print("\n🏷️ Categoría del currículum:", category)

    # 🔸 Evaluar ajuste semántico
    similarity_score = evaluate_fit_semantically(summary, job_offer)
    explanation = explain_fit(similarity_score)
    print("\n📈 Evaluación de idoneidad:\n", explanation)

    # 🧾 Retornar todo junto si se quiere usar desde una interfaz
    return {
        "summary": summary,
        "category": category,
        "fit_score": similarity_score,
        "fit_explanation": explanation
    }

# 🔍 Prueba rápida (puedes cambiar estos textos)
if __name__ == "__main__":
    example_resume = """
    Experienced Machine Learning Engineer with 5+ years in developing and deploying ML models in production. Skilled in Python, TensorFlow, PyTorch, and cloud services like AWS. Successfully led multiple projects in the e-commerce and recommendation system space.
    """
    job_offer = "We are seeking a Machine Learning Engineer with experience in deploying real-time recommendation systems using reinforcement learning techniques. The ideal candidate is proficient in PyTorch, Kubernetes, and has a deep understanding of neural networks, scalability, and model interpretability in e-commerce platforms."

    analyze_resume(example_resume, job_offer)
