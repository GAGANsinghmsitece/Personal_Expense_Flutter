import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import './transaction_list_widget.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _userTransaction;
  final Function _removeTx;

  TransactionList(this._userTransaction, this._removeTx);

  @override
  Widget build(BuildContext context) {
    return _userTransaction.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: [
                Text(
                  'There is no transaction',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: 20,
                  width: double.infinity,
                ),
                Container(
                  height: constraints.maxHeight * 0.8,
                  child: Image.asset(
                    'assets/image/waiting.png',
                    fit: BoxFit.cover,
                  ),
                )
              ],
            );
          })
        : ListView(
            children: [
              ..._userTransaction.map((tx) {
                return TransactionListWidget(
                    key: ValueKey(tx.id),
                    userTransaction: tx,
                    removeTx: _removeTx);
              })
            ],
          );
  }
}
