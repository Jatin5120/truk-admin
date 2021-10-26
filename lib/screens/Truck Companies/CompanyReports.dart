import 'package:admin/Helper/DownloadHelper.dart';
import 'package:admin/models/FleetModel.dart';
import 'package:admin/screens/Truck%20Companies/CreateFleet.dart';
import 'package:admin/screens/Truck%20Companies/ViewFleet.dart';
import 'package:admin/widgets/AlertProgress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../responsive.dart';

class CompanyReport extends StatefulWidget {
  final List<FleetOwners> fleetOwners;

  const CompanyReport({required this.fleetOwners});

  @override
  _CompanyReportState createState() => _CompanyReportState();
}

class _CompanyReportState extends State<CompanyReport> {
  List<String> an = [];
  bool isLoading = true;
  int totalPages = 0;
  int totalBookings = 0;
  List<int> pages = [];
  int currPage = 1;
  String percentage = '0';
  int iCount = 10;
  List<double> totalRevenues = [];
  List<double> codRevenues = [];
  List<double> onlineRevenues = [];
  List<List<CommissionHistory>> commissionHistories = [];
  List<double> commissionReceived = [];
  List<double> commissionPending = [];
  List<double> paymentDues = [];

  static const List<String> _tableHeader = [
    'S. No.',
    'Name',
    'Company Name',
    'Email',
    'Contact',
    'Total revenue',
    'Total COD',
    'Total Online',
    'Change Commission',
    'Commission History',
    'Commission Received',
    'Commission Dues',
    'Payment Dues',
    'Clear The Dues'
  ];

  getData() async {
    setState(() {
      totalBookings = widget.fleetOwners.length;
      String s =
          "${((totalBookings / iCount) * iCount == totalBookings ? (totalBookings / iCount) : (totalBookings / iCount) + 1)}";
      int p = int.parse(s.split(".")[0]);
      totalPages = p * iCount == totalBookings ? p : p + 1;
    });

    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("Shipment").get();

    for (int i = 0; i < widget.fleetOwners.length; i++) {
      List<CommissionHistory> histories = [];
      String uid = widget.fleetOwners[i].uid;
      double amount = 0;
      double codAmount = 0;
      double onlineAmount = 0;
      double cPending = 0;
      double cReceived = 0;
      double cDuesPayment = 0;

      for (QueryDocumentSnapshot doc in snapshot.docs) {
        double price = double.parse(doc['price']);
        double commission = double.parse(doc['commission']);
        double ammount = commission * price / 100;
        if (doc['agent'] == uid) {
          CommissionHistory history = CommissionHistory(
            commission: commission,
            price: price,
            amount: commission * price / 100,
          );
          amount += price;
          if (doc['paymentStatus'] == 'COD') {
            codAmount += price;
            if (doc['isPaymentPending'])
              cPending += ammount;
            else
              cReceived += amount;
          } else {
            onlineAmount += price;
            cReceived += ammount;
            if (!doc['isPaymentPending'] && doc['isDue'])
              cDuesPayment += (price - ammount);
          }

          histories.add(history);
        }
      }

      commissionHistories.add(histories);

      totalRevenues.add(amount);
      commissionReceived.add(cReceived);
      commissionPending.add(cPending);
      codRevenues.add(codAmount);
      onlineRevenues.add(onlineAmount);
      paymentDues.add(cDuesPayment);

      setState(() {
        pages.add(i + 1);
        percentage =
            (((i + 1) / widget.fleetOwners.length) * 100).toStringAsFixed(2);
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16.0),
                Text(
                  "$percentage % done\nFetching Data Please Wait .  .  .",
                  textAlign: TextAlign.center,
                )
              ],
            ),
          )
        : Container(
            padding: EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Fleet Owners",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Download()
                              .downloadFleets(context, widget.fleetOwners);
                        },
                        icon: Icon(Icons.download),
                        label: Text("Download"),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Responsive.isDesktop(context)
                              ? showDialog(
                                  context: context,
                                  builder: (_) => CreateFleet(),
                                )
                              : Navigator.of(context).push(
                                  new MaterialPageRoute<Null>(
                                    builder: (BuildContext context) {
                                      return new CreateFleet();
                                    },
                                    fullscreenDialog: true,
                                  ),
                                );
                        },
                        icon: Icon(Icons.add),
                        label: Text("Add Fleet"),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: defaultPadding,
                    columns: [
                      for (int i = 0; i < _tableHeader.length; i++) ...[
                        DataColumn(
                          label: Text(_tableHeader[i]),
                        ),
                      ],
                    ],
                    rows: List.generate(
                      widget.fleetOwners
                          .sublist(
                              (currPage * iCount) - iCount,
                              currPage * iCount <= widget.fleetOwners.length - 1
                                  ? currPage * iCount
                                  : widget.fleetOwners.length)
                          .length,
                      (index) => recentFileDataRow(
                        context: context,
                        owner: widget.fleetOwners.sublist(
                          (currPage * iCount) - iCount,
                          currPage * iCount <= widget.fleetOwners.length - 1
                              ? currPage * iCount
                              : widget.fleetOwners.length,
                        )[index],
                        totalRevenue: totalRevenues.sublist(
                          (currPage * iCount) - iCount,
                          currPage * iCount <= widget.fleetOwners.length - 1
                              ? currPage * iCount
                              : widget.fleetOwners.length,
                        )[index],
                        codRevenue: codRevenues.sublist(
                          (currPage * iCount) - iCount,
                          currPage * iCount <= widget.fleetOwners.length - 1
                              ? currPage * iCount
                              : widget.fleetOwners.length,
                        )[index],
                        onlineRevenue: onlineRevenues.sublist(
                          (currPage * iCount) - iCount,
                          currPage * iCount <= widget.fleetOwners.length - 1
                              ? currPage * iCount
                              : widget.fleetOwners.length,
                        )[index],
                        histories: commissionHistories.sublist(
                          (currPage * iCount) - iCount,
                          currPage * iCount <= widget.fleetOwners.length - 1
                              ? currPage * iCount
                              : widget.fleetOwners.length,
                        )[index],
                        commissionPending: commissionPending.sublist(
                          (currPage * iCount) - iCount,
                          currPage * iCount <= widget.fleetOwners.length - 1
                              ? currPage * iCount
                              : widget.fleetOwners.length,
                        )[index],
                        commissionReceived: commissionReceived.sublist(
                          (currPage * iCount) - iCount,
                          currPage * iCount <= widget.fleetOwners.length - 1
                              ? currPage * iCount
                              : widget.fleetOwners.length,
                        )[index],
                        duesPayment: paymentDues.sublist(
                          (currPage * iCount) - iCount,
                          currPage * iCount <= widget.fleetOwners.length - 1
                              ? currPage * iCount
                              : widget.fleetOwners.length,
                        )[index],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0).copyWith(top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Rows Per Page: "),
                      Text("$iCount "),
                      PopupMenuButton(
                        itemBuilder: (BuildContext context) {
                          return List.generate(pages.length, (index) {
                            return PopupMenuItem(
                              value: pages[index],
                              child: Text("${pages[index]}"),
                            );
                          });
                        },
                        child: Icon(
                          Icons.arrow_drop_up,
                          size: 15.0,
                          color: Colors.white,
                        ),
                        onSelected: (value) {
                          setState(() {
                            currPage = 1;
                            iCount = int.parse(value.toString());
                            String s =
                                "${((totalBookings / iCount) * iCount == totalBookings ? (totalBookings / iCount) : (totalBookings / iCount) + 1)}";
                            int p = int.parse(s.split(".")[0]);
                            totalPages =
                                p * iCount == totalBookings ? p : p + 1;
                          });
                        },
                      ),
                      Text("Page: $currPage of $totalPages "),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (currPage != 1) {
                              currPage -= 1;
                            }
                          });
                        },
                        icon: Icon(Icons.arrow_back_ios),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (currPage != totalPages) {
                              currPage += 1;
                            }
                          });
                        },
                        icon: Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
  }
}

_onTap(FleetOwners fileInfo, context) {
  Responsive.isDesktop(context)
      ? showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            backgroundColor: secondaryColor,
            content: ViewFleets(bm: fileInfo),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Close"),
                style: ElevatedButton.styleFrom(
                  primary: primaryColor,
                ),
              ),
            ],
          ),
        )
      : Navigator.of(context).push(
          new MaterialPageRoute<Null>(
            builder: (BuildContext context) {
              return new ViewFleets(bm: fileInfo);
            },
            fullscreenDialog: true,
          ),
        );
}

recentFileDataRow({
  required BuildContext context,
  required FleetOwners owner,
  required double totalRevenue,
  required double codRevenue,
  required double onlineRevenue,
  required double commissionPending,
  required double commissionReceived,
  required double duesPayment,
  required List<CommissionHistory> histories,
}) {
  return DataRow(
    cells: [
      DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text("${owner.sNo}"),
        ),
        onTap: () {
          _onTap(owner, context);
        },
      ),
      DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(owner.name),
        ),
        onTap: () {
          _onTap(owner, context);
        },
      ),
      DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(owner.company),
        ),
        onTap: () {
          _onTap(owner, context);
        },
      ),
      DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(owner.email),
        ),
        onTap: () {
          _onTap(owner, context);
        },
      ),
      DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(owner.mobile),
        ),
        onTap: () {
          _onTap(owner, context);
        },
      ),
      DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(totalRevenue.toString()),
        ),
        onTap: () {
          _onTap(owner, context);
        },
      ),
      DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(codRevenue.toString()),
        ),
        onTap: () {
          _onTap(owner, context);
        },
      ),
      DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(onlineRevenue.toString()),
        ),
        onTap: () {
          _onTap(owner, context);
        },
      ),
      DataCell(
        _CommissionField(owner),
      ),
      DataCell(
        OutlinedButton(
          child: Text(
            'Show History',
            style: TextStyle(color: Colors.blue),
          ),
          onPressed: () {
            _showHistory(
              context: context,
              name: owner.name,
              histories: histories,
            );
          },
        ),
      ),
      DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(commissionReceived.toString()),
        ),
        onTap: () {
          _onTap(owner, context);
        },
      ),
      DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(commissionPending.toString()),
        ),
        onTap: () {
          _onTap(owner, context);
        },
      ),
      DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(duesPayment.toString()),
        ),
        onTap: () {
          _onTap(owner, context);
        },
      ),
      DataCell(
        ElevatedButton(
          child: Text(
            'Clear Dues',
          ),
          onPressed: () async {
            QuerySnapshot snapshot =
                await FirebaseFirestore.instance.collection("Shipment").get();
            for (QueryDocumentSnapshot doc in snapshot.docs) {
              if (doc['agent'] == owner.uid) {
                if (doc['isPaymentPending']) {
                  FirebaseFirestore.instance
                      .collection('Shipment')
                      .doc(doc.id)
                      .update(
                    {'isPaymentPending': false, 'isDue': false},
                  );
                }
              }
            }
            _CompanyReportState().getData();
          },
        ),
      ),
    ],
  );
}

class CommissionHistory {
  final double commission;
  final double price;
  final double amount;

  const CommissionHistory({
    required this.commission,
    required this.price,
    required this.amount,
  });
}

Future<void> _showHistory({
  required BuildContext context,
  required String name,
  required List<CommissionHistory> histories,
}) async {
  final Size size = MediaQuery.of(context).size;

  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      backgroundColor: secondaryColor,
      title: Text(name),
      content: SizedBox(
        height: size.height * 0.5,
        width: size.width * 0.2,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: histories
              .map(
                (CommissionHistory history) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 12.0),
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: tableRowColor2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${history.commission} % of Rs. ${history.price}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white54,
                              height: 2,
                            ),
                          ),
                          Text('Commission: Rs. ${history.amount}'),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Total Amount',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white54,
                              height: 2,
                            ),
                          ),
                          Text(
                            'Rs. ${history.price}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Close"),
          style: ElevatedButton.styleFrom(
            primary: primaryColor,
          ),
        ),
      ],
    ),
  );
}

class _CommissionField extends StatelessWidget {
  _CommissionField(
    this.owner, {
    Key? key,
  })  : _commissionController = TextEditingController(
          text: owner.commission.toString(),
        ),
        _commissionValue = owner.commission,
        super(key: key);

  final FleetOwners owner;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _commissionController;

  String _commissionValue;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 200),
      child: Form(
        key: _formKey,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: TextFormField(
                  controller: _commissionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Can't be empty";
                    if (double.tryParse(value) == null)
                      return "Enter a valid number";
                    if (value == owner.commission || value == _commissionValue)
                      return "Enter new value to update";
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.redAccent),
                    ),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  String commission = _commissionController.text;
                  showDialog(
                    context: context,
                    builder: (_) {
                      print("Dialog");
                      return AlertDialog(
                        content: ProgressAlert(text: 'Updating . . .'),
                      );
                    },
                  );
                  await FirebaseFirestore.instance
                      .collection('FleetOwners')
                      .doc(owner.uid)
                      .update({'commission': commission});
                  _commissionValue = commission;
                  Navigator.pop(context);
                }
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
