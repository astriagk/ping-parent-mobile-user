import 'package:skolo/config.dart';
import 'package:skolo/api/models/subscription_recommendations_response.dart';

class PartialCoverageSection extends StatelessWidget {
  final List<KidSummary> coveredStudents;
  final List<KidSummary> uncoveredStudents;

  const PartialCoverageSection({
    super.key,
    required this.coveredStudents,
    required this.uncoveredStudents,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = appColor(context).appTheme.success;
    final warningColor = appColor(context).appTheme.yellowIcon;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (coveredStudents.isNotEmpty) ...[
          _SectionHeader(
            icon: Icons.verified_rounded,
            label: appFonts.alreadyCoveredLabel,
            color: accentColor,
          ),
          VSpace(Sizes.s8),
          Wrap(
            spacing: Sizes.s8,
            runSpacing: Sizes.s8,
            children: coveredStudents
                .map((s) => _StudentChip(
                      name: s.studentName,
                      color: accentColor,
                    ))
                .toList(),
          ),
          VSpace(Sizes.s16),
        ],
        if (uncoveredStudents.isNotEmpty) ...[
          _SectionHeader(
            icon: Icons.person_add_rounded,
            label: appFonts.needsSubscription,
            color: warningColor,
          ),
          VSpace(Sizes.s8),
          Wrap(
            spacing: Sizes.s8,
            runSpacing: Sizes.s8,
            children: uncoveredStudents
                .map((s) => _StudentChip(
                      name: s.studentName,
                      color: warningColor,
                    ))
                .toList(),
          ),
          VSpace(Sizes.s8),
          TextWidgetCommon(
            text: appFonts.partialCoverageNote,
            style: AppCss.lexendRegular12
                .textColor(appColor(context).appTheme.lightText),
          ),
          VSpace(Sizes.s16),
        ],
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _SectionHeader({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: Sizes.s16, color: color),
        HSpace(Sizes.s6),
        TextWidgetCommon(
          text: label,
          style: AppCss.lexendSemiBold14.textColor(color),
        ),
      ],
    );
  }
}

class _StudentChip extends StatelessWidget {
  final String name;
  final Color color;

  const _StudentChip({required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Sizes.s10,
        vertical: Sizes.s5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(Sizes.s20),
        border: Border.all(color: color.withValues(alpha: 0.30)),
      ),
      child: TextWidgetCommon(
        text: name,
        style: AppCss.lexendMedium12.textColor(color),
      ),
    );
  }
}
