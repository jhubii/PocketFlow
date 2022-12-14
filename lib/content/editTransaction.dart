import 'package:PocketFlow/content/components/rounded_button.dart';
import 'package:PocketFlow/datahandling/transactions.dart';
import 'package:PocketFlow/datahandling/users.dart';
import 'package:PocketFlow/design/colors.dart';
import 'package:PocketFlow/content/components/rounded_input.dart';
import 'package:PocketFlow/design/style.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class EditTransaction extends StatefulWidget {
  EditTransaction({
    super.key,
    required this.transactions,
    required this.user,
  });

  Transactions transactions;
  Users user;
  double oldtotalIncomeData = 0;
  double oldtotalExpenseData = 0;
  double oldbalance = 0;
  double totalIncomeData = 0;
  double totalExpenseData = 0;
  double balance = 0;
  double oldcat1 = 0;
  double oldcat2 = 0;
  double oldcat3 = 0;
  double oldcat4 = 0;
  double oldcat5 = 0;
  double newcat1 = 0;
  double newcat2 = 0;
  double newcat3 = 0;
  double newcat4 = 0;
  double newcat5 = 0;
  final value = NumberFormat("#,##0.00", "en_US");

  @override
  State<EditTransaction> createState() => _EditTransactionState();
}

class _EditTransactionState extends State<EditTransaction> {
  late DateTime now = widget.transactions.dateAdded.toDate();
  late DateTime transactionDate = widget.transactions.transactionDate.toDate();
  late TextEditingController titlecontroller;
  late TextEditingController amountcontroller;
  late String error;
  late String category;
  late String transaction;

  @override
  void initState() {
    super.initState();
    titlecontroller = TextEditingController(text: widget.transactions.title);
    amountcontroller =
        TextEditingController(text: widget.transactions.amount.toString());
    category = widget.transactions.category;
    transaction = widget.transactions.transactionType;
    error = "";
  }

  @override
  void dispose() {
    titlecontroller.dispose();
    amountcontroller.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              backButtonClicked(widget.transactions.id);
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              size: 21,
              color: mainDesignColor,
            ),
          ),
          title: const Text(
            'Edit Transaction',
            style: TextStyle(
              fontSize: 17,
              color: mainDesignColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.2,
        ),
        body: buildContent(),
      ),
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
          transactionForm(),
        ],
      );

  transactionForm() => ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Transaction :',
                  style: labelTransactionStyle,
                ),
                const SizedBox(
                  height: 10,
                ),
                _radioButtons(),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Description :',
                  style: labelTransactionStyle,
                ),
                RoundedInput(
                  hint: 'Write your description here',
                  color: mainDesignColor,
                  formvalue: 'Enter Description',
                  inputController: titlecontroller,
                  enabled: true,
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Category :',
                  style: labelTransactionStyle,
                ),
                const SizedBox(
                  height: 10,
                ),
                _radioButtonsCategory(),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    const Text(
                      'Amount : ',
                      style: labelTransactionStyle,
                    ),
                    const Text(
                      '( Your Balance: ',
                      style: TextStyle(
                        color: Color.fromARGB(255, 117, 117, 117),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: const [
                            SizedBox(
                              height: 5,
                            ),
                            FaIcon(
                              FontAwesomeIcons.pesoSign,
                              color: mainDesignColor,
                              size: 14,
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        realtimeDataBalance(
                          widget.user.id,
                          'balance',
                          const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: mainDesignColor,
                          ),
                        ),
                        const Text(
                          ' )',
                          style: TextStyle(
                            color: Color.fromARGB(255, 117, 117, 117),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                RoundedInput(
                  hint: 'Write the amount here',
                  color: mainDesignColor,
                  formvalue: 'Enter amount',
                  inputController: amountcontroller,
                  enabled: true,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Date : ',
                          style: labelTransactionStyle,
                        ),
                        Text(
                          DateFormat("MM-dd-yyyy").format(transactionDate),
                          style: const TextStyle(
                            color: Color.fromARGB(255, 117, 117, 117),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () async {
                        DateTime? newDate = await showDatePicker(
                          context: context,
                          initialDate: now,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );

                        if (newDate == null) return;

                        setState(() {
                          transactionDate = newDate;
                        });
                      },
                      child: const Text(
                        'Change Date',
                        style: TextStyle(
                          color: mainDesignColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                RoundedButton(
                  title: 'Save Changes',
                  color: mainDesignColor,
                  textColor: whiteDesignColor,
                  onTapEvent: () {
                    errorHandling();
                  },
                ),
              ],
            ),
          ),
        ],
      );

  _radioButtons() => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: textFieldColor.withAlpha(40),
          borderRadius: BorderRadius.circular(35),
        ),
        child: Column(
          children: [
            RadioListTile(
              title: const Text(
                "Income",
                style: categoryStyle,
              ),
              value: "Income",
              activeColor: mainDesignColor,
              groupValue: transaction,
              onChanged: (value) {
                setState(() {
                  transaction = value.toString();
                });
              },
            ),
            RadioListTile(
              title: const Text(
                "Expense",
                style: categoryStyle,
              ),
              value: "Expense",
              activeColor: mainDesignColor,
              groupValue: transaction,
              onChanged: (value) {
                setState(() {
                  transaction = value.toString();
                });
              },
            ),
          ],
        ),
      );

  _radioButtonsCategory() => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: textFieldColor.withAlpha(40),
          borderRadius: BorderRadius.circular(35),
        ),
        child: Column(
          children: [
            RadioListTile(
              title: const Text(
                "Entertainment",
                style: categoryStyle,
              ),
              value: "Entertainment",
              activeColor: mainDesignColor,
              groupValue: category,
              onChanged: (value) {
                setState(() {
                  category = value.toString();
                });
              },
            ),
            RadioListTile(
              title: const Text(
                "Social & Lifestyle",
                style: categoryStyle,
              ),
              value: "Social & Lifestyle",
              activeColor: mainDesignColor,
              groupValue: category,
              onChanged: (value) {
                setState(() {
                  category = value.toString();
                });
              },
            ),
            RadioListTile(
              title: const Text(
                "Beauty & Health",
                style: categoryStyle,
              ),
              value: "Beauty & Health",
              activeColor: mainDesignColor,
              groupValue: category,
              onChanged: (value) {
                setState(() {
                  category = value.toString();
                });
              },
            ),
            RadioListTile(
              title: const Text(
                "Work & Education",
                style: categoryStyle,
              ),
              value: "Work & Education",
              activeColor: mainDesignColor,
              groupValue: category,
              onChanged: (value) {
                setState(() {
                  category = value.toString();
                });
              },
            ),
            RadioListTile(
              title: const Text(
                "Others",
                style: categoryStyle,
              ),
              value: "Others",
              activeColor: mainDesignColor,
              groupValue: category,
              onChanged: (value) {
                setState(() {
                  category = value.toString();
                });
              },
            ),
          ],
        ),
      );

  popUpConfirmation() => showDialog(
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
                  top: -10,
                  left: -10,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(250),
                        color: const Color.fromARGB(98, 249, 220, 161)),
                  ),
                ),
                Positioned(
                  top: 50,
                  right: -20,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(250),
                        color: const Color.fromARGB(98, 249, 220, 161)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Center(
                          child: FaIcon(
                        FontAwesomeIcons.circleQuestion,
                        color: Color.fromARGB(255, 244, 158, 54),
                        size: 50,
                      )),
                      const Text(
                        "Are you sure you wan't to update this transaction?",
                        style: TextStyle(
                          color: mainDesignColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            onPressed: () {
                              updateTransaction();
                              Navigator.pop(context);
                              Navigator.pop(context);
                              alertBanner(
                                'Success !!',
                                "Transaction was successfully updated",
                                'Success',
                                const Color.fromARGB(255, 47, 101, 114),
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
              ],
            ),
          ),
        ),
      );

  backButtonClicked(String id) async {
    final docTransaction =
        FirebaseFirestore.instance.collection('Transactions').doc(id);
    final docUser =
        FirebaseFirestore.instance.collection('Users').doc(widget.user.id);
    var transactionType = await docTransaction.get().then((value) {
      return value.get('transactionType');
    });
    var balance = await docUser.get().then((value) {
      return value.get('balance');
    });
    var amount = await docTransaction.get().then((value) {
      return value.get('amount');
    });

    var cat1 = await docUser.get().then((value) {
      return value.get('cat1');
    });
    var cat2 = await docUser.get().then((value) {
      return value.get('cat2');
    });
    var cat3 = await docUser.get().then((value) {
      return value.get('cat3');
    });
    var cat4 = await docUser.get().then((value) {
      return value.get('cat4');
    });
    var cat5 = await docUser.get().then((value) {
      return value.get('cat5');
    });

    if (category == 'Entertainment') {
      var oldcat1 = cat1 + amount;
      docUser.update({
        'cat1': oldcat1,
      });
    } else if (category == 'Social & Lifestyle') {
      var oldcat2 = cat2 + amount;
      docUser.update({
        'cat2': oldcat2,
      });
    } else if (category == 'Beauty & Health') {
      var oldcat3 = cat3 + amount;
      docUser.update({
        'cat3': oldcat3,
      });
    } else if (category == 'Work & Education') {
      var oldcat4 = cat4 + amount;
      docUser.update({
        'cat4': oldcat4,
      });
    } else if (category == 'Others') {
      var oldcat5 = cat5 + amount;
      docUser.update({
        'cat5': oldcat5,
      });
    }

    if (transactionType == 'Income') {
      var oldbalance = balance + amount;
      docUser.update({
        'balance': oldbalance,
      });
    } else {
      var oldbalance = balance - amount;
      docUser.update({
        'balance': oldbalance,
      });
    }
  }

  errorHandling() {
    if (transaction == '') {
      alertBanner(
        'Error !!',
        'A type of transaction should be selected',
        'Error',
        const Color.fromARGB(255, 157, 37, 37),
      );
    } else if (titlecontroller.text == '') {
      alertBanner(
        'Error !!',
        "Title can't be empty",
        'Error',
        const Color.fromARGB(255, 157, 37, 37),
      );
    } else if (category == '') {
      alertBanner(
        'Error !!',
        "A category should be selected",
        'Error',
        const Color.fromARGB(255, 157, 37, 37),
      );
    } else if (amountcontroller.text == '') {
      alertBanner(
        'Error !!',
        "Amount can't be empty",
        'Error',
        const Color.fromARGB(255, 157, 37, 37),
      );
    } else if (double.tryParse(amountcontroller.text) == null) {
      alertBanner(
        'Invalid Input !!',
        "Amount should be a number",
        'Error',
        const Color.fromARGB(255, 157, 37, 37),
      );
    } else {
      editTransaction();
    }
  }

  void alertBanner(title, message, type, color) => Flushbar(
        duration: const Duration(seconds: 3),
        flushbarPosition: FlushbarPosition.TOP,
        icon: type == 'Success'
            ? const Icon(Icons.check_circle_rounded,
                size: 60, color: Colors.white)
            : const Icon(Icons.error_rounded, size: 60, color: Colors.white),
        shouldIconPulse: false,
        title: title,
        message: message,
        borderRadius: BorderRadius.circular(25),
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        backgroundColor: color,
        dismissDirection: FlushbarDismissDirection.VERTICAL,
      )..show(context);

  Widget realtimeDataBalance(id, info, style) {
    return StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('Users').doc(id).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text("Loading");
          }
          var transactionDocument = snapshot.data;
          return Text(
              widget.value
                  .format(double.parse(transactionDocument![info].toString())),
              style: style);
        });
  }

  updateTransaction() {
    final docUser =
        FirebaseFirestore.instance.collection('Users').doc(widget.user.id);
    final docTransaction = FirebaseFirestore.instance
        .collection('Transactions')
        .doc(widget.transactions.id);

    docUser.update({
      'totalIncome': widget.totalIncomeData,
      'totalExpense': widget.totalExpenseData,
      'balance': widget.balance,
      'cat1': widget.newcat1,
      'cat2': widget.newcat2,
      'cat3': widget.newcat3,
      'cat4': widget.newcat4,
      'cat5': widget.newcat5,
    });

    docTransaction.update({
      'title': titlecontroller.text,
      'transactionType': transaction,
      'category': category,
      'amount': double.parse(amountcontroller.text),
      'transactionDate': Timestamp.fromDate(transactionDate),
    });
  }

  editTransaction() async {
    final docTransaction = FirebaseFirestore.instance
        .collection('Transactions')
        .doc(widget.transactions.id);

    final docUser =
        FirebaseFirestore.instance.collection('Users').doc(widget.user.id);

    var totalIncome = await docUser.get().then((value) {
      return value.get('totalIncome');
    });
    var totalExpenses = await docUser.get().then((value) {
      return value.get('totalExpense');
    });
    var balance = await docUser.get().then((value) {
      return value.get('balance');
    });
    var oldamount = await docTransaction.get().then((value) {
      return value.get('amount');
    });
    double cat1 = await docUser.get().then((value) {
      return value.get('cat1');
    });
    double cat2 = await docUser.get().then((value) {
      return value.get('cat2');
    });
    double cat3 = await docUser.get().then((value) {
      return value.get('cat3');
    });
    double cat4 = await docUser.get().then((value) {
      return value.get('cat4');
    });
    double cat5 = await docUser.get().then((value) {
      return value.get('cat5');
    });

    if (category == 'Entertainment') {
      widget.oldcat2 = cat2;
      widget.oldcat3 = cat3;
      widget.oldcat4 = cat4;
      widget.oldcat5 = cat5;
    } else if (category == 'Social & Lifestyle') {
      widget.oldcat1 = cat1;
      widget.oldcat3 = cat3;
      widget.oldcat4 = cat4;
      widget.oldcat5 = cat5;
    } else if (category == 'Beauty & Health') {
      widget.oldcat2 = cat2;
      widget.oldcat1 = cat1;
      widget.oldcat4 = cat4;
      widget.oldcat5 = cat5;
    } else if (category == 'Work & Education') {
      widget.oldcat2 = cat2;
      widget.oldcat3 = cat3;
      widget.oldcat1 = cat1;
      widget.oldcat5 = cat5;
    } else if (category == 'Others') {
      widget.oldcat2 = cat2;
      widget.oldcat3 = cat3;
      widget.oldcat4 = cat4;
      widget.oldcat1 = cat1;
    }

    if (category == 'Entertainment') {
      widget.newcat1 =
          double.parse(amountcontroller.text) + widget.oldcat1 + cat1;
      widget.newcat2 = widget.oldcat2;
      widget.newcat3 = widget.oldcat3;
      widget.newcat4 = widget.oldcat4;
      widget.newcat5 = widget.oldcat5;
    } else if (category == 'Social & Lifestyle') {
      widget.newcat2 =
          double.parse(amountcontroller.text) + widget.oldcat2 + cat2;
      widget.newcat1 = widget.oldcat1;
      widget.newcat3 = widget.oldcat3;
      widget.newcat4 = widget.oldcat4;
      widget.newcat5 = widget.oldcat5;
    } else if (category == 'Beauty & Health') {
      widget.newcat3 =
          double.parse(amountcontroller.text) + widget.oldcat3 + cat3;
      widget.newcat2 = widget.oldcat2;
      widget.newcat1 = widget.oldcat1;
      widget.newcat4 = widget.oldcat4;
      widget.newcat5 = widget.oldcat5;
    } else if (category == 'Work & Education') {
      widget.newcat4 =
          double.parse(amountcontroller.text) + widget.oldcat4 + cat4;
      widget.newcat2 = widget.oldcat2;
      widget.newcat3 = widget.oldcat3;
      widget.newcat1 = widget.oldcat1;
      widget.newcat5 = widget.oldcat5;
    } else if (category == 'Others') {
      widget.newcat5 =
          double.parse(amountcontroller.text) + widget.oldcat5 + cat5;
      widget.newcat2 = widget.oldcat2;
      widget.newcat3 = widget.oldcat3;
      widget.newcat4 = widget.oldcat4;
      widget.newcat1 = widget.oldcat1;
    }

    widget.oldtotalIncomeData =
        transaction == 'Income' ? totalIncome - oldamount : totalIncome;
    widget.oldtotalExpenseData =
        transaction == 'Expense' ? totalExpenses - oldamount : totalExpenses;
    widget.oldbalance = balance;

    widget.totalIncomeData = transaction == 'Income'
        ? double.parse(amountcontroller.text) + widget.oldtotalIncomeData
        : widget.oldtotalIncomeData;
    widget.totalExpenseData = transaction == 'Expense'
        ? double.parse(amountcontroller.text) + widget.oldtotalExpenseData
        : widget.oldtotalExpenseData;

    var amountcondition = balance + double.parse(amountcontroller.text);
    if (transaction == 'Income') {
      if (amountcondition < widget.totalExpenseData) {
        alertBanner(
          'Error !!',
          "Amount entered should be greater than or equal to total expenses",
          'Error',
          const Color.fromARGB(255, 157, 37, 37),
        );
      } else {
        popUpConfirmation();
        widget.balance =
            widget.oldbalance + double.parse(amountcontroller.text);
      }
    } else {
      if (balance < double.parse(amountcontroller.text)) {
        alertBanner(
          'Error !!',
          "Insufficient Balance",
          'Error',
          const Color.fromARGB(255, 157, 37, 37),
        );
      } else {
        popUpConfirmation();
        widget.balance =
            widget.oldbalance - double.parse(amountcontroller.text);
      }
    }
  }
}
