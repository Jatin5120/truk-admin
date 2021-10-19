import 'package:admin/Helper/FirebaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:admin/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Coupons extends StatefulWidget {
  const Coupons({Key? key}) : super(key: key);

  @override
  _CouponsState createState() => _CouponsState();
}

class _CouponsState extends State<Coupons> {
  DateTime selectedTime =DateTime.now();
  String data = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());

  TextEditingController _code = new TextEditingController();
  TextEditingController _description = new TextEditingController();
  TextEditingController _discount = new TextEditingController();
  TextEditingController _expiry = new TextEditingController();
  TextEditingController _changeDate = new TextEditingController();
  TextEditingController _changeName = new TextEditingController();
  TextEditingController _min = new TextEditingController();

  TextEditingController _max = new TextEditingController();
  TextEditingController _name = new TextEditingController();
  TextEditingController _pincode = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                  child: Container(
                    width: 500,
                    height: 100,
                    child: TextFormField(
                      controller: _code,
                      enabled: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Type the code',
                        labelText: 'Code',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                  child: Container(
                    width: 500,
                    height: 100,
                    color: secondaryColor,
                    child: TextFormField(
                      controller: _description,
                      enabled: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Describe the coupon',
                        labelText: 'Description',
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
                      controller: _discount,
                      enabled: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Type the minimum Discount %',
                        labelText: 'Discount Percent',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                  child: Container(
                    width: 500,
                    height: 100,
                    child:
                    TextFormField(
                      controller: _expiry,
                      enabled: true,
                      readOnly: true,
                      onTap: ()=>_selectDate(context,null),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Select the Date',
                        labelText: 'Expiry Date',
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
                      controller: _min,
                      enabled: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter Minimum Amount',
                        labelText: 'Minimum Amount',
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
                      controller: _max,
                      enabled: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter Maximum Amount',
                        labelText: 'Maximum Amount',
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
                      controller: _name,
                      enabled: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter Your Name',
                        labelText: 'Name',
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
                      controller: _pincode,
                      enabled: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter PIN CODE',
                        labelText: 'Pin Code',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                int discount = int.parse(_discount.text);
                int min = int.parse(_min.text);
                int max = int.parse(_max.text);
                String expiry = _expiry.text;
                String str = _pincode.text;
                List<String> lstring = str.split(',');
                Iterable<int> pincodeList = lstring.map(int.parse);
                FirebaseFirestore.instance.collection("Coupons").doc().set({
                  "code": _code.text,
                  "description": _description.text,
                  "discountPercent": discount,
                  "expiry": expiry,
                  "min": min,
                  "max": max,
                  "name": _name.text,
                  "pincode": pincodeList,
                }).catchError((e) {
                  print("Error adding coupon --> ${e.toString()}");
                }).then(
                  (value) => {
                    print("success"),
                    _code.clear(),
                    _discount.clear(),
                    _description.clear(),
                    _expiry.clear(),
                    _max.clear(),
                    _min.clear(),
                    _name.clear(),
                    _pincode.clear(),
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text("Upload"),
              ),
            ),
            SizedBox(height: 50,),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection(FirebaseHelper.cuponsCollection).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if(!snapshot.hasData){
                  return Center(child: CircularProgressIndicator(),);
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final data = snapshot.data.docs[index];
                    if(snapshot.data.docs.length == 0){
                      return Card(
                        elevation: 10,
                        margin: EdgeInsets.only(bottom: 20),
                        color: tableRowColor1,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Center(
                          child: Text('No coupons history found'),
                        ),
                      );
                    }
                    return Card(
                      elevation: 10,
                      margin: EdgeInsets.only(bottom: 20),
                      color: tableRowColor1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Text('${data['name']}'),
                            Spacer(),
                            Text('Expiry Date :- ${data['expiry']}'),
                            SizedBox(width: 25,),
                            InkWell(
                                onTap: (){
                                  DateTime expiryDate = DateFormat('dd-MM-yyyy HH:mm:ss').parse(snapshot.data.docs[index]['expiry']);
                                  _changeDate.text = data['expiry'];
                                  _changeName.text = data['name'];
                                  editDate(expiryDate,data.id);
                                },
                                child: Icon(Icons.edit,size: 24,)),
                            SizedBox(width: 25,),
                            InkWell(
                                onTap: (){
                                  FirebaseFirestore.instance.collection(FirebaseHelper.cuponsCollection).doc(snapshot.data.docs[index].id).delete();
                                },
                                child: Icon(Icons.delete,size: 24,)),
                            SizedBox(width: 25,),
                          ],
                        ),
                      ),
                    );
                  },);
              },),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context,[DateTime? lastDate]) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: lastDate ?? selectedTime,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedTime)
      setState(() {
        if(lastDate != null){
          _changeDate.text = DateFormat("dd-MM-yyyy HH:mm:ss").format(picked);
        }else{
          selectedTime = picked;
          data =  DateFormat("dd-MM-yyyy HH:mm:ss").format(picked);
          _expiry.text = data;
        }
      });
  }

  editDate(DateTime expiryDate,String docId){
    return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: secondaryColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _changeName,
                enabled: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Name',
                  labelText: 'Enter Name',
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _changeDate,
                enabled: true,
                onTap: ()=>_selectDate(context,expiryDate),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Select the Date',
                  labelText: 'Expiry Date',
                ),
              ),
            ],
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
              style: OutlinedButton.styleFrom(primary: primaryColor),
            ),
            ElevatedButton(
              onPressed: () {
                print('Your date is ${_changeDate.text}');
                print('Your date is ${_changeName.text}');
                FirebaseFirestore.instance.collection(FirebaseHelper.cuponsCollection).doc(docId).update({
                  "expiry": _changeDate.text,
                  "name" : _changeName.text,
                });
                Navigator.pop(context);
              },
              child: Text("Save"),
              style: ElevatedButton.styleFrom(primary: primaryColor),
            ),
          ],
        ));
  }
}
