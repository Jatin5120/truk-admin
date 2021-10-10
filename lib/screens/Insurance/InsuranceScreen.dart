import 'package:admin/Helper/FirebaseHelper.dart';
import 'package:admin/constants.dart';
import 'package:admin/widgets/AlertProgress.dart';
import 'package:flutter/material.dart';

class InsuranceScreen extends StatefulWidget {
  const InsuranceScreen({Key? key}) : super(key: key);

  @override
  State<InsuranceScreen> createState() => _InsuranceScreenState();
}

class _InsuranceScreenState extends State<InsuranceScreen> {
  static TextEditingController _insuranceController = TextEditingController();
  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int _insuranceType = 0;
  @override
  void initState() {
    super.initState();
    onChange(_insuranceType);
  }

  onChange(int value) async {
    try {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: ProgressAlert(
            text: 'Loading ..',
          ),
        ),
      );
      await fetchInsurance(value);
      Navigator.pop(context);
    } catch (e) {
      print(e);
      await fetchInsurance(value);
    }
  }

  fetchInsurance(int value) async {
    _insuranceType = value;
    _insuranceController.text =
        await FirebaseHelper.getInsurance(_insuranceType);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.1,
        vertical: size.height * 0.15,
      ).copyWith(bottom: size.height * 0.1),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: RadioListTile<int>(
                    value: 0,
                    groupValue: _insuranceType,
                    title: Text('Truk Company'),
                    onChanged: (value) => onChange(value!),
                  ),
                ),
                Expanded(
                  child: RadioListTile<int>(
                    value: 1,
                    groupValue: _insuranceType,
                    title: Text('Insurance Company'),
                    onChanged: (value) => onChange(value!),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),
            Text(
              'Enter Insurance',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _insuranceController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText:
                      'Enter Terms and Condition in MarkDown/HTML format for better alignment',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white38, width: 1),
                  ),
                  fillColor: selectedColor,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.05),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.02,
                    vertical: size.height * 0.02,
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate())
                    FirebaseHelper.updateInsurance(
                        _insuranceType, _insuranceController.text);
                },
                child: Text('Save Insurance'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
