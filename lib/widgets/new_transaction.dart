import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './adaptive_flat_button.dart';

class NewTransaction extends StatefulWidget {
  final Function clickHandler;

  NewTransaction(this.clickHandler);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();

  DateTime _selectedDate;
  void submitData() {
    try {
      double am = double.parse(amountController.text);
      if (titleController.text.isEmpty || am < 0 || _selectedDate == null) {
        return;
      }
      widget.clickHandler(titleController.text, am, _selectedDate);
      Navigator.of(context).pop();
    } on FormatException {
      print("Format Exception");
    }
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((_pickedDate) {
      if (_pickedDate == null) return;
      setState(() {
        _selectedDate = _pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: titleController,
                onSubmitted: (_) {
                  submitData();
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) {
                  submitData();
                },
              ),
              Container(
                height: 60,
                child: Row(children: [
                  Expanded(
                    child: Text(_selectedDate == null
                        ? 'No Date Choosen'
                        : ' Picked Date: ${DateFormat.yMd().format(_selectedDate)}'),
                  ),
                  AdaptiveFlatButton('Choose Date', _presentDatePicker),
                ]),
              ),
              RaisedButton(
                child: Text('Add Transaction',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                textColor: Colors.purple,
                onPressed: submitData,
              )
            ],
          ),
        ),
      ),
    );
  }
}
