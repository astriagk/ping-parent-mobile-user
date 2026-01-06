import '../../../config.dart';

class CustomTimePicker extends StatelessWidget {
  final String title;
  final Function(int) onScroll;
  final CarouselSliderController carouselController;
  final List<String> itemList;

  const CustomTimePicker(
      {super.key,
      required this.title,
      required this.onScroll,
      required this.carouselController,
      required this.itemList});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
            height: Insets.i100,
            width: Insets.i60,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                      onTap: () {},
                      child: Icon(Icons.arrow_drop_up_outlined,
                          size: Sizes.s24, color: Color(0xff797D83))),
                  SizedBox(
                      width: Sizes.s65,
                      child: CarouselSlider.builder(
                          carouselController: carouselController,
                          itemCount: itemList.length,
                          itemBuilder: (context, index, realIndex) {
                            return TextWidgetCommon(
                                    text: itemList[index],
                                    style: AppCss.lexendMedium22.textColor(
                                        appColor(context).appTheme.primary))
                                .center();
                          },
                          options: CarouselOptions(
                              onPageChanged: (index, reason) => onScroll(index),
                              autoPlay: false,
                              scrollDirection: Axis.vertical))),
                  InkWell(
                      child: Icon(Icons.arrow_drop_down_outlined,
                          size: Sizes.s24, color: Color(0xff797D83)))
                ]))
        .boxShapeExtension(
            borderColor: Color(0xffF3F4F6),
            context: context,
            color: appColor(context).appTheme.white);
  }
}
