import 'package:admin/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController _username = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  bool _isValidate = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Truk Admin",
              style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
              child: Container(
                width: 500,
                height: 100,
                child: TextFormField(
                  controller: _username,
                  enabled: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter UserName',
                    labelText: 'UserName',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
              child: Container(
                width: 500,
                height: 100,
                child: TextFormField(
                  controller: _password,
                  enabled: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Password',
                    labelText: 'Password',
                  ),
                ),
              ),
            ),
            _isValidate
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Enter Valid Credentails..."),
                  )
                : Container(),
            ElevatedButton(
                onPressed: () {
                  if (_username.text == "admin" && _password.text == "admin") {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => MainScreen()));
                  } else {
                    setState(() {
                      _isValidate = true;
                    });
                  }
                },
                child: Text("Login")),
          ],
        ),
      ),
    );
  }
}
