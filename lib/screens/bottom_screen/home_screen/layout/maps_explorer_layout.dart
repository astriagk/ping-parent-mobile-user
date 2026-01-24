import '../../../../config.dart';
import '../../../maps_explorer/maps_explorer_screen.dart';

class MapsExplorerLayout extends StatelessWidget {
  const MapsExplorerLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextWidgetCommon(
              text: "Explore Maps",
              style: AppCss.lexendMedium18
                  .textColor(appColor(context).appTheme.darkText),
            ),
            TextWidgetCommon(
              text: "View All",
              style: AppCss.lexendMedium12
                  .textColor(appColor(context).appTheme.primary),
            ).inkWell(onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MapsExplorerScreen(),
                ),
              );
            }),
          ],
        ).paddingOnly(top: Sizes.s25, bottom: Sizes.s15),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildMapCard(
                context,
                title: "OSM Maps",
                subtitle: "5 screens",
                icon: Icons.map_outlined,
                color: Colors.orange,
                badge: "Basic",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapsExplorerScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              _buildMapCard(
                context,
                title: "OpenFreeMap",
                subtitle: "5 screens",
                icon: Icons.public_outlined,
                color: Colors.green,
                badge: "Free",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapsExplorerScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              _buildMapCard(
                context,
                title: "TomTom",
                subtitle: "6 screens",
                icon: Icons.explore_outlined,
                color: Colors.blue,
                badge: "Premium",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapsExplorerScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMapCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    String? badge,
  }) {
    return Container(
      width: Sizes.s140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: appColor(context).appTheme.bgBox,
        borderRadius: BorderRadius.circular(Sizes.s12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              if (badge != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    badge,
                    style: AppCss.lexendMedium9.textColor(color),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: AppCss.lexendMedium13.textColor(
              appColor(context).appTheme.darkText,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: AppCss.lexendMedium10.textColor(
              appColor(context).appTheme.lightText,
            ),
          ),
        ],
      ),
    ).inkWell(onTap: onTap);
  }
}
