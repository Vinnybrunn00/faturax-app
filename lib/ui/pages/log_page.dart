import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faturax_app/constants/constants_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LogPage extends StatelessWidget {
  LogPage({super.key});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.blackColor,
        title: Text('Logs'),
        titleTextStyle: TextStyle(color: AppColor.whiteColor),
        iconTheme: IconThemeData(color: AppColor.whiteColor),
      ),
      backgroundColor: AppColor.blackColor,
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _firestore.collection('logs').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(color: AppColor.greenColor);
                }

                if (!snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: .center,
                    children: [
                      Text(
                        'Error',
                        style: TextStyle(color: AppColor.whiteColor),
                      ),
                    ],
                  );
                }

                final docs = snapshot.data!.docs;
                return SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: .horizontal,
                    child: Column(
                      crossAxisAlignment: .start,
                      children: docs
                          .map(
                            (elements) => Row(
                              spacing: 5,
                              children: listLogs(elements)
                                  .map(
                                    (element) => Text(
                                      element['message'].toString(),
                                      style: GoogleFonts.ubuntu(
                                        color: element['color'],
                                        fontWeight: .w500,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> listLogs(
    QueryDocumentSnapshot<Map<String, dynamic>> elements,
  ) {
    return [
      {'message': elements['date'], 'color': AppColor.greyColor},
      {'message': elements['type'], 'color': AppColor.greenColor},
      {'message': elements['message'], 'color': AppColor.whiteColor},
    ];
  }
}
