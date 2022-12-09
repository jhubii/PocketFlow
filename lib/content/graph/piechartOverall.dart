import 'package:PocketFlow/datahandling/users.dart';
import 'package:PocketFlow/design/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartTransactions extends StatefulWidget {
  PieChartTransactions({
    super.key,
    required this.user,
  });
  Users user;

  @override
  State<PieChartTransactions> createState() => _PieChartTransactionsState();
}

class _PieChartTransactionsState extends State<PieChartTransactions> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: mainDesignColor,
        child: Center(
          child: Row(
            children: [
              const SizedBox(
                height: 18,
              ),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: checkData(widget.user.id),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget checkData(id) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Transactions')
            .doc(id)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData == true) {
            return realtimeData(id);
          } else {
            return Center(
              child: Text(
                'No Data...',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            );
          }
        });
  }

  Widget realtimeData(id) {
    return StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('Users').doc(id).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text("Loading");
          }
          var transactionDocument = snapshot.data;
          int income = transactionDocument!['totalIncome'];
          int expense = transactionDocument['totalExpense'];
          int totalMoneyFlow = income + expense;
          double incomePercent = (income / totalMoneyFlow) * 100;
          double expensePercent = (expense / totalMoneyFlow) * 100;
          return PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 0,
              centerSpaceRadius: 50,
              sections: showingSections(
                  incomePercent.toInt(), expensePercent.toInt()),
            ),
          );
        });
  }

  List<PieChartSectionData> showingSections(
      int incomePercent, int expensePercent) {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff53fdd7),
            value: incomePercent.toDouble(),
            title: '$incomePercent%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xffff5182),
            value: expensePercent.toDouble(),
            title: '$expensePercent%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
