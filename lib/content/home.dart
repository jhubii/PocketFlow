import 'package:PocketFlow/content/addTransaction.dart';
import 'package:PocketFlow/content/components/iconCondition.dart';
import 'package:PocketFlow/content/profile.dart';
import 'package:PocketFlow/content/stats.dart';
import 'package:PocketFlow/content/transactions.dart';
import 'package:PocketFlow/datahandling/transactions.dart';
import 'package:PocketFlow/design/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:PocketFlow/datahandling/users.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  Home({super.key});

  final value = NumberFormat("#,##0.00", "en_US");

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  final currentuser = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screens(Users user) => [
          buildContent(user),
          Stats(user: user),
          DisplayTransactions(user: user),
          Profile(user: user),
        ];

    return Scaffold(
      bottomNavigationBar: navBarContent(),
      floatingActionButton: addButton(currentuser.uid),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: FutureBuilder<Users?>(
        future: readUser(currentuser.uid),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
            final user = snapshot.data;
            return user == null
                ? const Center(child: Text('No User'))
                : screens(user)[_selectedIndex];
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: mainDesignColor,
              ),
            );
          }
        }),
      ),
    );
  }

  Widget buildContent(Users user) => Center(
        child: Stack(
          children: [
            Positioned(
              top: -50,
              left: -50,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(250),
                    color: const Color.fromARGB(61, 71, 105, 104)),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  appBarContent(user),
                  cardContent(user),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 25, right: 25, bottom: 10, top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Transactions',
                              style: TextStyle(
                                color: mainDesignColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Navigate to search to see all transactions',
                              style: TextStyle(
                                color: Color.fromARGB(255, 118, 118, 118),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: fetchTransaction(user.id),
                  )),
                ],
              ),
            ),
          ],
        ),
      );

  appBarContent(Users user) => Container(
        padding:
            const EdgeInsets.only(top: 45, left: 22, bottom: 25, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hello,',
                  style: TextStyle(
                    color: mainDesignColor,
                    fontSize: 30,
                  ),
                ),
                Text(
                  user.firstname,
                  style: const TextStyle(
                    color: mainDesignColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
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
              child: user.image == '-'
                  ? imgNotExist()
                  : realtimeDataImage(user.id, 'image'),
            ),
          ],
        ),
      );

  cardContent(Users user) => Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: gradientDesignColor,
              color: mainDesignColor,
              borderRadius: BorderRadius.circular(35),
            ),
            height: 240,
            width: 360,
            child: Stack(
              children: [
                Positioned(
                  top: -50,
                  right: -50,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: const Color.fromARGB(46, 161, 161, 161)),
                  ),
                ),
                Positioned(
                  top: 45,
                  left: 240,
                  child: Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: const Color.fromARGB(255, 69, 103, 106),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Balance',
                            style: TextStyle(
                              color: whiteDesignColor,
                              fontSize: 17,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.pesoSign,
                                color: whiteDesignColor,
                                size: 22,
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              realtimeData(
                                user.id,
                                'balance',
                                const TextStyle(
                                  fontSize: 40,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.bold,
                                  color: whiteDesignColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      incomeExpenses(user),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  incomeExpenses(Users user) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: const Color.fromARGB(255, 69, 103, 106),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 17),
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
                      user.id,
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
                      user.id,
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

  Widget fetchTransaction(id) {
    return StreamBuilder<List<Transactions>>(
      stream: readTransactions(id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong! ${snapshot.error}');
        } else if (snapshot.hasData) {
          final transactions = snapshot.data!;

          return GroupedListView(
            padding: const EdgeInsets.only(top: 0, bottom: 45),
            elements: transactions,
            groupBy: (element) =>
                DateFormat("MM-dd-yyyy").format(element.dateAdded.toDate()),
            groupSeparatorBuilder: (String groupByValue) => Padding(
              padding: const EdgeInsets.only(left: 20, top: 15),
              child: Text(
                groupByValue == DateFormat("MM-dd-yyyy").format(DateTime.now())
                    ? 'Today'
                    : groupByValue,
                style: const TextStyle(color: mainDesignColor, fontSize: 15),
              ),
            ),
            itemBuilder: ((context, element) {
              return transactionContent(element);
            }),
            order: GroupedListOrder.DESC,
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: mainDesignColor,
            ),
          );
        }
      },
    );
  }

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
                    ? '- ₱${widget.value.format(int.parse(transactions.amount.toString()))}'
                    : '+ ₱${widget.value.format(int.parse(transactions.amount.toString()))}',
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
      );

  addButton(id) => FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTransaction(id: id),
            ),
          );
        },
        backgroundColor: mainDesignColor,
        child: const Icon(Icons.add),
      );

  navBarContent() => Padding(
        padding:
            const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 23),
        child: GNav(
          color: mainDesignColor,
          gap: 5,
          activeColor: Colors.white,
          tabBackgroundGradient: gradientDesignColor,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          selectedIndex: _selectedIndex,
          onTabChange: (index) => setState(() => _selectedIndex = index),
          tabs: const [
            GButton(
              icon: Icons.home_outlined,
              text: 'Home',
            ),
            GButton(
              icon: Icons.stacked_bar_chart_rounded,
              text: 'Stats',
              margin: EdgeInsets.only(
                right: 30,
              ),
            ),
            GButton(
              icon: Icons.search_rounded,
              text: 'Search',
              margin: EdgeInsets.only(
                left: 30,
              ),
            ),
            GButton(
              icon: Icons.person_outline_rounded,
              text: 'Profile',
            ),
          ],
        ),
      );

  Widget imgNotExist() => const Icon(
        Icons.person,
        color: whiteDesignColor,
        size: 12,
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
      },
    );
  }

  Future<Users?> readUser(String id) async {
    final docUser = FirebaseFirestore.instance.collection('Users').doc(id);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return Users.fromJson(snapshot.data()!);
    }
  }

  Stream<List<Transactions>> readTransactions(id) => FirebaseFirestore.instance
      .collection('Transactions')
      .where('userID', isEqualTo: id)
      .orderBy('dateAdded', descending: true)
      .limit(6)
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
}
