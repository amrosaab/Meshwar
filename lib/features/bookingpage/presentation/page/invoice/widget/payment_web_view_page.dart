import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewPage extends StatefulWidget {
  final String paymentUrl;

  const PaymentWebViewPage({
    super.key,
    required this.paymentUrl,
  });

  @override
  State<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late final WebViewController controller;
  bool _isCompleted = false; //  prevent multiple pops

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: _handleUrl,
          onPageFinished: _handleUrl,
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  void _handleUrl(String url) {
    debugPrint('STRIPE URL 👉 $url');

    if (_isCompleted) return;

    ///  STRIPE SUCCESS
    if (url.contains('stripe-checkout-success')) {
      _isCompleted = true;
      Navigator.pop(context, true);
    }

    ///  STRIPE FAILURE / CANCEL (optional)
    if (url.contains('stripe-checkout-cancel') ||
        url.contains('payment-failed')) {
      _isCompleted = true;
      Navigator.pop(context, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: WebViewWidget(controller: controller),
    );
  }
}
