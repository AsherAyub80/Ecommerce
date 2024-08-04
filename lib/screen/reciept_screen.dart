import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecieptScreen extends StatelessWidget {
  const RecieptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference order = FirebaseFirestore.instance.collection('orders');

    return Scaffold(
        body: Center(
      child: Column(
        
        children: [
          Container(
              height: 200,
              width: 350,
              decoration: BoxDecoration(
                color: Colors.grey,
              ))
        ],
      ),
    ));
  }
}
