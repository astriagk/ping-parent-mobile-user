import '../../../../config.dart';

class SplashLayout extends StatelessWidget {
  const SplashLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
          child:
              Text(appFonts.taxify).decorated(color: const Color(0xff5465FF)))
    ])));
  }
}
