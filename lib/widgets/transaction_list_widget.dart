import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionListWidget extends StatefulWidget {
  const TransactionListWidget({
    Key key,
    @required Transaction userTransaction,
    @required Function removeTx,
  })  : _userTransaction = userTransaction,
        _removeTx = removeTx,
        super(key: key);

  final Transaction _userTransaction;
  final Function _removeTx;

  @override
  _TransactionListWidgetState createState() => _TransactionListWidgetState();
}

class _TransactionListWidgetState extends State<TransactionListWidget> {
  Color _bgColor;
  @override
  void initState() {
    const AvailableColor = [
      Colors.red,
      Colors.blue,
      Colors.purple,
      Colors.black
    ];
    _bgColor = AvailableColor[Random().nextInt(4)];
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: FittedBox(
                child: Text('\$ ${widget._userTransaction.amount.toString()}')),
          ),
        ),
        title: Text(
          widget._userTransaction.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(DateFormat.yMMMd().format(widget._userTransaction.date)),
        trailing: MediaQuery.of(context).size.width > 500
            ? FlatButton.icon(
                onPressed: () {
                  widget._removeTx(widget._userTransaction.id);
                },
                icon: Icon(Icons.delete),
                label: Text('Delete'),
                textColor: Theme.of(context).errorColor,
              )
            : IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  widget._removeTx(widget._userTransaction.id);
                },
                color: Theme.of(context).errorColor,
              ),
      ),
    );
  }
}
