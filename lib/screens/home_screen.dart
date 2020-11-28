import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignment/model/HomeData.dart';
import 'package:flutter_assignment/panel/home_panel.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseUser _myUser;
  FirebaseAuth _auth;
  bool loading = true;

  var _dataList = List<HomeData>();

  _fetchData() async {
    http.Response response = await http
        .get('https://5f129102d5e6c90016ee50fd.mockapi.io/api/flutter/f26');

    var countryResponse = jsonDecode(response.body) as List;
    _dataList =
        countryResponse.map((tagJson) => HomeData.fromJson(tagJson)).toList();

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
    _homeDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey[800],
        title: Text("Dog's Path"),
      ),
      backgroundColor: Colors.white,
      body: loading
          ? Center(child: CupertinoActivityIndicator())
          : Container(
              decoration: BoxDecoration(color: Colors.grey[800]),
              child: ListView.builder(
                itemCount: _dataList.length,
                itemBuilder: (context, index) {
                  return HomePanel(homeData: _dataList[index]);
                },
              ),
            ),
    );
  }

  void _homeDialog(BuildContext context) async {
    _auth = FirebaseAuth.instance;
    _myUser = await _auth.currentUser();

    if (_myUser != null) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text("Alert"),
          content: Text("Signed in as ${_myUser.displayName}"),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("ok"),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }
}
