import 'package:PocketFlow/content/components/iconCondition.dart';
import 'package:PocketFlow/content/components/search_textfield.dart';
import 'package:PocketFlow/content/editTransaction.dart';
import 'package:PocketFlow/datahandling/transactions.dart';
import 'package:PocketFlow/datahandling/users.dart';
import 'package:PocketFlow/design/colors.dart';
import 'package:PocketFlow/design/style.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

class DisplayTransactions extends StatefulWidget {
  DisplayTransactions({
    super.key,
    required this.user,
  });

  Users user;
  final value = NumberFormat("#,##0.00", "en_US");
  bool enabled = false;
  int totalIncomeData = 0;
  int totalExpenseData = 0;
  int balance = 0;

  @override
  State<DisplayTransactions> createState() => _DisplayTransactionsState();
}

class _DisplayTransactionsState extends State<DisplayTransactions> {
  TextEditingController searchControlller = TextEditingController();
  bool changed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildContent(),
    );
  }

  Widget buildContent() => Stack(
        children: [
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(250),
                  color: const Color.fromARGB(32, 71, 105, 104)),
            ),
          ),
          Positioned(
            top: 150,
            right: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(250),
                  color: const Color.fromARGB(101, 54, 93, 91)),
            ),
          ),
          Positioned(
            top: 350,
            left: 50,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(250),
                  color: const Color.fromARGB(27, 54, 93, 91)),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              appBarContent(searchControlller),
              Expanded(child: fetchTransaction()),
            ],
          ),
        ],
      );

  Widget fetchTransaction() {
    return StreamBuilder<List<Transactions>>(
      stream: readTransactions(widget.user.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong! ${snapshot.error}');
        } else if (snapshot.hasData) {
          final transactions = snapshot.data!;

          return changed == false
              ? GroupedListView(
                  padding: const EdgeInsets.only(top: 0, bottom: 45),
                  elements: transactions,
                  groupBy: (element) => DateFormat("MM-dd-yyyy")
                      .format(element.dateAdded.toDate()),
                  groupSeparatorBuilder: (String groupByValue) => Padding(
                    padding: const EdgeInsets.only(left: 20, top: 15),
                    child: Text(
                      groupByValue ==
                              DateFormat("MM-dd-yyyy").format(DateTime.now())
                          ? 'Today'
                          : groupByValue,
                      style:
                          const TextStyle(color: mainDesignColor, fontSize: 15),
                    ),
                  ),
                  itemBuilder: (context, element) {
                    return transactionContent(element);
                  },
                  order: GroupedListOrder.DESC,
                )
              : ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: ((context, index) {
                    var data = transactions[index];
                    return data.title
                            .toString()
                            .toLowerCase()
                            .contains(searchControlller.text.toLowerCase())
                        ? transactionContent(data)
                        : Container();
                  }),
                );
        } else {
          return const Center(
            child: CircularProgressIndicator(color: mainDesignColor),
          );
        }
      },
    );
  }

  appBarContent(inputController) => Container(
        padding:
            const EdgeInsets.only(top: 50, bottom: 10, left: 22, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transactions',
              style: TextStyle(
                color: mainDesignColor,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Search(
              hint: 'Type a transaction title',
              color: mainDesignColor,
              enabled: true,
              inputController: inputController,
              onChangedValue: (val) {
                setState(() {
                  if (inputController.text == '') {
                    changed = false;
                  } else {
                    changed = true;
                  }
                });
              },
            )
          ],
        ),
      );

  transactionContent(Transactions transactions) => ListTile(
        leading: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
              color: const Color.fromARGB(37, 50, 72, 83)),
          child: Center(
            child: iconCondition(transactions.category),
          ),
        ),
        title: Text(
          transactions.title,
          style: const TextStyle(
            color: mainDesignColor,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          transactions.category,
          style: const TextStyle(
            color: Color.fromARGB(255, 110, 110, 110),
            fontSize: 13,
          ),
        ),
        trailing: Padding(
          padding: const EdgeInsets.only(top: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transactions.transactionType == 'Expense'
                    ? '- ₱${widget.value.format(transactions.amount)}'
                    : '+ ₱${widget.value.format(transactions.amount)}',
                style: const TextStyle(
                  color: mainDesignColor,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
              Text(
                transactions.transactionType,
                style: const TextStyle(
                  color: Color.fromARGB(255, 110, 110, 110),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          transactionDetails(transactions);
        },
      );

  transactionDetails(Transactions transactions) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          clipBehavior: Clip.antiAlias,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(32.0),
            ),
          ),
          contentPadding: const EdgeInsets.only(top: 0.0),
          content: Container(
            width: 120,
            height: 550,
            child: Stack(
              children: [
                Positioned(
                  top: -50,
                  left: -50,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(250),
                        color: const Color.fromARGB(28, 71, 95, 105)),
                  ),
                ),
                Positioned(
                  top: 150,
                  right: -50,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(250),
                        color: const Color.fromARGB(99, 54, 81, 93)),
                  ),
                ),
                Positioned(
                  top: 250,
                  left: 50,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(250),
                        color: const Color.fromARGB(18, 71, 95, 105)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'Transaction Details',
                            style: TextStyle(
                              color: mainDesignColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListTile(
                            leading: const FaIcon(
                              FontAwesomeIcons.exchange,
                              size: 30,
                              color: mainDesignColor,
                            ),
                            title: realtimeData(
                                transactions.id, 'title', mainStyle),
                            subtitle: const Text(
                              'Title',
                              style: labelStyle,
                            ),
                            dense: true,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListTile(
                            leading: const FaIcon(
                              FontAwesomeIcons.pesoSign,
                              size: 30,
                              color: mainDesignColor,
                            ),
                            title: realtimeDataAmount(
                              transactions.id,
                              'amount',
                              const TextStyle(
                                color: mainDesignColor,
                                fontSize: 17,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            subtitle: const Text(
                              'Amount',
                              style: labelStyle,
                            ),
                            dense: true,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListTile(
                            leading: iconCondition(transactions.category),
                            title: realtimeData(
                                transactions.id, 'category', mainStyle),
                            subtitle: const Text(
                              'Category',
                              style: labelStyle,
                            ),
                            dense: true,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListTile(
                            leading: iconConditionIncome(
                                transactions.transactionType),
                            title: realtimeData(
                                transactions.id, 'transactionType', mainStyle),
                            subtitle: const Text(
                              'Transaction Type',
                              style: labelStyle,
                            ),
                            dense: true,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListTile(
                            leading: const Icon(
                              Icons.date_range_rounded,
                              size: 40,
                              color: mainDesignColor,
                            ),
                            title: realtimeDataDate(
                                transactions.id, 'transactionDate', mainStyle),
                            subtitle: const Text(
                              'Transaction Date',
                              style: labelStyle,
                            ),
                            dense: true,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListTile(
                            leading: const Icon(
                              Icons.edit_calendar_rounded,
                              size: 36,
                              color: mainDesignColor,
                            ),
                            title: realtimeDataDate(
                                transactions.id, 'dateAdded', mainStyle),
                            subtitle: const Text(
                              'Date Added',
                              style: labelStyle,
                            ),
                            dense: true,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            popUpConfirmationDelete(transactions.id);
                          },
                          child: const Text(
                            'Delete Transaction',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditTransaction(
                                            transactions: transactions,
                                            user: widget.user,
                                          )),
                                );
                              },
                              child: const Text(
                                'Edit',
                                style: TextStyle(
                                  color: mainDesignColor,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Close',
                                style: TextStyle(
                                  color: mainDesignColor,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  popUpConfirmationDelete(String id) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          clipBehavior: Clip.antiAlias,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(32.0),
            ),
          ),
          contentPadding: const EdgeInsets.only(top: 0.0),
          content: Container(
            width: 100,
            height: 200,
            child: Stack(
              children: [
                Positioned(
                  top: -50,
                  left: -50,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(250),
                        color: Color.fromARGB(98, 247, 212, 142)),
                  ),
                ),
                Positioned(
                  top: 150,
                  right: -50,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(250),
                        backgroundBlendMode: BlendMode.srcOver,
                        color: Color.fromARGB(98, 249, 220, 161)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(
                          Icons.warning_rounded,
                          color: Color.fromARGB(255, 244, 158, 54),
                          size: 50,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            "Are you sure you wan't to delete this Transaction? This process cannot be undone",
                            style: TextStyle(
                              color: mainDesignColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              onPressed: () {
                                deleteTransaction(id);
                                Navigator.pop(context);
                                alertBanner(
                                  'Success !!',
                                  "Transaction was deleted",
                                  'Success',
                                  Color.fromARGB(255, 47, 101, 114),
                                );
                              },
                              child: const Text(
                                'Yes',
                                style: TextStyle(
                                  color: mainDesignColor,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'No',
                                style: TextStyle(
                                  color: mainDesignColor,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  void alertBanner(title, message, type, color) => Flushbar(
        duration: Duration(seconds: 3),
        flushbarPosition: FlushbarPosition.TOP,
        icon: type == 'Success'
            ? Icon(Icons.check_circle_rounded, size: 60, color: Colors.white)
            : Icon(Icons.error_rounded, size: 60, color: Colors.white),
        shouldIconPulse: false,
        title: title,
        message: message,
        borderRadius: BorderRadius.circular(25),
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        backgroundColor: color,
        dismissDirection: FlushbarDismissDirection.VERTICAL,
      )..show(context);

  Stream<List<Transactions>> readTransactions(id) => FirebaseFirestore.instance
      .collection('Transactions')
      .where('userID', isEqualTo: id)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => Transactions.fromJson(
                doc.data(),
              ),
            )
            .toList(),
      );

  Widget realtimeData(id, info, style) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Transactions')
            .doc(id)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text("Loading");
          }
          var transactionDocument = snapshot.data;
          return Text(
            transactionDocument![info].toString(),
            style: style,
          );
        });
  }

  Widget realtimeDataAmount(id, info, style) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Transactions')
            .doc(id)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text("Loading");
          }
          var transactionDocument = snapshot.data;
          return Text(
              widget.value
                  .format(int.parse(transactionDocument![info].toString())),
              style: style);
        });
  }

  Widget realtimeDataDate(id, info, style) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Transactions')
            .doc(id)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text("Loading");
          }
          var transactionDocument = snapshot.data;
          return Text(
              DateFormat("MM-dd-yyyy")
                  .format(transactionDocument![info].toDate()),
              style: style);
        });
  }

  deleteTransaction(String id) async {
    final docTransaction =
        FirebaseFirestore.instance.collection('Transactions').doc(id);

    final docUser =
        FirebaseFirestore.instance.collection('Users').doc(widget.user.id);

    var amount = await docTransaction.get().then((value) {
      return value.get('amount');
    });
    var transaction = await docTransaction.get().then((value) {
      return value.get('transactionType');
    });
    var totalIncome = await docUser.get().then((value) {
      return value.get('totalIncome');
    });
    var totalExpenses = await docUser.get().then((value) {
      return value.get('totalExpense');
    });
    var balance = await docUser.get().then((value) {
      return value.get('balance');
    });

    widget.totalIncomeData =
        transaction == 'Income' ? totalIncome - amount : totalIncome;
    widget.totalExpenseData =
        transaction == 'Expense' ? totalExpenses - amount : totalExpenses;

    widget.balance =
        transaction == 'Income' ? balance - amount : balance + amount;

    docUser.update({
      'totalIncome': widget.totalIncomeData,
      'totalExpense': widget.totalExpenseData,
      'balance': widget.balance,
    });
    docTransaction.delete();
  }
}
