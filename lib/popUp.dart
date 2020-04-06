import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PopUp {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key, String text) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  backgroundColor: Colors.black54,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                        child: Center(
                          child: Column(children: [
                            SpinKitFadingCircle(
                              color: Colors.white,
                              size: 50.0,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              text,
                              style: TextStyle(color: Colors.white),
                            )
                          ]),
                        ))
                  ]));
        });
  }

  static Future<void> show(
      BuildContext context, GlobalKey key,bool dismissable, Widget toBeShown) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: dismissable,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  backgroundColor: Colors.black54,
                  children: <Widget>[
                    Center(
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                            child: toBeShown))
                  ]));
        });
  }
}
