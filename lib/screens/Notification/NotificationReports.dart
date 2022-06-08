import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:admin/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;

// class NotificationReports extends StatefulWidget {
//   const NotificationReports({Key? key}) : super(key: key);
//
//   @override
//   _NotificationReportsState createState() => _NotificationReportsState();
// }
//
// class _NotificationReportsState extends State<NotificationReports> {
//   final Stream<QuerySnapshot> users =
//       FirebaseFirestore.instance.collection('WebNotifications').snapshots();
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Container(
//         padding: EdgeInsets.all(defaultPadding),
//         decoration: BoxDecoration(
//           color: secondaryColor,
//           borderRadius: const BorderRadius.all(Radius.circular(10)),
//         ),
//         child: StreamBuilder<QuerySnapshot>(
//             stream: users,
//             builder: (
//               BuildContext context,
//               AsyncSnapshot<QuerySnapshot> snapshot,
//             ) {
//               if (snapshot.hasError) {
//                 return Text("SomeThing Went wrong");
//               }
//
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Text("Loading");
//               }
//               final data = snapshot.requireData;
//               print(data);
//               return ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: data.size,
//                 itemBuilder: (context, index) {
//                   return Column(
//                     children: [
//                       ListTile(
//                         leading: data.docs[index]['type'] == "payment"
//                             ? Icon(Icons.payment_outlined)
//                             : Icon(Icons.festival),
//                         title: Container(
//                             width: 100,
//                             child: Text("${data.docs[index]['title']}")),
//                         subtitle: Container(
//                           width: 100,
//                           child: Text(
//                             "${data.docs[index]['subtitle']}",
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ),
//                       Divider(
//                         height: 10,
//                       )
//                     ],
//                   );
//                 },
//               );
//             }),
//       ),
//     );
//   }
// }

class NotificationSending extends StatefulWidget {
  const NotificationSending({Key? key}) : super(key: key);

  @override
  State<NotificationSending> createState() => _NotificationSendingState();
}

class _NotificationSendingState extends State<NotificationSending> {
  List<String> valueState = [];
  List<String> valueCity = [];
  List<String> _selectedstate = [];
  List<String> _selectedCity = [];

  @override
  void initState() {
    print("HELLLOW");
    getStateData();

    super.initState();
  }

  getStateData() async {
    await FirebaseFirestore.instance.collection('Country').get().then((value) {
      for (var data in value.docs) {
        setState(() {
          valueState.add(data.id);
        });
      }
    });
  }

  getCityData(String data) async {
    await FirebaseFirestore.instance
        .collection('Country')
        .doc(data)
        .get()
        .then((value) {
      for (var data in value.data()!.keys) {
        setState(() {
          valueCity.add(data);
        });
      }
    });
  }

  TextEditingController searchStateController = TextEditingController();
  TextEditingController searchCityController = TextEditingController();

  TextEditingController sendNotifiController = TextEditingController();
  TextEditingController sendNotifiBodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _selectedstate.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Selected States'),
                    Container(
                      child: Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: [
                          Container(
                            height: 50,
                            // width: 100,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: _selectedstate.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.all(10),
                                    child: Chip(
                                      label: Text(
                                        _selectedstate[index],
                                      ),
                                      onDeleted: () {
                                        setState(() {
                                          _selectedstate.removeAt(index);
                                        });
                                      },
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Container(),
          TypeAheadField(
              suggestionsBoxDecoration: SuggestionsBoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              textFieldConfiguration: TextFieldConfiguration(
                controller: searchStateController,
                decoration: InputDecoration(
                    label: Text('Select State'),
                    hintText: 'State',
                    disabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none),
              ),
              suggestionsCallback: (suggestion) async {
                return await getStateSuggestion(suggestion);
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text('$suggestion'),
                );
              },
              onSuggestionSelected: (suggestion) {
                if (!_selectedstate.contains(suggestion)) {
                  _selectedstate.add(suggestion.toString());
                }

                getCityData(suggestion.toString());
              }),
          _selectedCity.isNotEmpty
              ? Column(
                  children: [
                    Text('Selected Cities'),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: [
                        Container(
                          height: 50,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: _selectedCity.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.all(10),
                                  child: Chip(
                                    label: Text(
                                      _selectedCity[index],
                                    ),
                                    onDeleted: () {
                                      setState(() {
                                        _selectedCity.removeAt(index);
                                      });
                                    },
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ],
                )
              : Container(),
          TypeAheadField(
              suggestionsBoxDecoration: SuggestionsBoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              textFieldConfiguration: TextFieldConfiguration(
                controller: searchCityController,
                decoration: InputDecoration(
                    label: Text('Select City'),
                    hintText: 'City',
                    disabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none),
              ),
              suggestionsCallback: (suggestion) async {
                return await getCitySuggestion(suggestion);
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text('$suggestion'),
                );
              },
              onSuggestionSelected: (suggestion) {
                if (!_selectedCity.contains(suggestion)) {
                  _selectedCity.add(suggestion.toString());
                  setState(() {});
                }
                searchCityController.clear();
              }),
          Container(
            padding: EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextField(
              controller: sendNotifiController,
              enabled: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Send Notification Title',
                labelText: 'Notification Message',
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextField(
              controller: sendNotifiBodyController,
              enabled: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Send Notification Body',
                labelText: 'Notification Body Message',
              ),
            ),
          ),
          FlatButton(
            onPressed: () {
              if (_selectedCity.isNotEmpty) {
                for (var data in _selectedCity) {
                  postNotification(
                      body: sendNotifiBodyController.text,
                      title: sendNotifiController.text,
                      topic: data);
                }
              } else {
                for (var data in _selectedstate) {
                  postNotification(
                      body: sendNotifiBodyController.text,
                      title: sendNotifiController.text,
                      topic: data);
                }
              }
              searchStateController.clear();
              searchCityController.clear();
            },
            child: Text('Send'),
          )
        ],
      ),
    );
  }

  Future<List<String>> getStateSuggestion(String query) async {
    List<String> sendData = [];
    sendData.addAll(valueState);
    sendData.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return sendData;
  }

  Future<List<String>> getCitySuggestion(
    String query,
  ) async {
    List<String> sendData = [];
    sendData.addAll(valueCity);
    sendData.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return sendData;
  }
}

Future postNotification(
    {required String body,
    required String topic,
    required String title}) async {
  var headers = {
    'Authorization':
        'key=AAAAaaA9YvA:APA91bFw07bvIKyM3TOAFj5bYJyklkFj01oTeMJxdX36nyfB39Rq93sLpx2bWWuw16p58xBZMY1gehOt_kAMlwUbKjV23Q6wxfa_Q84bWDNlDtRPFd4ijZqMcX2--BZhBBDfswpw_6X2',
    'Content-Type': 'application/json'
  };
  var request =
      http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
  request.body = json.encode({
    "to": "/topics/${topic.toLowerCase()}",
    "collapse_key": "New Message",
    "notification": {"body": body, "title": "$title"},
    "data": {
      "body": "Body of Your Notification",
      "title": "Title of Your Notification"
    }
  });
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
  } else {
    print(response.reasonPhrase);
  }
}
