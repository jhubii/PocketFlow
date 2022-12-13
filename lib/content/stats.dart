import 'package:PocketFlow/content/graph/piechartCategory.dart';
import 'package:PocketFlow/content/graph/piechartOverall.dart';
import 'package:PocketFlow/datahandling/users.dart';
import 'package:PocketFlow/design/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class Stats extends StatefulWidget {
  Stats({
    super.key,
    required this.user,
  });

  Users user;
  final value = NumberFormat("#,##0.00", "en_US");

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  @override
  Widget build(BuildContext context) {
    return buildContent(widget.user.id);
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                appBarContent(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(top: 0),
                    children: [
                      incomeExpenses(),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text(
                            'Overall Transaction Report',
                            style: TextStyle(
                              color: mainDesignColor,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      PieChartOverall(
                        user: widget.user,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text(
                            'Transactions by Category Report',
                            style: TextStyle(
                              color: mainDesignColor,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      PieChartCategory(user: widget.user),
                      const SizedBox(height: 70),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      );

  appBarContent() => Container(
        padding: const EdgeInsets.only(top: 45, bottom: 25, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Statistics',
                  style: TextStyle(
                    color: mainDesignColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(250),
                color: mainDesignColor,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0),
                    blurRadius: 2.0,
                  ),
                ],
              ),
              child: widget.user.image == '-'
                  ? imgNotExist()
                  : realtimeDataImage(widget.user.id, 'image'),
            ),
          ],
        ),
      );

  incomeExpenses() => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: const Color.fromARGB(255, 69, 103, 106),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.arrow_upward_rounded,
                      color: Colors.green,
                    ),
                    Text(
                      'Income',
                      style: TextStyle(
                        color: whiteDesignColor,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Column(
                      children: const [
                        FaIcon(
                          FontAwesomeIcons.pesoSign,
                          color: whiteDesignColor,
                          size: 13,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    realtimeData(
                      widget.user.id,
                      'totalIncome',
                      const TextStyle(
                        fontSize: 20,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                        color: whiteDesignColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.arrow_downward_rounded,
                      color: Colors.red,
                    ),
                    Text(
                      'Expenses',
                      style: TextStyle(
                        color: whiteDesignColor,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Column(
                      children: const [
                        FaIcon(
                          FontAwesomeIcons.pesoSign,
                          color: whiteDesignColor,
                          size: 13,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    realtimeData(
                      widget.user.id,
                      'totalExpense',
                      const TextStyle(
                        fontSize: 20,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                        color: whiteDesignColor,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      );

  Widget imgNotExist() => const Icon(
        Icons.person,
        color: whiteDesignColor,
        size: 30,
      );

  Widget realtimeDataImage(id, info) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection('Users').doc(id).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Text("Loading");
        }
        var userDocument = snapshot.data;
        return CircleAvatar(
          radius: 15,
          backgroundImage: NetworkImage(userDocument![info]),
        );
      },
    );
  }

  Widget realtimeData(id, info, style) {
    return StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('Users').doc(id).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text("Loading");
          }
          var userDocument = snapshot.data;
          return FittedBox(
            fit: BoxFit.cover,
            child: Text(
                widget.value.format(int.parse(userDocument![info].toString())),
                style: style),
          );
        });
  }
}
