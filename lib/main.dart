import 'package:flutter/material.dart';
import 'package:hotels/src/home.dart';
import 'package:hotels/src/services.dart';

void main()  => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hotels app',
        theme: new ThemeData(primaryColor: Colors.pinkAccent),
        home: new FutureBuilder(
            future: Services.fetchPost(),
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (!snapshot.hasData) {
                if (snapshot.hasError) {
                  return Scaffold(
                      body: new Center(
                    child: Center(
                        child: Text("Impossible to fetch hotels data",
                            style:
                                TextStyle(fontSize: 24, color: Colors.grey))),
                  ));
                } else {
                  return new Center(
                    child: new CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
                    ),
                  );
                }
              }

              List hotels = snapshot.data;
              return Home(hotels);
            }));
  }
}
