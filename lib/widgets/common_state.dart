import 'package:flutter/material.dart';

class StatefulWrapper extends StatefulWidget {
  final Function? onInit, onDispose;
  final Widget? child;
  const StatefulWrapper(
      {super.key, @required this.onInit, @required this.child, this.onDispose});

  @override
  StatefulWrapperState createState() => StatefulWrapperState();
}

class StatefulWrapperState extends State<StatefulWrapper> {
  @override
  void initState() {
    super.initState();
    if (widget.onInit != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.onInit!();
        }
      });
    }
  }

  @override
  void dispose() {
    if (widget.onDispose != null) {
      widget.onDispose!();
    }
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child!;
  }
}
