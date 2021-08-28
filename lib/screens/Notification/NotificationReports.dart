import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:admin/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationReports extends StatefulWidget {
  const NotificationReports({Key? key}) : super(key: key);

  @override
  _NotificationReportsState createState() => _NotificationReportsState();
}

class _NotificationReportsState extends State<NotificationReports> {
  final Stream<QuerySnapshot> users =
      FirebaseFirestore.instance.collection('WebNotifications').snapshots();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: StreamBuilder<QuerySnapshot>(
            stream: users,
            builder: (
              BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot,
            ) {
              if (snapshot.hasError) {
                return Text("SomeThing Went wrong");
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }
              final data = snapshot.requireData;
              print(data);
              return ListView.builder(
                shrinkWrap: true,
                itemCount: data.size,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        leading: data.docs[index]['type'] == "payment"
                            ? Icon(Icons.payment_outlined)
                            : Icon(Icons.festival),
                        title: Container(
                            width: 100,
                            child: Text("${data.docs[index]['title']}")),
                        subtitle: Container(
                          width: 100,
                          child: Text(
                            "${data.docs[index]['subtitle']}",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Divider(
                        height: 10,
                      )
                    ],
                  );
                },
              );
            }),
      ),
    );
  }
}
