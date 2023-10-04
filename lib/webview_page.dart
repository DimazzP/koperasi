import 'package:flutter/material.dart';
import 'package:koperasi/web_link_url.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class WebviewPage extends StatefulWidget {
  const WebviewPage({super.key});

  @override
  State<WebviewPage> createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  WebViewController? _controller;
  bool printButton = false;

  Uri? _url;
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            String urlLink = WebLinkUrl.webLinkUrl;
            if (request.url.contains(urlLink + 'laporan/pinjaman-pdf/')) {
              setState(() {
                printButton = true;
                _url = Uri.parse(request.url);
              });
            } else if (request.url
                .contains(urlLink + 'laporan/simpanan-pdf/')) {
              setState(() {
                printButton = true;
                _url = Uri.parse(request.url);
              });
            } else if (request.url.contains(urlLink + 'angsuran/print/')) {
              setState(() {
                printButton = true;
                _url = Uri.parse(request.url);
              });
              setState(() {
                printButton = true;
                _url = Uri.parse(request.url);
              });
            } else {
              setState(() {
                printButton = false;
              });
            }
            if (request.url.contains(urlLink + 'laporan/pinjaman-excel/')) {
              _url = Uri.parse(request.url);
              setState(() {
                _launchInBrowser(_url!);
              });
              return NavigationDecision.prevent;
            }
            if (request.url.contains(urlLink + 'laporan/simpanan-excel/')) {
              _url = Uri.parse(request.url);
              setState(() {
                _launchInBrowser(_url!);
              });
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(WebLinkUrl.webLinkUrl));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var status = await _controller!.canGoBack();
        if (status) {
          _controller!.goBack();
          if (printButton) {
            setState(() {
              printButton = false;
            });
          }
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        body: SafeArea(child: WebViewWidget(controller: _controller!)),
        floatingActionButton: Visibility(
          visible: printButton,
          child: FloatingActionButton(
              backgroundColor: const Color(0xFF6777EF),
              onPressed: () async {
                setState(() {
                  _launchInBrowser(_url!);
                });
              },
              child: const Icon(
                Icons.print,
                color: Colors.white,
              )),
        ),
      ),
    );
  }
}
