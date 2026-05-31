import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class RankingModel with ChangeNotifier {
  RankingModel() {
    _startListening();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int _price = 0;
  int _priceBefore = 0;

  int get price => _price;

  void _startListening() {
    _firestore.collection('users').snapshots().listen((onData) {
      int temp = 0;

      for (int i = 0; i < onData.docs.length; i++) {
        final Map<String, dynamic> data = onData.docs[i].data();

        final int? parser = int.tryParse(data['total'].toString());

        if (parser != null) {
          temp += parser;
        }
      }
      if (temp == _priceBefore) return;
      _price = temp;
      _priceBefore = temp;
      notifyListeners();
    });
  }
}
