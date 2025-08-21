import 'package:flutter/material.dart';
import 'package:frontend/presentation/pages/resume_analizer/widgets/level_indicator.dart';
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
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Encabezado
            Row(
              children: [
                const Icon(LucideIcons.fileCheck2, color: SchemaColors.success, size: 28),
                const SizedBox(width: 10),
                Text(
                  'Análisis Completo',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: SchemaColors.success,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Resultados del análisis de la hoja de vida',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),

            /// 🔹 Resumen
            const SizedBox(height: 20),
            _sectionTitle("Resumen del perfil"),
            _sectionBox(Text(analysis.resume, style: Theme.of(context).textTheme.bodyMedium)),

            const SizedBox(height: 20),
            _sectionTitle("Resumen de compatibilidad"),
            _sectionBox(Text(analysis.resumeCompatibility, style: Theme.of(context).textTheme.bodyMedium)),

            /// 🔹 Estadísticas rápidas
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StatCard(
                  value: "${analysis.compatibility}%",
                  label: "Compatibilidad",
                  subtitle: "con el perfil",
                ),
                StatCard(
                  value: "${analysis.experience} años",
                  label: "Experiencia",
                  subtitle: "en el sector",
                ),
                StatCard(
                  value: "${analysis.skills}%",
                  label: "Habilidades",
                  subtitle: "relevantes",
                ),
              ],
            ),

            /// 🔹 Nivel
            const Divider(height: 36, thickness: 0.8),
            _sectionTitle("Nivel"),
            const SizedBox(height: 8),
            LevelIndicator(level: analysis.level),

            /// 🔹 Habilidades destacadas
            const SizedBox(height: 24),
            _sectionTitle("Habilidades destacadas"),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: analysis.outstandingSkills
                  .map((s) => SkillChip(label: s, color: SchemaColors.success))
                  .toList(),
            ),

            /// 🔹 Áreas de mejora
            const SizedBox(height: 24),
            _sectionTitle("Áreas de mejora"),
            const SizedBox(height: 12),
            ...analysis.areasOfImprovement.map(
              (area) => ImprovementItem(
                icon: LucideIcons.alertCircle,
                title: area,
                message: "Mejorar en esta área aumentará la compatibilidad.",
              ),
            ),

            /// 🔹 Matriz de evidencias
            const SizedBox(height: 24),
            _sectionTitle("Matriz de evidencias"),
            const SizedBox(height: 12),
            Column(
              children: analysis.evidenceMatrix.coincidenceSkill.map((skill) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  color: Colors.grey.shade50,
                  child: ListTile(
                    leading: const Icon(Icons.check_circle_outline, color: SchemaColors.success),
                    title: Text(skill.skill, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Categoría: ${skill.category}\nEvidencia: ${skill.evidenceCV}"),
                  ),
                );
              }).toList(),
            ),

            /// 🔹 Skills faltantes
            const SizedBox(height: 24),
            _sectionTitle("Skills faltantes"),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: analysis.evidenceMatrix.missingSkills
                  .map((s) => SkillChip(label: s, color: SchemaColors.error))
                  .toList(),
            ),

            /// 🔹 Motivo del puntaje
            const SizedBox(height: 24),
            _sectionTitle("Motivo del puntaje"),
            _sectionBox(Text(analysis.reasonScore, style: Theme.of(context).textTheme.bodyMedium)),
          ],
        ),
      ),
    );
  }

  /// 🔹 Subtítulos de secciones
  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  /// 🔹 Caja de texto destacada
  Widget _sectionBox(Widget child) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: child,
    );
  }
}
