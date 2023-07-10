import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
class RecipeView extends StatefulWidget {
  final String postUrl;

  RecipeView({required this.postUrl});

  @override
  _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  final Completer<InAppWebViewController> _controller =
      Completer<InAppWebViewController>();

  late String finalUrl;

  @override
  void initState() {
    super.initState();
    finalUrl = widget.postUrl;
    if (widget.postUrl.contains('http://')) {
      finalUrl = widget.postUrl.replaceAll("http://", "https://");
      print(finalUrl + " this is final url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.brown.shade400,
        centerTitle: true,
        title: RichText(
            text:const  TextSpan(
             style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
              children: [
                TextSpan(text: 'Foodies ',
                      style: TextStyle(color: Colors.brown),),
                TextSpan(text: 'Information',
                      style: TextStyle(color: Colors.white),),
                  ],
                ),
              ),
            ),

      body: Container(
        child: Column(
          children: [
            Expanded(
              child: InAppWebView(
                initialUrlRequest: URLRequest(url: Uri.parse(finalUrl)),
                onWebViewCreated: (InAppWebViewController controller) {
                  setState(() {
                    _controller.complete(controller);
                  });
                },
                onLoadStop: (InAppWebViewController controller, Uri? url) {
                  print(url?.toString());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}