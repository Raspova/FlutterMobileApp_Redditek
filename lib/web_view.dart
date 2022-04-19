import 'dart:convert' as convert;
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'json_to_flutter.dart';

final client_id = 'o992SmelZVBYJhhaNn50eA';
final redirect_uri = 'http://localhost:8080';
final scope =
    'identity edit flair history modconfig modflair modlog modposts modwiki mysubreddits privatemessages read report save submit subscribe vote wikiedit wikiread';
final oathString =
    'https://www.reddit.com/api/v1/authorize.compact?client_id=$client_id&response_type=code&state=placeholder&redirect_uri=$redirect_uri&duration=permanent&scope=$scope';

class DoWebView extends StatefulWidget {
  const DoWebView({Key? key}) : super(key: key);

  @override
  _DoWebView createState() => _DoWebView();
}

class _DoWebView extends State<DoWebView> {
  // ignore: unused_field
  late InAppWebViewController _webViewController;
  String url = "";
  String userToken = '';
  double progress = 0;
  String? accessToken = '';
  String refreshToken = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Redditech WebView"),
        ),
        body: Container(
            child: InAppWebView(
                initialUrlRequest: URLRequest(url: Uri.parse(oathString)),
                initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions()),
                onWebViewCreated: (InAppWebViewController controller) {
                  _webViewController = controller;
                },
                onUpdateVisitedHistory: (controller, url, refreshed) {
                  setState(() {
                    this.url = url.toString();
                  });
                },
                onLoadStop: (controller, url) async {
                  if (this.url.toString().contains('localhost')) {
                    var queryRes = url?.queryParameters;
                    String? requestCode = queryRes?["code"];
                    Uri urlToken =
                        Uri.parse('https://www.reddit.com/api/v1/access_token');
                    if (requestCode?.contains("#_") == true) {
                      requestCode =
                          requestCode?.substring(0, requestCode.length - 2);
                    }
                    print(requestCode);
                    final http.Response response = await http.post(urlToken,
                        headers: <String, String>{
                          'Authorization': 'Basic ' +
                              convert.base64Encode(
                                  convert.utf8.encode('$client_id:')),
                          'Content-Type': 'application/x-www-form-urlencoded'
                        },
                        body:
                            "grant_type=authorization_code&code=$requestCode&redirect_uri=http://localhost:8080");
                    print(response.statusCode);
                    if (response.statusCode == 200) {
                      final responsedecoded = convert.jsonDecode(
                          convert.utf8.decode(response.bodyBytes)) as Map;
                      userToken = responsedecoded["access_token"];
                      refreshToken = responsedecoded["refresh_token"];
                      dotenv.env['USER_TOKEN'] = userToken;
                      dotenv.env['REFRESH_TOKEN'] = refreshToken;
                      final http.Response rep2 = await http.get(
                        Uri.parse("https://oauth.reddit.com/api/v1/me"),
                        headers: <String, String>{
                          'User-Agent': 'RedTek',
                          'Authorization': "bearer $userToken"
                        },
                      );
                      UserInfo user_info =
                          UserInfo.fromJson(convert.jsonDecode(rep2.body));
                      dotenv.env['USER_ID'] = user_info.name ?? "No_name";
                      dotenv.env['DESC'] =
                          user_info.description ?? "No Descprition";
                      dotenv.env['ICON'] = user_info.icon ?? "No icon url";
                      dotenv.env['BANNER'] =
                          user_info.banner ?? "No banner url";
                    }
                    Navigator.of(context).pop();
                    Navigator.of(context).popAndPushNamed("/home");
                  }
                })));
  }
}
