import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:frontend/domain/models/cv_analysis_model.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'stat_card.dart';
import 'skill_chip.dart';
import 'improvement_item.dart';

class CVAnalysisCard extends StatelessWidget {
  final CVAnalysisModel analysis;

  const CVAnalysisCard({
    super.key,
    required this.analysis,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1.2),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  'Análisis Completo',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade800,
                        fontSize: 25,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text('Resultados del análisis de la hoja de vida'),

            // Resumen del perfil
            const SizedBox(height: 16),
            _sectionTitle("Resumen del perfil"),
            Text(analysis.resume, style: const TextStyle(fontSize: 13)),

            // Resumen compatibilidad
            const SizedBox(height: 24),
            _sectionTitle("Resumen de compatibilidad"),
            Text(analysis.resumeCompatibility, style: const TextStyle(fontSize: 13)),

            // Estadísticas
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatCard(
                  value: "${analysis.compatibility}%",
                  label: "Compatibilidad",
                  subtitle: "con el perfil buscado",
                ),
                StatCard(
                  value: "${analysis.experience} años",
                  label: "Experiencia",
                  subtitle: "en el sector",
                ),
                StatCard(
                  value: "${analysis.skills}%",
                  label: "Habilidades",
                  subtitle: "habilidades relevantes",
                ),
              ],
            ),

            // Nivel
            const Divider(height: 32, thickness: 0.5, color: SchemaColors.primary),
            _sectionTitle("Nivel"),
            Text(analysis.level, style: const TextStyle(fontSize: 14)),

            // Habilidades destacadas
            const SizedBox(height: 24),
            _sectionTitle("Habilidades destacadas"),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: analysis.outstandingSkills
                  .map((s) => SkillChip(label: s, color: Colors.green))
                  .toList(),
            ),

            // Áreas de mejora
            const SizedBox(height: 20),
            _sectionTitle("Áreas de mejora"),
            const SizedBox(height: 12),
            ...analysis.areasOfImprovement.map(
              (area) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ImprovementItem(
                  icon: LucideIcons.alertCircle,
                  title: area,
                  message: "Se recomienda mejorar en esta área para aumentar la compatibilidad.",
                ),
              ),
            ),

            // Matriz de evidencias
            const SizedBox(height: 20),
            _sectionTitle("Matriz de evidencias"),
            const SizedBox(height: 12),
            Column(
              children: analysis.evidenceMatrix.coincidenceSkill.map((skill) {
                return ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: Text(skill.skill),
                  subtitle: Text(
                      "Categoría: ${skill.category}\nEvidencia: ${skill.evidenceCV}"),
                );
              }).toList(),
            ),

            // Skills faltantes
            const SizedBox(height: 20),
            _sectionTitle("Skills faltantes"),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: analysis.evidenceMatrix.missingSkills
                  .map((s) => SkillChip(label: s, color: Colors.red))
                  .toList(),
            ),

            // Motivo del puntaje
            const SizedBox(height: 20),
            _sectionTitle("Motivo del puntaje"),
            Text(analysis.reasonScore, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
    );
  }
}
