import 'dart:io';
import 'package:fitcommunity/popUp.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fitcommunity/regexInputFormatter.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WeeklyRecord extends StatefulWidget {
  @override
  WeeklyRecordState createState() => WeeklyRecordState();
}

class WeeklyRecordState extends State<StatefulWidget> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  File _imageF;
  File _imageB;
  File _imageL;
  File _imageR;
  double weight;
  double leg;
  double waist;
  double arm;

  Future getImage(String imageToGet, ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source);

    setState(() {
      switch (imageToGet) {
        case "f":
          _imageF = image;
          break;
        case "b":
          _imageB = image;
          break;
        case "l":
          _imageL = image;
          break;
        case "r":
          _imageR = image;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: WillPopScope(
            onWillPop: () async {
              Navigator.pop(context);
              return false;
            },
            child: new GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: Scaffold(
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
                    body: SingleChildScrollView(
                        child: Center(
                            child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            OutlineButton(
                              child: Row(
                                children: <Widget>[Text("Face"), Icon(Icons.photo)],
                              ),
                              onPressed: () => getImage("f", ImageSource.gallery),
                              textColor: Colors.black,
                              borderSide: BorderSide(color: Colors.redAccent[700]),
                            ),
                            OutlineButton(
                              child: Row(
                                children: <Widget>[Text("Face"), Icon(Icons.photo_camera)],
                              ),
                              onPressed: () => getImage("f", ImageSource.camera),
                              textColor: Colors.black,
                              borderSide: BorderSide(color: Colors.redAccent[700]),
                            ),
                            Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                            (_imageF != null)
                                ? Image.file(_imageF, height: 50, width: 50, fit: BoxFit.fitHeight)
                                : Container(
                                    child: Icon(Icons.panorama),
                                    width: 50,
                                    height: 50,
                                  ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            OutlineButton(
                              child: Row(
                                children: <Widget>[Text("Dos"), Icon(Icons.photo)],
                              ),
                              onPressed: () => getImage("b", ImageSource.gallery),
                              textColor: Colors.black,
                              borderSide: BorderSide(color: Colors.redAccent[700]),
                            ),
                            OutlineButton(
                              child: Row(
                                children: <Widget>[Text("Dos"), Icon(Icons.photo_camera)],
                              ),
                              onPressed: () => getImage("b", ImageSource.camera),
                              textColor: Colors.black,
                              borderSide: BorderSide(color: Colors.redAccent[700]),
                            ),
                            Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                            (_imageB != null)
                                ? Image.file(_imageB, height: 50, width: 50, fit: BoxFit.fitHeight)
                                : Container(
                                    child: Icon(Icons.panorama),
                                    width: 50,
                                    height: 50,
                                  ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            OutlineButton(
                              child: Row(
                                children: <Widget>[Text("Gauche"), Icon(Icons.photo)],
                              ),
                              onPressed: () => getImage("l", ImageSource.gallery),
                              textColor: Colors.black,
                              borderSide: BorderSide(color: Colors.redAccent[700]),
                            ),
                            OutlineButton(
                              child: Row(
                                children: <Widget>[Text("Gauche"), Icon(Icons.photo_camera)],
                              ),
                              onPressed: () => getImage("l", ImageSource.camera),
                              textColor: Colors.black,
                              borderSide: BorderSide(color: Colors.redAccent[700]),
                            ),
                            Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                            (_imageL != null)
                                ? Image.file(_imageL, height: 50, width: 50, fit: BoxFit.fitHeight)
                                : Container(
                                    child: Icon(Icons.panorama),
                                    width: 50,
                                    height: 50,
                                  ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            OutlineButton(
                              child: Row(
                                children: <Widget>[Text("Droite"), Icon(Icons.photo)],
                              ),
                              onPressed: () => getImage("r", ImageSource.gallery),
                              textColor: Colors.black,
                              borderSide: BorderSide(color: Colors.redAccent[700]),
                            ),
                            OutlineButton(
                              child: Row(
                                children: <Widget>[Text("Droite"), Icon(Icons.photo_camera)],
                              ),
                              onPressed: () => getImage("r", ImageSource.camera),
                              textColor: Colors.black,
                              borderSide: BorderSide(color: Colors.redAccent[700]),
                            ),
                            Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                            (_imageR != null)
                                ? Image.file(_imageR, height: 50, width: 50, fit: BoxFit.fitHeight)
                                : Container(
                                    child: Icon(Icons.panorama),
                                    width: 50,
                                    height: 50,
                                  ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Poids :"),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: TextField(
                                onChanged: (text) {
                                  weight = double.parse(text);
                                },
                                inputFormatters: [RegExInputFormatter.withRegex('^\$|^(0|([1-9][0-9]{0,}))(\\,[0-9]{0,})?\$')],
                                decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.grey, width: 0.1),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Tour de bras :"),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: TextField(
                                onChanged: (text) {
                                  arm = double.parse(text);
                                },
                                inputFormatters: [RegExInputFormatter.withRegex('^\$|^(0|([1-9][0-9]{0,}))(\\,[0-9]{0,})?\$')],
                                decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.grey, width: 0.1),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Tour de taille :"),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: TextField(
                                onChanged: (text) {
                                  waist = double.parse(text);
                                },
                                inputFormatters: [RegExInputFormatter.withRegex('^\$|^(0|([1-9][0-9]{0,}))(\\,[0-9]{0,})?\$')],
                                decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.grey, width: 0.1),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Tour de jambes :"),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: TextField(
                                onChanged: (text) {
                                  leg = double.parse(text);
                                },
                                inputFormatters: [RegExInputFormatter.withRegex('^\$|^(0|([1-9][0-9]{0,}))(\\,[0-9]{0,})?\$')],
                                decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.grey, width: 0.1),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            OutlineButton(
                                child: Text("Envoyer"),
                                onPressed: () async {
                                  print("sending all that shit");
                                  if (weight == null ||
                                      weight == 0 ||
                                      arm == null ||
                                      arm == 0 ||
                                      waist == null ||
                                      waist == 0 ||
                                      leg == null ||
                                      leg == 0 ||
                                      _imageB == null ||
                                      _imageF == null ||
                                      _imageR == null ||
                                      _imageL == null) {
                                    PopUp.show(context, _keyLoader, true, Text("Veuillez remplir tout les champs"));
                                  } else if ((await SharedPreferences.getInstance()).getString("token") == "" ||
                                      (await SharedPreferences.getInstance()).getString("token") == null) {
                                    PopUp.show(
                                        context, _keyLoader, true, Text("Veuillez rentrer votre token dans les paramètres"));
                                  } else {
                                    PopUp.showLoadingDialog(context, _keyLoader, "Envoi en cours..."); //invoking login
                                    var dio = Dio();
                                    FormData formData = FormData.fromMap({
                                      "weight": weight,
                                      "arm": arm,
                                      "waist": waist,
                                      "leg": leg,
                                      "token": (await SharedPreferences.getInstance()).getString("token"),
                                      "front": await MultipartFile.fromFile(_imageF.path, filename: "face.jpg"),
                                      "back": await MultipartFile.fromFile(_imageB.path, filename: "back.jpg"),
                                      "right": await MultipartFile.fromFile(_imageR.path, filename: "right.jpg"),
                                      "left": await MultipartFile.fromFile(_imageL.path, filename: "left.jpg")
                                    });
                                    try {
                                      Map<String, dynamic> response = jsonDecode(
                                          (await dio.post("https://fitcommunity.fr/espacemembre/json.php", data: formData))
                                              .toString());
                                      debugPrint(response.toString());
                                      Navigator.of(context, rootNavigator: true).pop();
                                      sleep(Duration(milliseconds: 500));
                                      if (response['resp'] == "Success") {
                                        PopUp.show(
                                            context,
                                            _keyLoader,
                                            true,
                                            Column(
                                              children: <Widget>[
                                                Icon(Icons.check_circle_outline, size: 50),
                                                Text("Compte-rendu envoyé",
                                                    style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
                                              ],
                                            ));
                                      } else {
                                        PopUp.show(
                                            context,
                                            _keyLoader,
                                            true,
                                            Column(
                                              children: <Widget>[
                                                Icon(Icons.clear, size: 50, color: Colors.red),
                                                Text(response['resp'].toString(),
                                                    style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
                                              ],
                                            ));
                                      }
                                    } on DioError catch (e) {
                                      PopUp.show(
                                          context,
                                          _keyLoader,
                                          true,
                                          Column(
                                            children: <Widget>[
                                              Icon(Icons.clear, size: 50, color: Colors.red),
                                              Text(
                                                  "Une erreur est survenue lors de l'envoie de votre compte-rendu.\n\nVeuillez réessayer.",
                                                  style: TextStyle(color: Colors.white),
                                                  textAlign: TextAlign.center),
                                            ],
                                          ));
                                    }

                                    //sendAllTheDataToThePreparedFile
                                  }
                                })
                          ],
                        )
                      ],
                    )))))));
  }
}
