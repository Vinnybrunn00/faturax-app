import 'package:faturax/constants/constants_color.dart';
import 'package:faturax/core/auth_service.dart';
import 'package:faturax/models/auth/password.dart';
import 'package:faturax/models/auth/auth_model.dart';
import 'package:faturax/models/auth/username.dart';
import 'package:faturax/ui/widgets/event_button.dart';
import 'package:faturax/ui/widgets/input_text.dart';
import 'package:faturax/ui/pages/home_page.dart';
import 'package:faturax/utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class AuthPage extends StatelessWidget {
  AuthPage({super.key});

  final Utils _utils = Utils();

  void _onSubmit(BuildContext context, AuthModel authModel) async {
    try {
      authModel.setLoading = true;
      final Username username = Username(username: authModel.username);
      final Password password = Password(password: authModel.password);

      username.validate();
      password.validate();

      final AuthServices services = AuthServices(
        username: username.getValue,
        password: password.getValue,
      );
      authModel.isLogin ? await services.signIn() : await services.signUp();

      if (!context.mounted) return;
      await _utils.pushAndRemoveUntil(context, HomePage());
    } on FirebaseException catch (messageError) {
      if (!context.mounted) return;
      _utils.showMessageInfo(context, message: messageError.toString());
    } catch (messageError) {
      if (!context.mounted) return;
      _utils.showMessageInfo(context, message: messageError.toString());
    } finally {
      authModel.setLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthModel provider = Provider.of<AuthModel>(context);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.backgroundColorWhite,
      body: SizedBox.expand(
        child: Stack(
          alignment: AlignmentGeometry.center,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 350),
              height: provider.isLogin ? size.height * .39 : size.height * .49,
              width: size.width * .8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                spacing: 15,
                mainAxisAlignment: .center,
                crossAxisAlignment: .center,
                children: [
                  Text(
                    provider.isLogin ? 'Entrar' : 'Criar Conta',
                    style: TextStyle(
                      color: AppColor.blackBlueLow,
                      fontSize: 20,
                    ),
                  ),
                  InputText(
                    styleTextColor: AppColor.blackBlue,
                    onChanged: (name) => provider.username = name,
                    hintText: 'Usuário',
                    borderRadius: BorderRadius.circular(16),
                  ),
                  InputText(
                    suffixIcon: InkWell(
                      onTap: () {
                        provider.setObscureText();
                      },
                      child: Icon(
                        provider.isObscure
                            ? Icons.visibility_off
                            : Icons.visibility,
                        size: 20,
                      ),
                    ),
                    styleTextColor: AppColor.blackBlue,
                    onChanged: (passwd) => provider.password = passwd,
                    hintText: 'Senha',
                    borderRadius: BorderRadius.circular(16),
                    obscureText: provider.isObscure,
                  ),

                  if (provider.isSignup)
                    InputText(
                      suffixIcon: InkWell(
                        onTap: () {
                          provider.setObscureText();
                        },
                        child: Icon(
                          provider.isObscure
                              ? Icons.visibility_off
                              : Icons.visibility,
                          size: 20,
                        ),
                      ),
                      styleTextColor: AppColor.blackBlue,
                      onChanged: (passwd) => provider.password = passwd,
                      hintText: 'Confirmar Senha',
                      borderRadius: BorderRadius.circular(16),
                      obscureText: provider.isObscure,
                    ),

                  EventButton(
                    onTap: !provider.isLoading
                        ? () => _onSubmit(context, provider)
                        : null,
                    title: provider.isLogin ? 'LogIn' : 'Signup',
                    color: Color(0xff4150F7),
                  ),

                  InkWell(
                    onTap: provider.isLoading
                        ? null
                        : () => provider.changeMode(),
                    child: Text(
                      provider.isLogin ? "Criar uma conta" : "Fazer Login",
                      style: TextStyle(color: AppColor.backgroundColor),
                    ),
                  ),
                ],
              ),
            ),
            provider.isLoading
                ? Center(
                    child: Container(
                      padding: EdgeInsets.all(23),
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFF232323).withAlpha(160),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: CircularProgressIndicator(
                        color: Colors.cyanAccent,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
