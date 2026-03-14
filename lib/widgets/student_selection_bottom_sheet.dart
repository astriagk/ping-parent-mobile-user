import 'package:skolo/config.dart';
import 'package:skolo/api/models/subscription_recommendations_response.dart';

/// Shows a bottom sheet for selecting which students to include in a subscription.
/// [allStudents] — full list of students from parentSummary.kids
/// [coveredStudents] — students already covered by school (shown disabled/pre-checked)
/// [uncoveredStudents] — students needing subscription (pre-checked and selectable)
/// Returns selected student IDs or null if dismissed.
Future<List<String>?> showStudentSelectionBottomSheet({
  required BuildContext context,
  required List<KidSummary> allStudents,
  required List<KidSummary> coveredStudents,
  required List<KidSummary> uncoveredStudents,
}) {
  return showModalBottomSheet<List<String>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _StudentSelectionSheet(
      allStudents: allStudents,
      coveredStudents: coveredStudents,
      uncoveredStudents: uncoveredStudents,
    ),
  );
}

class _StudentSelectionSheet extends StatefulWidget {
  final List<KidSummary> allStudents;
  final List<KidSummary> coveredStudents;
  final List<KidSummary> uncoveredStudents;

  const _StudentSelectionSheet({
    required this.allStudents,
    required this.coveredStudents,
    required this.uncoveredStudents,
  });

  @override
  State<_StudentSelectionSheet> createState() => _StudentSelectionSheetState();
}

class _StudentSelectionSheetState extends State<_StudentSelectionSheet> {
  late Set<String> _selectedIds;
  late Set<String> _coveredIds;

  @override
  void initState() {
    super.initState();
    _coveredIds = widget.coveredStudents.map((s) => s.studentId).toSet();
    // Pre-select uncovered students
    _selectedIds = widget.uncoveredStudents.map((s) => s.studentId).toSet();
  }

  @override
  Widget build(BuildContext context) {
    final canContinue = _selectedIds.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: appColor(context).appTheme.bgBox,
        borderRadius: BorderRadius.vertical(top: Radius.circular(Sizes.s20)),
      ),
      padding: EdgeInsets.only(
        left: Sizes.s20,
        right: Sizes.s20,
        top: Sizes.s20,
        bottom: MediaQuery.of(context).viewInsets.bottom + Sizes.s24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: Sizes.s40,
              height: Sizes.s4,
              decoration: BoxDecoration(
                color: appColor(context).appTheme.stroke,
                borderRadius: BorderRadius.circular(Sizes.s2),
              ),
            ),
          ),
          VSpace(Sizes.s16),
          TextWidgetCommon(
            text: appFonts.selectStudents,
            style: AppCss.lexendSemiBold18
                .textColor(appColor(context).appTheme.darkText),
          ),
          VSpace(Sizes.s6),
          TextWidgetCommon(
            text: appFonts.selectStudentsDescription,
            style: AppCss.lexendRegular12
                .textColor(appColor(context).appTheme.lightText),
          ),
          VSpace(Sizes.s16),
          // Student list
          ...widget.allStudents.map((student) {
            final isCovered = _coveredIds.contains(student.studentId);
            final isSelected =
                isCovered || _selectedIds.contains(student.studentId);

            return _StudentRow(
              student: student,
              isCovered: isCovered,
              isSelected: isSelected,
              onChanged: isCovered
                  ? null
                  : (val) {
                      setState(() {
                        if (val == true) {
                          _selectedIds.add(student.studentId);
                        } else {
                          _selectedIds.remove(student.studentId);
                        }
                      });
                    },
            );
          }),
          VSpace(Sizes.s20),
          // Continue button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: canContinue
                  ? () => Navigator.of(context).pop(_selectedIds.toList())
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: appColor(context).appTheme.activeColor,
                disabledBackgroundColor:
                    appColor(context).appTheme.stroke,
                padding:
                    EdgeInsets.symmetric(vertical: Sizes.s14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Sizes.s12),
                ),
              ),
              child: TextWidgetCommon(
                text: appFonts.continueText,
                style: AppCss.lexendSemiBold16
                    .textColor(appColor(context).appTheme.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StudentRow extends StatelessWidget {
  final KidSummary student;
  final bool isCovered;
  final bool isSelected;
  final ValueChanged<bool?>? onChanged;

  const _StudentRow({
    required this.student,
    required this.isCovered,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final schoolColor = appColor(context).appTheme.success;
    final textColor = isCovered
        ? appColor(context).appTheme.lightText
        : appColor(context).appTheme.darkText;

    return Container(
      margin: EdgeInsets.only(bottom: Sizes.s10),
      padding: EdgeInsets.symmetric(
        horizontal: Sizes.s12,
        vertical: Sizes.s10,
      ),
      decoration: BoxDecoration(
        color: isCovered
            ? schoolColor.withValues(alpha: 0.06)
            : appColor(context).appTheme.bgBox,
        borderRadius: BorderRadius.circular(Sizes.s10),
        border: Border.all(
          color: isCovered
              ? schoolColor.withValues(alpha: 0.25)
              : appColor(context).appTheme.stroke,
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: isSelected,
            onChanged: onChanged,
            activeColor: isCovered
                ? schoolColor
                : appColor(context).appTheme.activeColor,
          ),
          HSpace(Sizes.s8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidgetCommon(
                  text: student.studentName,
                  style: AppCss.lexendMedium14.textColor(textColor),
                ),
                TextWidgetCommon(
                  text:
                      'Class ${student.studentClass}${student.section != null ? ' - ${student.section}' : ''}',
                  style: AppCss.lexendRegular12.textColor(
                      appColor(context).appTheme.lightText),
                ),
              ],
            ),
          ),
          if (isCovered)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: Sizes.s8,
                vertical: Sizes.s3,
              ),
              decoration: BoxDecoration(
                color: schoolColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(Sizes.s20),
              ),
              child: TextWidgetCommon(
                text: appFonts.alreadyCoveredBySchool,
                style: AppCss.lexendMedium10.textColor(schoolColor),
              ),
            ),
        ],
      ),
    );
  }
}
