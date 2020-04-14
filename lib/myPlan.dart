import 'dart:convert';
import 'package:after_layout/after_layout.dart';
import 'package:fitcommunity/popUp.dart';
import 'package:fitcommunity/weeklyRecord.dart';
//import 'package:flutter/scheduler.dart' hide Priority;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

class MyPlanStateful extends State<MyPlan> with AfterLayoutMixin<MyPlan>{
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  Future<void> checkToken(BuildContext context) async {
    final SharedPreferences pref = await _pref;
    final token = (pref.getString("token") ?? "");
    if (token == "") {
      PopUp.show(
          context,
          _keyLoader,
          true,
          Container(
              child: Text("Veuillez renter votre token dans les paramètres de l'application.",
                  style: TextStyle(color: Colors.white), textAlign: TextAlign.center)));
    }
  }

  initNotifications() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid = new AndroidInitializationSettings('@mipmap/launcher_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    final notifplugin = new FlutterLocalNotificationsPlugin();
    notifplugin.initialize(initializationSettings, onSelectNotification: onSelectNotificationFunc);

    var time = Time(9, 30, 0);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'channelIdFitCommunity', 'FitCommunityFrance', 'Rappel d\'envoie de compte-rendu',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await notifplugin.showWeeklyAtDayAndTime(
      0,
      'Rappel',
      'N\'oublie pas de faire ton compte-rendu !',
      Day.Sunday,
      time,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  Future onSelectNotificationFunc(String payload) async {
    await Navigator.push(context, new MaterialPageRoute(builder: (context) => WeeklyRecord()));
  }

  openFile(bool shouldOpenDiet, BuildContext _context) async {
    final SharedPreferences pref = await _pref;
    final token = pref.getString("token");
    Map<String, dynamic> data = jsonDecode(await http.read('https://fitcommunity.fr/espacemembre/json.php?token=' + token));
    final url = "https://fitcommunity.fr/dietAndProgramm/" + (shouldOpenDiet ? data['dietLink'] : data['programmLink']);
    print(shouldOpenDiet ? data['dietLink'] : data['programmLink']);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showDialog(
          context: _context,
          builder: (context) => AlertDialog(
                title: Text('Impossible d\'accéder à la ressource pour le moment'),
              ));
      throw 'Could not launch $url';
    }
  }

  /*Future<void> checkConnection(BuildContext context) async {
    PopUp.showLoadingDialog(context, _keyLoader, "Chargement..."); //invoking login
    Future.delayed(Duration(milliseconds: 1000));
    try {
      final result = await InternetAddress.lookup('example.com').timeout(Duration(milliseconds: 10000));
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
              child: Text("Erreur, pas de connexion à internet.\n\nVeullez relancer l'application une fois celle-ci retrouvée.",
                  style: TextStyle(color: Colors.white), textAlign: TextAlign.center)));
    }
  }*/

  @override
  void initState() {
    super.initState();
    initNotifications();
    /*SchedulerBinding.instance.addPostFrameCallback((_) {
      //Future<String>.delayed(new Duration(milliseconds: 0), () => 'never minds what\'s here').then((String value) {
        checkConnection(context);
        /*setState(() {});
      });*/
      checkToken(context);
    });*/

  }

  @override
  void afterFirstLayout(BuildContext context) {
    // Calling the same function "after layout" to resolve the issue.
    //Future.delayed(Duration(milliseconds: 1000));
    //checkConnection(context);
    //Future.delayed(Duration(milliseconds: 100));
    checkToken(context);
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
                  await Navigator.push(context, new MaterialPageRoute(builder: (context) => SettingsPage()));
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
                  await Navigator.push(context, new MaterialPageRoute(builder: (context) => WeeklyRecord()));
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
