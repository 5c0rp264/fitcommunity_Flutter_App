import 'dart:convert';
import 'package:fitcommunity/weeklyRecord.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:fitcommunity/settingsPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

// ignore: must_be_immutable
class MyPlan extends StatefulWidget {
  @override
  State<MyPlan> createState() => MyPlanStateful();
}

class MyPlanStateful extends State<MyPlan> {
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  openFile(bool shouldOpenDiet, BuildContext _context) async {
    final SharedPreferences pref = await _pref;
    final token = pref.getString("token");
    Map<String, dynamic> data = jsonDecode(await http
        .read('https://fitcommunity.fr/espacemembre/json.php?token=' + token));
    final url = "https://fitcommunity.fr/dietAndProgramm/" +
        (shouldOpenDiet ? data['dietLink'] : data['programmLink']);
    print(shouldOpenDiet ? data['dietLink'] : data['programmLink']);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showDialog(
          context: _context,
          builder: (context) => AlertDialog(
                title:
                    Text('Impossible d\'accéder à la ressource pour le moment'),
              ));
      throw 'Could not launch $url';
    }
  }

  checkConnection() async {

    EasyLoading.instance.maskType = EasyLoadingMaskType.black;
    EasyLoading.show(status: "Chargement...");
    try {
      final result = await InternetAddress.lookup('example.com')
          .timeout(Duration(milliseconds: 10000));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        EasyLoading.dismiss();
      }
    } on SocketException catch (_) {
      EasyLoading.showError("Erreur, pas de connexion à internet.\n\nVeuillez relancer l'application une fois celle-ci retrouvée.",
          duration: Duration(days: 365));
    }
  }

  @override
  void initState() {
    super.initState();
    Future<String>.delayed(new Duration(milliseconds: 500), () => 'never minds what\'s here').then((String value) {
      checkConnection();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'images/logo.png',
                fit: BoxFit.cover,
                height: 55.0,
              ),
            ],
          ),
        ),
        floatingActionButton: Stack(
          children: <Widget>[
            Positioned(
              bottom: 10.0,
              right: 10.0,
              child: FloatingActionButton(
                heroTag: 'parameters',
                backgroundColor: Colors.redAccent[700],
                foregroundColor: Colors.black,
                onPressed: () async {
                  await Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => SettingsPage()));
                },
                child: Icon(Icons.settings),
              ),
            ),
            Positioned(
              bottom: 10.0,
              left: 40.0,
              child: FloatingActionButton(
                backgroundColor: Colors.redAccent[700],
                foregroundColor: Colors.black,
                heroTag: 'weeklyReport',
                onPressed: () async {
                  await Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => WeeklyRecord()));
                },
                child: Icon(Icons.save),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                OutlineButton(
                  child: Text("Diète"),
                  onPressed: () => openFile(true, context),
                  textColor: Colors.black,
                  borderSide: BorderSide(color: Colors.redAccent[700]),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                OutlineButton(
                  child: Text("Entrainements"),
                  onPressed: () => openFile(false, context),
                  textColor: Colors.black,
                  borderSide: BorderSide(color: Colors.redAccent[700]),
                )
              ],
            )
          ],
        ));
  }
}
