import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faturax_app/constants/constants_color.dart';
import 'package:faturax_app/repository/ranking_repository.dart';
import 'package:faturax_app/repository/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RankingPage extends StatelessWidget {
  RankingPage({super.key});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        title: Consumer2<RankingRepository, ProductRepository>(
          builder: (context, ranking, product, _) {
            return Text(
              product.convertCentInReais(ranking.price),
              style: TextStyle(color: AppColor.whiteColor),
            );
          },
        ),
        backgroundColor: AppColor.pupleColor,
        iconTheme: IconThemeData(color: AppColor.whiteColor),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _firestore.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text('no data');
                }

                final docs = snapshot.data!.docs;
                final ProductRepository product = context
                    .read<ProductRepository>();

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final Map<String, dynamic> data = docs[index].data();

                    return ListTile(
                      leading: Icon(Icons.person),
                      title: Text(data['username'].toString()),
                      trailing: Text(
                        data['total'] != null
                            ? product.convertCentInReais(data['total'])
                            : data['total'].toString(),
                        style: TextStyle(fontSize: 14, fontWeight: .w500),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
