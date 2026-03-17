import 'package:skolo/config.dart';
import 'package:skolo/api/models/subscription_recommendations_response.dart';

class PartialCoverageSection extends StatefulWidget {
  final List<KidSummary> coveredStudents;
  final List<KidSummary> uncoveredStudents;

  const PartialCoverageSection({
    super.key,
    required this.coveredStudents,
    required this.uncoveredStudents,
  });

  @override
  State<PartialCoverageSection> createState() => _PartialCoverageSectionState();
}

class _PartialCoverageSectionState extends State<PartialCoverageSection> {
  bool _isExpanded = false;

  void _toggle() => setState(() => _isExpanded = !_isExpanded);


  @override
  Widget build(BuildContext context) {
    final covered = widget.coveredStudents.length;
    final total = covered + widget.uncoveredStudents.length;
    final fraction = total > 0 ? covered / total : 0.0;
    final successColor = appColor(context).appTheme.success;
    final warningColor = appColor(context).appTheme.yellowIcon;

    return Container(
      margin: EdgeInsets.only(bottom: Sizes.s16),
      decoration: BoxDecoration(
        color: appColor(context).appTheme.white,
        borderRadius: BorderRadius.circular(Sizes.s12),
        border: Border.all(
          color: _isExpanded
              ? successColor.withValues(alpha: 0.35)
              : appColor(context).appTheme.stroke,
          width: _isExpanded ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: successColor.withValues(alpha: 0.04),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Sizes.s12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Header — always visible ──
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _toggle,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Sizes.s16, vertical: Sizes.s14),
                  child: Row(
                    children: [
                      // Icon box
                      Container(
                        width: Sizes.s34,
                        height: Sizes.s34,
                        decoration: BoxDecoration(
                          color: appColor(context)
                              .appTheme
                              .primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(Sizes.s8),
                        ),
                        child: Icon(
                          Icons.people_alt_rounded,
                          size: Sizes.s18,
                          color: appColor(context).appTheme.primary,
                        ),
                      ),
                      HSpace(Sizes.s12),
                      // Title + subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidgetCommon(
                              text: 'Student Coverage',
                              style: AppCss.lexendMedium14.textColor(
                                  appColor(context).appTheme.darkText),
                            ),
                            TextWidgetCommon(
                              text:
                                  '$covered covered · ${total - covered} need subscription',
                              fontSize: Sizes.s12,
                              color: appColor(context).appTheme.lightText,
                            ),
                          ],
                        ),
                      ),
                      // Count pill
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Sizes.s8,
                          vertical: Sizes.s3,
                        ),
                        decoration: BoxDecoration(
                          color: successColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(Sizes.s20),
                        ),
                        child: TextWidgetCommon(
                          text: '$covered/$total',
                          style:
                              AppCss.lexendMedium12.textColor(successColor),
                        ),
                      ),
                      HSpace(Sizes.s8),
                      // Chevron
                      AnimatedRotation(
                        turns: _isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 260),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: appColor(context).appTheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Expandable body ──
            AnimatedCrossFade(
              firstChild: const SizedBox(width: double.infinity),
              secondChild: _buildBody(
                context,
                covered: covered,
                total: total,
                fraction: fraction,
                successColor: successColor,
                warningColor: warningColor,
              ),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 260),
              sizeCurve: Curves.easeInOut,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context, {
    required int covered,
    required int total,
    required double fraction,
    required Color successColor,
    required Color warningColor,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(Sizes.s16, 0, Sizes.s16, Sizes.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(color: appColor(context).appTheme.stroke, height: 1),
          VSpace(Sizes.s14),

          // ── Progress bar ──
          _ProgressBar(
            fraction: fraction,
            covered: covered,
            total: total,
            successColor: successColor,
            warningColor: warningColor,
          ),
          VSpace(Sizes.s14),

          // ── Covered students card ──
          if (widget.coveredStudents.isNotEmpty) ...[
            _StudentGroupCard(
              icon: Icons.verified_rounded,
              label: appFonts.alreadyCoveredLabel,
              accentColor: successColor,
              children: widget.coveredStudents
                  .map((s) => _StudentRow(
                        student: s,
                        accentColor: successColor,
                        isCovered: true,
                      ))
                  .toList(),
            ),
            VSpace(Sizes.s10),
          ],

          // ── Needs subscription card ──
          if (widget.uncoveredStudents.isNotEmpty)
            _StudentGroupCard(
              icon: Icons.person_add_rounded,
              label: appFonts.needsSubscription,
              accentColor: warningColor,
              footerNote: appFonts.partialCoverageNote,
              children: widget.uncoveredStudents
                  .map((s) => _StudentRow(
                        student: s,
                        accentColor: warningColor,
                        isCovered: false,
                      ))
                  .toList(),
            ),
        ],
      ),
    );
  }
}

// ── Progress bar ─────────────────────────────────────────────────────────────

class _ProgressBar extends StatelessWidget {
  final double fraction;
  final int covered;
  final int total;
  final Color successColor;
  final Color warningColor;

  const _ProgressBar({
    required this.fraction,
    required this.covered,
    required this.total,
    required this.successColor,
    required this.warningColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(Sizes.s6),
          child: Stack(
            children: [
              Container(
                height: Sizes.s8,
                width: double.infinity,
                color: warningColor.withValues(alpha: 0.15),
              ),
              FractionallySizedBox(
                widthFactor: fraction,
                child: Container(
                  height: Sizes.s8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        successColor.withValues(alpha: 0.7),
                        successColor,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        VSpace(Sizes.s8),
        Row(
          children: [
            _LegendDot(color: successColor),
            HSpace(Sizes.s4),
            TextWidgetCommon(
              text: '$covered covered',
              style: AppCss.lexendRegular11
                  .textColor(appColor(context).appTheme.lightText),
            ),
            HSpace(Sizes.s14),
            _LegendDot(color: warningColor),
            HSpace(Sizes.s4),
            TextWidgetCommon(
              text: '${total - covered} need subscription',
              style: AppCss.lexendRegular11
                  .textColor(appColor(context).appTheme.lightText),
            ),
          ],
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  const _LegendDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Sizes.s8,
      height: Sizes.s8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

// ── Student group card ───────────────────────────────────────────────────────

class _StudentGroupCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color accentColor;
  final List<Widget> children;
  final String? footerNote;

  const _StudentGroupCard({
    required this.icon,
    required this.label,
    required this.accentColor,
    required this.children,
    this.footerNote,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: appColor(context).appTheme.bgBox,
        borderRadius: BorderRadius.circular(Sizes.s12),
        border: Border.all(color: accentColor.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.06),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: Sizes.s14, vertical: Sizes.s10),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Sizes.s12),
                topRight: Radius.circular(Sizes.s12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(Sizes.s6),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(Sizes.s8),
                  ),
                  child: Icon(icon, size: Sizes.s16, color: accentColor),
                ),
                HSpace(Sizes.s10),
                Expanded(
                  child: TextWidgetCommon(
                    text: label,
                    style: AppCss.lexendSemiBold14.textColor(accentColor),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Sizes.s8, vertical: Sizes.s3),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(Sizes.s20),
                  ),
                  child: TextWidgetCommon(
                    text: '${children.length}',
                    style: AppCss.lexendSemiBold12
                        .textColor(appColor(context).appTheme.white),
                  ),
                ),
              ],
            ),
          ),

          // Student rows
          Padding(
            padding: EdgeInsets.all(Sizes.s12),
            child: Column(
              children: [
                for (int i = 0; i < children.length; i++) ...[
                  children[i],
                  if (i < children.length - 1)
                    Divider(
                        color: appColor(context).appTheme.stroke,
                        height: Sizes.s20),
                ],
              ],
            ),
          ),

          // Footer note
          if (footerNote != null)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  horizontal: Sizes.s14, vertical: Sizes.s10),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.06),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(Sizes.s12),
                  bottomRight: Radius.circular(Sizes.s12),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline_rounded,
                      size: Sizes.s14,
                      color: accentColor.withValues(alpha: 0.7)),
                  HSpace(Sizes.s6),
                  Expanded(
                    child: TextWidgetCommon(
                      text: footerNote!,
                      style: AppCss.lexendRegular11.textColor(
                          appColor(context).appTheme.lightText),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ── Single student row ───────────────────────────────────────────────────────

class _StudentRow extends StatelessWidget {
  final KidSummary student;
  final Color accentColor;
  final bool isCovered;
  const _StudentRow({
    required this.student,
    required this.accentColor,
    required this.isCovered,
  });

  @override
  Widget build(BuildContext context) {
    final initial =
        student.studentName.isNotEmpty ? student.studentName[0].toUpperCase() : '?';
    final classLabel = student.section != null && student.section!.isNotEmpty
        ? 'Class ${student.studentClass} · ${student.section}'
        : 'Class ${student.studentClass}';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Avatar
        Container(
          width: Sizes.s38,
          height: Sizes.s38,
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: TextWidgetCommon(
              text: initial,
              style: AppCss.lexendSemiBold16.textColor(accentColor),
            ),
          ),
        ),
        HSpace(Sizes.s12),

        // Name + class
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidgetCommon(
                text: student.studentName,
                style: AppCss.lexendMedium14
                    .textColor(appColor(context).appTheme.darkText),
              ),
              VSpace(Sizes.s2),
              TextWidgetCommon(
                text: classLabel,
                style: AppCss.lexendRegular12
                    .textColor(appColor(context).appTheme.lightText),
              ),
            ],
          ),
        ),

        // Status badge
        Container(
          padding:
              EdgeInsets.symmetric(horizontal: Sizes.s8, vertical: Sizes.s4),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(Sizes.s20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isCovered
                    ? Icons.check_circle_rounded
                    : Icons.schedule_rounded,
                size: Sizes.s12,
                color: accentColor,
              ),
              HSpace(Sizes.s4),
              TextWidgetCommon(
                text: isCovered ? 'Covered' : 'Pending',
                style: AppCss.lexendRegular11.textColor(accentColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
