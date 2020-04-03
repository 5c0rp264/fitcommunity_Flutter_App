import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _popNavigationWithResult(context, 'changed');
        return false;
      },
      child: SettingsPageStateful(),
    );
  }

  void _popNavigationWithResult(BuildContext context, dynamic result) {
    Navigator.pop(context, result);
  }
}

class SettingsPageStateful extends StatefulWidget {
  @override
  LoadToken createState() => LoadToken();
}

class LoadToken extends State<SettingsPageStateful> {
  var tokenTextController = TextEditingController();
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  updateToken(String text) async {
    final SharedPreferences pref = await _pref;
    pref.setString("token", text);
  }

  @override
  void initState() {
    super.initState();
    getToken();
  }

  Future<Null> getToken() async {
    final SharedPreferences pref = await _pref;
    setState(() {
      tokenTextController.text = pref.getString("token");
      print("retrived :");
      print(pref.getString("token"));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
    child:Scaffold(
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
      body: new SingleChildScrollView(
          child: Center(
              child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.2, 0, 0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Votre token :', style: TextStyle(fontSize: 30.0)),
                ],
              ),
              Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                      "(Vous pouvez le trouver dans votre espace sur fitcommunity.fr)",
                      style: TextStyle(fontSize: 10.0))
                ],
              ),
              Padding(padding: EdgeInsets.all(10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: TextField(
                      controller: tokenTextController,
                      onChanged: (text) => updateToken(text),
                      decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 0.1),
                          ),
                          hintText: 'Example : 5c3e593d21f56e3e...'),
                    ),
                  )
                ],
              ),
            ]),
      ))),
    ));
  }
}
