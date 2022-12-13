import 'package:PocketFlow/content/graph/indicator.dart';
import 'package:PocketFlow/datahandling/users.dart';
import 'package:PocketFlow/design/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PieChartOverall extends StatefulWidget {
  PieChartOverall({
    super.key,
    required this.user,
  });
  Users user;

  @override
  State<PieChartOverall> createState() => _PieChartOverallState();
}

class _PieChartOverallState extends State<PieChartOverall> {
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
              showIndicator()
            ],
          ),
        ),
      ),
    );
  }

  Widget showIndicator() => SizedBox(
        width: 90,
        child: Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Indicator(
                color: Color(0xff53fdd7),
                text: 'Income',
                isSquare: true,
                textColor: Colors.white,
              ),
              Indicator(
                color: Color(0xffff5182),
                text: 'Expense',
                isSquare: true,
                textColor: Colors.white,
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      );

  Widget checkData(id) {
    return StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('Users').doc(id).snapshots(),
        builder: (context, snapshot) {
          var userDocument = snapshot.data;
          if (!snapshot.hasData) {
            return Center(
              child: LoadingAnimationWidget.threeArchedCircle(
                color: const Color.fromARGB(255, 40, 159, 182),
                size: 50,
              ),
            );
          } else {
            return userDocument!['balance'] != 0
                ? realtimeData(id)
                : const Center(
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
              centerSpaceRadius: 45,
              sections: showingSections(
                  incomePercent.round(), expensePercent.round()),
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
