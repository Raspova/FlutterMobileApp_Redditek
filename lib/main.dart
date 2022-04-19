import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:redditek/json_to_flutter.dart';
import 'web_view.dart';

void main() async {
  await dotenv.load(fileName: "asset/.env");
  await InAppLocalhostServer().start();
  runApp(const MyApp());
}

const Map<String, Color> pallette = {
  "LightOrange": Color(0xFFF9968B),
  "DarkBlue": Color(0xFF26474E),
  "Blue": Color(0xFF76CDCD),
  "Orange": Color(0xFFF27438),
  "LightBlue": Color(0xFF2CCED2)
};

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Redditek',
      theme: ThemeData.dark(),
      routes: {
        "/home": (context) => HomePage(),
        "/web_view": (context) => DoWebView(),
        //'/n': (context) => f(),
      },
      //initialRoute: "/",
      home: const LoginPage(),
    );
  }
}

class HomeButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function method;

  const HomeButton(
      {Key? key, required this.icon, this.text = "", required this.method})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      margin: const EdgeInsets.all(20),
      child: IconButton(
        padding: const EdgeInsets.all(1.0),
        iconSize: 70,
        icon: Icon(
          icon,
        ),
        onPressed: () {
          method();
        },
      ),
    );
  }
}

class ProfileView extends StatefulWidget {
  ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final String tok = dotenv.env['USER_TOKEN'] ?? "err";
  Future<SettingOp>? op;
  @override
  void initState() {
    print(tok);
    super.initState();
    op = updateSetting();
  }

  Future<int> pachtSetting(String key, bool value) async {
    CompletOption Cop;
    final http.Response rep = await http.get(
        Uri.parse("https://oauth.reddit.com/api/v1/me/prefs"),
        headers: <String, String>{
          'User-Agent': 'RedTek',
          'Authorization': "bearer $tok"
        });

    Cop = CompletOption.fromJson(convert.json.decode(rep.body));

    Map<String, dynamic> buffBody = Cop.toJson();
    buffBody[key] = value.toString();
    //print(buffBody[key]);
    final http.Response rep2 = await http.patch(
        Uri.parse("https://oauth.reddit.com/api/v1/me/prefs"),
        headers: <String, String>{
          'User-Agent': 'RedTek',
          'Authorization': "bearer $tok"
        },
        body: buffBody);
    print(rep2.statusCode);
    return 0;
  }

  Future<SettingOp> updateSetting() async {
    //print("pute");
    final http.Response rep = await http.get(
        Uri.parse("https://oauth.reddit.com/api/v1/me/prefs"),
        headers: <String, String>{
          'User-Agent': 'RedTek',
          'Authorization': "bearer $tok"
        });
    return SettingOp.fromJson(convert.json.decode(rep.body));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Image.asset("asset/logo.png", fit: BoxFit.cover)
            // Text("Home", style: Theme.of(context).textTheme.headline2),
            ),
        body: FutureBuilder(
            future: op,
            builder: (context, AsyncSnapshot<SettingOp> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const Text("Empty");
                default:
                  return Padding(
                    padding: const EdgeInsets.all(80),
                    child: Column(children: [
                      Container(
                        child: Row(
                          children: [
                            Text(
                              "Hides Ads",
                              style: TextStyle(fontSize: 25),
                            ),
                            Switch(
                                value: snapshot.data?.hide_ads ?? false,
                                onChanged: (bool v) async {
                                  print(v);
                                  //op?.hide_ads = v;
                                  await pachtSetting("hide_ads", v);
                                })
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Text(
                              "Over 18",
                              style: TextStyle(fontSize: 25),
                            ),
                            Switch(
                                value: snapshot.data?.over_18 ?? false,
                                onChanged: (bool) {})
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Text(
                              "Public Votes",
                              style: TextStyle(fontSize: 25),
                            ),
                            Switch(
                                value: snapshot.data?.public_votes ?? false,
                                onChanged: (bool) {})
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Text(
                              "Video Autoplay",
                              style: TextStyle(fontSize: 25),
                            ),
                            Switch(
                                value: snapshot.data?.video_autoplay ?? false,
                                onChanged: (bool) {})
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Text(
                              "Show Presence",
                              style: TextStyle(fontSize: 25),
                            ),
                            Switch(
                                value: snapshot.data?.show_presence ?? false,
                                onChanged: (bool) {})
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Text(
                              "Show Promote",
                              style: TextStyle(fontSize: 25),
                            ),
                            Switch(
                                value: snapshot.data?.show_promote ?? false,
                                onChanged: (bool) {})
                          ],
                        ),
                      )
                    ]),
                  );
              }
            }));
  }
}

class ViewPage extends StatefulWidget {
  final String rid;
  final String url;

  const ViewPage({Key? key, required this.url, required this.rid})
      : super(key: key);

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  String last = '""';
  Future<List<PageData?>>? _data;

  @override
  void initState() {
    super.initState();
    _data = getdata(widget.url, "");
  }

  Future<List<PageData?>> getdata(String _url, String _last) async {
    String tok = dotenv.env['USER_TOKEN'] ?? "err";
    Map<String, String> queryParams = {'limit': '50', 'last': _last};
    String queryString = Uri(queryParameters: queryParams).query;
    final http.Response rep = await http.get(
      Uri.parse(widget.url + '?' + queryString),
      headers: <String, String>{
        'User-Agent': 'RedTek',
        'Authorization': "bearer $tok"
      },
    );
    final body = convert.json.decode(rep.body)['data']['children'];

    final res =
        List<PageData?>.from(body.map((data) => PageData.fromJson(data)));
    // print(res[0].author);

    return res;
  }

  List<Widget> parseData(List<PageData?>? data) {
    List<Container> res = [];
    Widget buffWidget = Container();
    for (int i = 0; data != null && i < (data.length); i++) {
      if (data[i] == null) continue;
      if (data[i]?.type == "video") continue;
      if (data[i]?.type == "image") {
        buffWidget = Container(
          margin: const EdgeInsets.only(top: 30, left: 5, right: 5),
          width: 400,
          height: 400,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(data[i]?.url ??
                      "https://st2.depositphotos.com/1009634/7235/v/950/depositphotos_72350117-stock-illustration-no-user-profile-picture-hand.jpg"))),
        );
      } else if (data[i]?.selftext == "")
        continue;
      else
        buffWidget = Container();
      res.add(Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              data[i]?.title ?? "ERROR",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              textAlign: TextAlign.center,
            ),
            buffWidget,
            Expanded(
                child: Text(
              data[i]?.selftext ?? "ERROR",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              textAlign: TextAlign.center,
            )),
          ],
        ),
      ));
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.rid)
          // Text("Home", style: Theme.of(context).textTheme.headline2),
          ),
      body: Container(
          child: FutureBuilder(
              future: _data,
              builder: (context, AsyncSnapshot<List<PageData?>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return const Text("Empty");
                  case ConnectionState.done:
                    last = snapshot.data?.last?.id ?? "";

                    return PageView(
                        scrollDirection: Axis.vertical,
                        onPageChanged: (int i) {
                          if (i > (snapshot.data!.length - 1))
                            _data = getdata(widget.url, last);
                        },
                        controller:
                            PageController(initialPage: 0, viewportFraction: 1),
                        children: parseData(snapshot
                            .data)); //?? Text("Empty"); //?? Text("data")  ;
                  default:
                    return const Center(child: CircularProgressIndicator());
                }
              })),
    );
  }
}

class HomePage extends StatelessWidget {
  static const url = "https://oauth.reddit.com/";
  final String u_name = dotenv.env['USER_ID'] ?? " ";
  final String u_desc = dotenv.env['DESC'] ?? "No Descprition Such mystic";
  final String tok = dotenv.env['USER_TOKEN'] ?? "echec";

  String makeUrl(String s) {
    String buff = url;
    if (!((s == "best") || (s == "hot") || (s == "new") || (s == "top"))) {
      buff += "/r/";
    }

    return buff + s;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Image.asset("asset/logo.png", fit: BoxFit.cover)
            // Text("Home", style: Theme.of(context).textTheme.headline2),
            ),
        body: Container(
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            childAspectRatio: 1.0,
            children: [
              Container(
                margin: EdgeInsets.all(5),
                child: Column(
                  children: [
                    Expanded(
                        child: Text(
                      u_name.replaceAll('"', ""),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                      textAlign: TextAlign.center,
                    )),
                    Expanded(
                        child: Text(
                      u_desc.replaceAll('"', ""),
                      style: TextStyle(fontSize: 23),
                      textAlign: TextAlign.center,
                    )),
                  ],
                ),
              ),
              Center(
                  child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(70),
                    image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: NetworkImage(dotenv.env['ICON'] ??
                            "https://st2.depositphotos.com/1009634/7235/v/950/depositphotos_72350117-stock-illustration-no-user-profile-picture-hand.jpg"))),
              )),
              HomeButton(
                  icon: FontAwesomeIcons.grinSquintTears,
                  method: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ViewPage(
                              url: makeUrl("funny"),
                              rid: "Funny",
                            )));
                  }),
              HomeButton(
                  icon: FontAwesomeIcons.addressCard,
                  method: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ProfileView()));
                  }),
              HomeButton(
                  icon: FontAwesomeIcons.fireAlt,
                  method: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ViewPage(url: makeUrl("hot"), rid: "Hot")));
                  }),
              HomeButton(
                  icon: FontAwesomeIcons.globe,
                  method: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ViewPage(url: makeUrl("popular"), rid: "Popular")));
                  }),
              HomeButton(
                  icon: FontAwesomeIcons.grinSquintTears,
                  method: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ViewPage(
                              url: makeUrl("funny"),
                              rid: "Funny",
                            )));
                  }),
              HomeButton(
                  icon: FontAwesomeIcons.crown,
                  method: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ViewPage(
                              url: makeUrl("best"),
                              rid: "Best",
                            )));
                  }),
              TextField(
                decoration: InputDecoration(hintText: "Search"),
                onSubmitted: (String s) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ViewPage(url: makeUrl(s), rid: s)));
                },
              )
            ],
          ),
        ));
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  login() {
    Navigator.of(context).pushNamed("/web_view");
    //print(dotenv.env['USER_TOKEN']);
    //Navigator.of(context).popAndPushNamed("/home");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login", style: Theme.of(context).textTheme.headline2),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image.asset(
              "asset/logo.png",
              alignment: Alignment.topCenter,
            ),
            const Text(
              "Plese Login to continue",
              //textAlign: TextAlign.start,
            ),
            ElevatedButton.icon(
              onPressed: login,
              icon: const Icon(FontAwesomeIcons.reddit),
              label: const Text("Sing in"),
            )
          ],
        ),
      ),
    );
  }
}
