import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RefreshableWebView extends StatefulWidget {
  final String initialUrl;

  const RefreshableWebView({super.key, required this.initialUrl});

  @override
  _RefreshableWebViewState createState() => _RefreshableWebViewState();
}

class _RefreshableWebViewState extends State<RefreshableWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.initialUrl));
  }

  Future<void> _reloadWebView() async {
    await _controller.reload();
  }

  Future<bool> _goBack(BuildContext context) async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
      return false;
    } else {
      Navigator.of(context).pop(); // Close the route if no history is available
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _goBack(context),
      child: RefreshIndicator(
        onRefresh: _reloadWebView,
        child: WebViewWidget(
          controller: _controller, // Use the shared WebViewController
        ),
      ),
    );
  }
}
