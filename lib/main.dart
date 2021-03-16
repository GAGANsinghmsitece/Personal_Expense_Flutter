import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './models/transaction.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/card.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          fontFamily: 'QuickSand',
          errorColor: Colors.red,
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(fontFamily: 'OpenSans', fontSize: 20)))),
      title: 'Personal Expense',
      home: MyHomePage(),
    );
  }
}

//1-d knapsack
//2d knapsack
//fractional knapsack
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();

  List<Transaction> get _recentTransaction {
    return _userTransaction.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _removeTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((tx) => tx.id == id);
    });
  }

  final List<Transaction> _userTransaction = [
    // Transaction(id: '1', title: 'Coffee', amount: 9.99, date: DateTime.now()),
    // Transaction(id: '2', title: 'T-shirt', amount: 99.9, date: DateTime.now())
  ];

  void _addTransaction(String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: txTitle,
        amount: txAmount,
        date: chosenDate);
    setState(() {
      _userTransaction.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext bctx) {
    showModalBottomSheet(
        context: bctx,
        builder: (ctx) {
          return NewTransaction(_addTransaction);
        });
  }

  List<Widget> _showLandscapeMode(double totalHeight, Widget txlist) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Show Chart',
            style: Theme.of(context).textTheme.headline6,
          ),
          Switch.adaptive(
              activeColor: Theme.of(context).accentColor,
              value: _showChart,
              onChanged: (value) {
                setState(() {
                  _showChart = value;
                });
              }),
        ],
      ),
      _showChart
          ? Container(
              height: totalHeight * 0.8, child: ChartView(_recentTransaction))
          : txlist
    ];
  }

  List<Widget> _showPortraitMode(double totalHeight, Widget txlist) {
    return [
      Container(
          height: totalHeight * 0.25, child: ChartView(_recentTransaction)),
      txlist,
    ];
  }

  bool _showChart = false;

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Personal Expense'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => _startAddNewTransaction(context),
                  child: Icon(CupertinoIcons.add),
                )
              ],
            ),
          )
        : AppBar(
            title: Text('Personal Expense'),
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context),
              )
            ],
          );
    final mediaQuery = MediaQuery.of(context);
    final double totalHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;
    final txlist = Container(
        height: totalHeight * 0.75,
        child: TransactionList(_userTransaction, _removeTransaction));
    bool isLandscape = mediaQuery.orientation == Orientation.landscape;
    final body = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          if (isLandscape) ..._showLandscapeMode(totalHeight, txlist),
          if (!isLandscape) ..._showPortraitMode(totalHeight, txlist),
        ],
      ),
    ));

    return Platform.isIOS
        ? CupertinoPageScaffold(navigationBar: appBar, child: body)
        : Scaffold(
            appBar: appBar,
            body: body,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
