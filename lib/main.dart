import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String version = '';

  checkUpgrade() async {
    Map result = {'info': ''};
    var response =
        await Dio().get("https://www.subrecovery.top/app/upgrade.json");
    if (response.statusCode == HttpStatus.ok) {
      result = jsonDecode(response.toString());
    }
    if (result.length > 1) {
      version = result['version'];
      setState(() {});
    }
  }

  myWebSite() async {
    final Uri url = Uri.parse('https://www.subrecovery.top');
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  download() async {
    if (version.isNotEmpty) {
      Uri url =
          Uri.parse('https://www.subrecovery.top/app/app-release-$version.apk');
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('下载失败,请稍后再试'),
        duration: const Duration(seconds: 2),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    checkUpgrade();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      MediaQuery.of(context).orientation == Orientation.portrait
          ? Container(
              padding: EdgeInsets.only(top: 60),
              child: Image.asset('assets/images/S1-05-n.png',
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.cover))
          : Container(
              padding: EdgeInsets.only(top: 60),
              child: Image.asset('assets/images/S1-05-n.png',
                  width: MediaQuery.of(context).size.width, fit: BoxFit.cover)),
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? 600
                        : 300,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.0, 1.0],
                        colors: [Colors.transparent, Colors.black])),
              ),
              Column(
                children: [
                  Text('Subrecovery',
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.white.withOpacity(0.7),
                              offset: Offset(0, 0),
                              blurRadius: 10,
                            ),
                          ],
                          color: Colors.white,
                          letterSpacing: 10)),
                  Text('异次元通讯',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.white.withOpacity(0.7),
                              offset: Offset(0, 0),
                              blurRadius: 10,
                            ),
                          ],
                          color: Colors.white,
                          letterSpacing: 10)),
                  Text(version,
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      )),
                  Padding(padding: EdgeInsets.only(bottom: 30)),
                  GestureDetector(
                    onTap: () {
                      download();
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 50),
                      padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(30, 30, 30, 0.84),
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.5),
                            blurRadius: 20,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Text(
                        '游戏下载',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      Container(
        height: 60,
        alignment: Alignment.topCenter,
        color: Color.fromRGBO(30, 30, 30, 1),
        child: Row(children: [
          Padding(padding: EdgeInsets.only(left: 10)),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/images/icon.png',
              height: 40,
              width: 40,
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 10)),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('异次元通讯',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                  Text('次元复苏-秋月完美还原',
                      style: TextStyle(fontSize: 13, color: Colors.white))
                ]),
          ),
          GestureDetector(
            onTap: () {
              download();
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              decoration: BoxDecoration(
                color: Color.fromRGBO(30, 30, 30, 0.84),
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    blurRadius: 20,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Text(
                '游戏下载',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 10),
            child: IconButton(
                onPressed: () {
                  myWebSite();
                },
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 40,
                )),
          ),
          Padding(padding: EdgeInsets.only(right: 10))
        ]),
      )
    ]);
  }
}
