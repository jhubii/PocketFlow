import 'package:PocketFlow/content/components/rounded_button.dart';
import 'package:PocketFlow/datahandling/transactions.dart';
import 'package:PocketFlow/design/colors.dart';
import 'package:PocketFlow/content/components/rounded_input.dart';
import 'package:PocketFlow/design/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:another_flushbar/flushbar.dart';

class AddTransaction extends StatefulWidget {
  AddTransaction({
    super.key,
    required this.id,
  });

  String id;
  double totalIncomeData = 0;
  double totalExpenseData = 0;
  double balance = 0;
  final value = NumberFormat("#,##0.00", "en_US");

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  late DateTime now = DateTime.now();
  late DateTime transactionDate = DateTime.now();
  late TextEditingController titlecontroller;
  late TextEditingController amountcontroller;
  late String error;
  late String category;
  late String transaction;

  @override
  void initState() {
    super.initState();
    titlecontroller = TextEditingController();
    amountcontroller = TextEditingController();
    category = '';
    transaction = '';
    error = "";
  }

  @override
  void dispose() {
    titlecontroller.dispose();
    amountcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            size: 21,
            color: mainDesignColor,
          ),
        ),
        title: const Text(
          'Add Transaction',
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
      body: buildContent(widget.id),
    );
  }

  Widget buildContent(id) => Stack(
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
                _radioButtonTransaction(),
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
                          widget.id,
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
                        DateTime? newDate = await showRoundedDatePicker(
                          context: context,
                          initialDate: now,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          borderRadius: 20,
                          theme: ThemeData(primarySwatch: Colors.teal),
                          height: 320,
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
                  title: 'Save',
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

  _radioButtonTransaction() => Container(
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
        "Description can't be empty",
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
      editTransaction(widget.id);
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

  Future createTransaction() async {
    final docTransaction =
        FirebaseFirestore.instance.collection('Transactions').doc();
    final user = FirebaseAuth.instance.currentUser;
    final userid = user!.uid;

    final newTransaction = Transactions(
      id: docTransaction.id,
      userID: userid,
      title: titlecontroller.text,
      category: category,
      transactionType: transaction,
      transactionDate: Timestamp.fromDate(transactionDate),
      dateAdded: Timestamp.fromDate(now),
      amount: double.parse(amountcontroller.text),
    );

    final json = newTransaction.toJson();
    await docTransaction.set(json);
  }

  editTransaction(String id) async {
    final docUser = FirebaseFirestore.instance.collection('Users').doc(id);

    var totalIncome = await docUser.get().then((value) {
      return value.get('totalIncome');
    });
    var totalExpenses = await docUser.get().then((value) {
      return value.get('totalExpense');
    });
    var balance = await docUser.get().then((value) {
      return value.get('balance');
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

    widget.totalIncomeData = transaction == 'Income'
        ? double.parse(amountcontroller.text) + totalIncome
        : totalIncome;
    widget.totalExpenseData = transaction == 'Expense'
        ? double.parse(amountcontroller.text) + totalExpenses
        : totalExpenses;

    if (transaction == 'Income') {
      widget.balance = balance + double.parse(amountcontroller.text);
      createTransaction();
      docUser.update({
        'totalIncome': widget.totalIncomeData,
        'totalExpense': widget.totalExpenseData,
        'balance': widget.balance,
      });
      if (category == 'Entertainment') {
        docUser.update({
          'cat1': double.parse(amountcontroller.text) + cat1,
        });
      } else if (category == 'Social & Lifestyle') {
        docUser.update({
          'cat2': double.parse(amountcontroller.text) + cat2,
        });
      } else if (category == 'Beauty & Health') {
        docUser.update({
          'cat3': double.parse(amountcontroller.text) + cat3,
        });
      } else if (category == 'Work & Education') {
        docUser.update({
          'cat4': double.parse(amountcontroller.text) + cat4,
        });
      } else if (category == 'Others') {
        docUser.update({
          'cat5': double.parse(amountcontroller.text) + cat5,
        });
      }
      Navigator.pop(context);
      alertBanner(
        'Success !!',
        "Transaction Added",
        'Success',
        const Color.fromARGB(255, 47, 101, 114),
      );
    } else {
      if (balance < double.parse(amountcontroller.text)) {
        alertBanner(
          'Error !!',
          "Insufficient Balance",
          'Error',
          const Color.fromARGB(255, 157, 37, 37),
        );
      } else {
        Navigator.pop(context);
        widget.balance = balance - double.parse(amountcontroller.text);
        createTransaction();
        docUser.update({
          'totalIncome': widget.totalIncomeData,
          'totalExpense': widget.totalExpenseData,
          'balance': widget.balance,
        });
        if (category == 'Entertainment') {
          docUser.update({
            'cat1': double.parse(amountcontroller.text) + cat1,
          });
        } else if (category == 'Social & Lifestyle') {
          docUser.update({
            'cat2': double.parse(amountcontroller.text) + cat2,
          });
        } else if (category == 'Beauty & Health') {
          docUser.update({
            'cat3': double.parse(amountcontroller.text) + cat3,
          });
        } else if (category == 'Work & Education') {
          docUser.update({
            'cat4': double.parse(amountcontroller.text) + cat4,
          });
        } else if (category == 'Others') {
          docUser.update({
            'cat5': double.parse(amountcontroller.text) + cat5,
          });
        }

        alertBanner(
          'Success !!',
          "Transaction Added",
          'Success',
          const Color.fromARGB(255, 47, 101, 114),
        );
      }
    }
  }
}
