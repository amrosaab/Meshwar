import 'package:flutter/material.dart';

@Deprecated('Legacy declined UI from driver app; user app uses approve flag.')
class DocumentDeclinedWidget extends StatelessWidget {
  final BuildContext cont;
  const DocumentDeclinedWidget({super.key, required this.cont});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
