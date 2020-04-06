import 'dart:convert';
import 'package:fitcommunity/popUp.dart';
import 'package:fitcommunity/weeklyRecord.dart';
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
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

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

  checkConnection(BuildContext context) async {
    PopUp.showLoadingDialog(
        context, _keyLoader, "Chargement..."); //invoking login
    try {
      final result = await InternetAddress.lookup('example.com')
          .timeout(Duration(milliseconds: 10000));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    } on SocketException catch (_) {
      Navigator.of(context, rootNavigator: true).pop();
      PopUp.show(
          context,
          _keyLoader,
          false,
          Container(
              child: Text(
                  "Erreur, pas de connexion à internet.\n\nVeullez relancer l'application une fois celle-ci retrouvée.",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center)));
    }
  }

  @override
  void initState() {
    super.initState();
    Future<String>.delayed(
            new Duration(milliseconds: 500), () => 'never minds what\'s here')
        .then((String value) {
      checkConnection(context);
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
