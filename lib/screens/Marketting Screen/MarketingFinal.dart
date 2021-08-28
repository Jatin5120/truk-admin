import 'dart:html';
import 'dart:typed_data';
import "package:firebase_storage/firebase_storage.dart" as firebase_storage;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import '../../constants.dart';
import 'package:sendgrid_mailer/sendgrid_mailer.dart';

class MarketingFinal extends StatefulWidget {
  @override
  _MarketingFinalState createState() => _MarketingFinalState();
}

class _MarketingFinalState extends State<MarketingFinal> {
  List<int> to = [1, 0, 0, 0];
  List<String> state = ["All"];
  String s = "All";
  String t = "All";
  String errorText = "";
  String username = "database.trukapp@gmail.com";
  String password = "Warehouse15";
  TextEditingController msg = new TextEditingController();
  String selectedFileName = "";

  Uint8List? fileBytes;
  String fileName = "";
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < states.length; i++) {
      setState(() {
        state.add(states[i]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                  "To Filter       (By Default mail will be sent to all the members)\n")
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                  color: to[0] == 0 ? primaryColor : null,
                  onPressed: () {
                    setState(() {
                      to[0] == 0 ? to[0] = 1 : to[0] = 0;
                      to[1] = 0;
                      to[2] = 0;
                      to[3] = 0;
                    });
                  },
                  child: Text("All")),
              FlatButton(
                  color: to[1] == 0 ? primaryColor : null,
                  onPressed: () {
                    setState(() {
                      to[1] == 0 ? t = "FleetOwners" : t = "All";
                      to[1] == 0 ? to[1] = 1 : to[1] = 0;
                      to[0] = 0;
                      to[2] = 0;
                      to[3] = 0;
                    });
                  },
                  child: Text("Fleet Owners")),
              FlatButton(
                  color: to[2] == 0 ? primaryColor : null,
                  onPressed: () {
                    setState(() {
                      to[2] == 0 ? t = "RegisteredDriver" : t = "All";
                      to[2] == 0 ? to[2] = 1 : to[2] = 0;
                      to[0] = 0;
                      to[1] = 0;
                      to[3] = 0;
                    });
                  },
                  child: Text("Drivers")),
              FlatButton(
                  color: to[3] == 0 ? primaryColor : null,
                  onPressed: () {
                    setState(() {
                      to[3] == 0 ? t = "Users" : t = "All";
                      to[3] == 0 ? to[3] = 1 : to[3] = 0;
                      to[0] = 0;
                      to[1] = 0;
                      to[2] = 0;
                    });
                  },
                  child: Text("Users"))
            ],
          ),
          Row(
            children: [Text("\nSelect State\n")],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PopupMenuButton(
                itemBuilder: (BuildContext context) {
                  return List.generate(state.length, (index) {
                    return PopupMenuItem(
                      value: state[index],
                      child: Text("${state[index]}"),
                    );
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 3,
                  height: 30.0,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(s),
                    ],
                  ),
                ),
                onSelected: (value) {
                  setState(() {
                    s = value.toString();
                  });
                },
              ),
            ],
          ),
          Container(
              margin: EdgeInsets.only(top: defaultPadding),
              padding: EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                border:
                    Border.all(width: 2, color: primaryColor.withOpacity(0.15)),
                borderRadius: const BorderRadius.all(
                  Radius.circular(defaultPadding),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: msg,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  maxLines: null,
                  decoration: InputDecoration(
                      hintText: "Enter Your Message Here",
                      errorText: errorText != "" ? errorText : null),
                ),
              )),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton.icon(
              color: secondaryColor,
              onPressed: () => picFile(),
              icon: Icon(Icons.attachment),
              label: Text('Attach File (s)'),
            ),
          ),
          Text(selectedFileName),
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: FlatButton(
                color: primaryColor,
                onPressed: () async {
                  uploadfile(fileBytes!, fileName);
                  final mailer = Mailer(
                      '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');
                  final toAddress = Address('yogichoudhary351@gmail.com');
                  final fromAddress = Address('info@trukapp.com');
                  final content = Content('text/plain', msg.text);
                  final subject = 'Hey There!!';
                  final personalization = Personalization([toAddress]);
                  List<Attachment> attachment = [Attachment('kaif', 'shakeel')];
                  final email = Email([personalization], fromAddress, subject,
                      content: [content], attachments: attachment);
                  mailer.send(email).then((result) {
                    // ...
                  });
                },
                child: Text("Send")),
          ),
        ],
      ),
    );
  }

  Future picFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        fileBytes = result.files.first.bytes;
        fileName = result.files.first.name;
        selectedFileName = fileName;
      });
    }
    return null;
  }

  Future uploadfile(Uint8List fileBytes, String fileName) async {
    // Upload file
    await firebase_storage.FirebaseStorage.instance
        .ref('files/$fileName')
        .putData(fileBytes);
  }
}
