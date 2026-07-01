import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faturax_app/constants/constants_color.dart';
import 'package:faturax_app/services/current_version.dart';
import 'package:faturax_app/ui/pages/auth/auth_page.dart';
import 'package:faturax_app/viewmodels/auth_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:provider/provider.dart';

class AuthBubblePage extends StatelessWidget {
  const AuthBubblePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final AuthModel provider = Provider.of<AuthModel>(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarContrastEnforced: false,
        systemNavigationBarIconBrightness: .light,
      ),
      child: Consumer<CurrentVersion>(
        builder: (context, currentVersion, _) {
          return Scaffold(
            floatingActionButtonLocation: .centerDocked,
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                'Versão ${currentVersion.version}',
                style: TextStyle(color: AppColor.whiteColor),
              ),
            ),
            body: SizedBox.expand(
              child: Container(
                height: size.height,
                width: size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF111540),
                      Color(0xFF2B3699),
                      Color(0xff4150F7),
                    ],
                    stops: [0.0, 0.5, 1],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: .center,
                  children: [
                    Text(
                      'Quem é você?',
                      style: TextStyle(
                        color: AppColor.whiteColor,
                        fontSize: 30,
                      ),
                    ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                
                        if (!snapshot.hasData) return Text('Erro');
                
                        final List<
                          QueryDocumentSnapshot<Map<String, dynamic>>
                        >?
                        docs = snapshot.data?.docs;
                
                        if (docs == null) {
                          return Text('No Data');
                        }
                
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                              ),
                
                          shrinkWrap: true,
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final String username = docs[index]['username'];
                
                            return Column(
                              spacing: 5,
                              mainAxisAlignment: .center,
                              children: [
                                Material(
                                  color: AppColor.purpleColor,
                                  borderRadius: BorderRadius.circular(
                                    80 / 2,
                                  ),
                                  child: InkWell(
                                    onTap: () async {
                                      provider.username = username;
                
                                      await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => AuthPage(),
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(
                                      80 / 2,
                                    ),
                                    child: Ink(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        color: AppColor.purpleColor
                                            .withAlpha(155),
                                        borderRadius: BorderRadius.circular(
                                          80 / 2,
                                        ),
                                        border: Border.all(
                                          color: AppColor.borderColor,
                                        ),
                                      ),
                                      child: Icon(
                                        BoxIcons.bx_user,
                                        color: AppColor.whiteColor,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  username,
                                  style: TextStyle(
                                    color: AppColor.whiteColor.withAlpha(
                                      155,
                                    ),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 25,
                        right: 25,
                        top: 3,
                        bottom: 3,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColor.purpleColor),
                      ),
                      child: GestureDetector(
                        onTap: () async {
                         await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AuthPage(isSignup: true),
                            ),
                          );
                        },
                        child: Text(
                          'Criar conta',
                          style: TextStyle(
                            color: AppColor.whiteColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
