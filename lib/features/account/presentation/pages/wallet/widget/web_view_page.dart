import 'package:flutter/material.dart';

import '../../../../../../core/utils/custom_text.dart';

class WebViewPage extends StatefulWidget {
  static const String routeName = '/paymentGatwayPage';
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Container(
            height: size.height,
            width: size.width,
            color: Colors.red,
            child: const MyText(text: 'Web View'),
          )
        ],
      )),
    );
  }
}
