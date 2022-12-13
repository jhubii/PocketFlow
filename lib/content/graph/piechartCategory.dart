import 'package:PocketFlow/content/graph/indicator.dart';
import 'package:PocketFlow/datahandling/users.dart';
import 'package:PocketFlow/design/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PieChartCategory extends StatefulWidget {
  PieChartCategory({
    super.key,
    required this.user,
  });
  Users user;

  @override
  State<PieChartCategory> createState() => _PieChartCategoryState();
}

class _PieChartCategoryState extends State<PieChartCategory> {
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

  Widget showIndicator() => SizedBox(
        width: 130,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            Indicator(
              color: Color(0xff0293ee),
              text: 'Entertainment',
              isSquare: true,
              textColor: Colors.white,
            ),
            Indicator(
              color: Color(0xfff8b250),
              text: 'Social & Lifestyle',
              isSquare: true,
              textColor: Colors.white,
            ),
            Indicator(
              color: Color(0xff845bef),
              text: 'Beauty & Health',
              isSquare: true,
              textColor: Colors.white,
            ),
            Indicator(
              color: Color(0xff13d38e),
              text: 'Work & Education',
              isSquare: true,
              textColor: Colors.white,
            ),
            Indicator(
              color: Color.fromARGB(255, 253, 83, 83),
              text: 'Others',
              isSquare: true,
              textColor: Colors.white,
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      );

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
        int cat1 = transactionDocument['cat1'];
        int cat2 = transactionDocument['cat2'];
        int cat3 = transactionDocument['cat3'];
        int cat4 = transactionDocument['cat4'];
        int cat5 = transactionDocument['cat5'];
        int totalMoneyFlow = income + expense;
        double cat1percent = (cat1 / totalMoneyFlow) * 100;
        double cat2percent = (cat2 / totalMoneyFlow) * 100;
        double cat3percent = (cat3 / totalMoneyFlow) * 100;
        double cat4percent = (cat4 / totalMoneyFlow) * 100;
        double cat5percent = (cat5 / totalMoneyFlow) * 100;
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
            centerSpaceRadius: 40,
            sections: showingSections(cat1percent.round(), cat2percent.round(),
                cat3percent.round(), cat4percent.round(), cat5percent.round()),
          ),
        );
      },
    );
  }

  List<PieChartSectionData> showingSections(
      int entertainment, int social, int beauty, int work, int other) {
    return List.generate(5, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: entertainment.toDouble(),
            title: '$entertainment%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: social.toDouble(),
            title: '$social%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: beauty.toDouble(),
            title: '$beauty%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: work.toDouble(),
            title: '$work%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        case 4:
          return PieChartSectionData(
            color: const Color.fromARGB(255, 253, 83, 83),
            value: other.toDouble(),
            title: '$other%',
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
