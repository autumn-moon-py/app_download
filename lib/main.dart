import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, home: Scaffold(body: Home()));
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class BackgroundImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final orientation =
        MediaQuery.of(context).orientation == Orientation.portrait
            ? true
            : false;
    return Padding(
        padding: EdgeInsets.only(top: 60),
        child: Image.asset('assets/images/S1-05-n.png',
            fit: BoxFit.cover,
            height: orientation ? screenSize.height : null,
            width: orientation ? null : screenSize.width));
  }
}

class Header extends StatelessWidget {
  final String version;

  const Header({required this.version});

  TextStyle style(double size) {
    return TextStyle(
        fontSize: size,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 10,
        shadows: [
          Shadow(
              color: Colors.white.withOpacity(0.7),
              offset: Offset(0, 0),
              blurRadius: 10)
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text('Subrecovery', style: style(40)),
      Text('异次元通讯', style: style(30)),
      SizedBox(height: 20),
      Text(version, style: TextStyle(fontSize: 25, color: Colors.white)),
      SizedBox(height: 10)
    ]);
  }
}

class DownloadButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DownloadButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: Container(
            padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
            decoration: BoxDecoration(
                color: Color.fromRGBO(30, 30, 30, 0.84),
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      blurRadius: 20,
                      offset: Offset(0, 0))
                ]),
            child: Text('游戏下载',
                style: TextStyle(color: Colors.white, fontSize: 20))));
  }
}

class Top extends StatelessWidget {
  const Top({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        alignment: Alignment.topCenter,
        color: Color.fromRGBO(30, 30, 30, 1),
        child: Row(children: [
          SizedBox(width: 10),
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset('assets/images/icon.png', width: 40)),
          SizedBox(width: 10),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Text('异次元通讯',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                Text('秋月完美还原',
                    style: TextStyle(fontSize: 13, color: Colors.white))
              ])),
          Container(
              padding: EdgeInsets.only(bottom: 15),
              child: IconButton(
                  onPressed: myWebSite,
                  icon: Icon(Icons.home, color: Colors.white, size: 40))),
          SizedBox(width: 15)
        ]));
  }
}

class _HomeState extends State<Home> {
  String version = '';

  @override
  void initState() {
    super.initState();
    getVersion();
  }

  Future<void> getVersion() async {
    version = await checkUpgrade();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      BackgroundImage(),
      Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        Stack(alignment: Alignment.bottomCenter, children: [
          Container(
              height: MediaQuery.of(context).orientation == Orientation.portrait
                  ? 600
                  : 300,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0, 1.0],
                      colors: [Colors.transparent, Colors.black]))),
          Column(children: [
            Header(version: version),
            DownloadButton(onPressed: () => download(version)),
            SizedBox(height: 30)
          ])
        ])
      ]),
      Top()
    ]);
  }
}

Future<String> checkUpgrade() async {
  Map result = {'info': ''};
  var response =
      await Dio().get("https://www.subrecovery.top/app/upgrade.json");
  if (response.statusCode == HttpStatus.ok) {
    result = jsonDecode(response.toString());
  }
  return result['version'];
}

void myWebSite() async {
  final Uri url = Uri.parse('https://www.subrecovery.top');
  await launchUrl(url, mode: LaunchMode.externalApplication);
}

void download(String version) async {
  if (version.isEmpty) version = await checkUpgrade();
  Uri url =
      Uri.parse('https://www.subrecovery.top/app/app-release-$version.apk');
  await launchUrl(url, mode: LaunchMode.externalApplication);
}
