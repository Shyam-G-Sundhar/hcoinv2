import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TransacHis extends StatefulWidget {
  const TransacHis({key});

  @override
  State<TransacHis> createState() => _TransacHisState();
}

class _TransacHisState extends State<TransacHis> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        size: 28,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Transaction History',
                      style: GoogleFonts.reemKufi(
                          color: Colors.black,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            SingleChildScrollView(
              child: Container(
                color: Colors.white,
                height: 700,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('transactions')
                      .orderBy('date', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final transactionDocs = snapshot.data!.docs;
                    final sentTransactions = transactionDocs
                        .where((doc) => doc['type'] == 'Sent')
                        .map((doc) => Transaction(
                              type: 'Sent',
                              name: doc['name'],
                              phoneNumber: doc['recipientPhoneNumber'],
                              coins: doc['coins'].toDouble(),
                              date: doc['date'].toDate(),
                            ))
                        .toList();
                    final receivedTransactions = transactionDocs
                        .where((doc) => doc['type'] == 'Received')
                        .map((doc) => Transaction(
                              type: 'Received',
                              name:
                                  '', // recipient name not available in this collection
                              phoneNumber: doc['senderPhoneNumber'],
                              coins: doc['coins'].toDouble(),
                              date: doc['date'].toDate(),
                            ))
                        .toList();
                    final transactions =
                        sentTransactions + receivedTransactions;
                    if (transactions.isEmpty) {
                      return Center(
                          child: Text(
                        'No transaction history found',
                        style: GoogleFonts.reemKufi(
                            color: Colors.black,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w400),
                      ));
                    }
                    return ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(transaction.type[0]),
                          ),
                          title: Text(transaction.type),
                          subtitle: Text(
                              '${transaction.name.isNotEmpty ? transaction.name + ' - ' : ''}${transaction.phoneNumber}'),
                          trailing: Text(
                            '${transaction.coins.toStringAsFixed(2)} coins',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: transaction.type == 'Sent'
                                  ? Colors.red
                                  : Colors.green,
                            ),
                          ),
                          onTap: () {
                            // handle onTap for transaction details
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}

class Transaction {
  final String type;
  final String name;
  final String phoneNumber;
  final double coins;
  final DateTime date;

  Transaction({
    required this.type,
    required this.name,
    required this.phoneNumber,
    required this.coins,
    required this.date,
  });
}
