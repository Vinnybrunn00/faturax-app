import 'package:faturax_app/constants/constants_color.dart';
import 'package:faturax_app/core/auth_service.dart';
import 'package:faturax_app/viewmodels/auth_model.dart';
import 'package:faturax_app/models/auth/password.dart';
import 'package:faturax_app/models/auth/username.dart';
import 'package:faturax_app/navigators/navigators_app.dart';
import 'package:faturax_app/ui/helpers/helpers.dart';
import 'package:faturax_app/ui/pages/home_page.dart';
import 'package:faturax_app/ui/widgets/event_button.dart';
import 'package:faturax_app/ui/widgets/input_text.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class AuthPage extends StatelessWidget {
  final bool? isSignup;

  AuthPage({super.key, this.isSignup});

  final Helpers _helpers = Helpers();
  final NavigatorsApp _navigator = NavigatorsApp();

  void _onSubmit(BuildContext context, AuthModel authModel) async {
    try {
      authModel.setLoading = true;

      final Username username = Username(
        username: authModel.username.toLowerCase(),
      );

      final Password password = Password(password: authModel.password);

      username.validate();
      password.validate();

      final AuthServices services = AuthServices(
        username: username.getValue,
        password: password.getValue,
      );

      isSignup == null ? await services.signIn() : await services.signUp();

      if (!context.mounted) return;
      await _navigator.pushAndRemoveUntil(context, HomePage());
    } on FirebaseException catch (messageError) {
      if (!context.mounted) return;
      _helpers.showMessageInfo(context, message: messageError.toString());
    } catch (messageError) {
      if (!context.mounted) return;
      _helpers.showMessageInfo(context, message: messageError.toString());
    } finally {
      authModel.setLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthModel provider = Provider.of<AuthModel>(context);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: Container(
        margin: EdgeInsets.only(top: 20),
        height: 45,
        width: 45,
        child: Material(
          borderRadius: BorderRadius.circular(45 / 2),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(45 / 2),
            child: Ink(
              decoration: BoxDecoration(
                color: AppColor.purpleColor,
                borderRadius: BorderRadius.circular(45 / 2),
              ),
              child: Icon(Icons.arrow_back, color: AppColor.whiteColor),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: Container(
        height: size.height,
        width: size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF111540), Color(0xFF2B3699), Color(0xff4150F7)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          alignment: .center,
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: .center,
                children: [
                  // Branding
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(25),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withAlpha(55),
                        width: 1.5,
                      ),
                    ),
                    child: Image.asset('assets/images/image-bg.png'),
                  ),
                  Text(
                    'Faturax',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                    ),
                  ),
                  if (isSignup == null)
                    Text(
                      'Entrar como ${provider.username}',
                      style: TextStyle(
                        color: Colors.white.withAlpha(170),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.2,
                      ),
                    ),
                  SizedBox(height: size.height * .03),
                  // Form card
                  AnimatedSize(
                    duration: Duration(milliseconds: 450),
                    reverseDuration: Duration(milliseconds: 450),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 30,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(60),
                            blurRadius: 35,
                            offset: const Offset(0, 14),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            isSignup == null ? 'Entrar' : 'Criar Conta',
                            style: const TextStyle(
                              color: Color(0xFF111540),
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isSignup == null
                                ? 'Acesse sua conta para continuar'
                                : 'Preencha os dados abaixo',
                            style: TextStyle(
                              color: AppColor.greyColor,
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(height: isSignup == null ? 0 : 22),
                          if (isSignup != null)
                            InputText(
                              prefixIcon: Icon(
                                Icons.person_outline_rounded,
                                size: 20,
                                color: AppColor.blackColorAlpha70,
                              ),
                              styleTextColor: const Color(0xFF111540),
                              onChanged: (name) => provider.username = name,
                              hintText: 'Usuário',
                              borderRadius: BorderRadius.circular(14),
                            ),
                          const SizedBox(height: 14),
                          InputText(
                            prefixIcon: Icon(
                              Icons.lock_outline_rounded,
                              size: 20,
                              color: AppColor.blackColorAlpha70,
                            ),
                            suffixIcon: InkWell(
                              onTap: () => provider.setObscureText(),
                              child: Icon(
                                provider.isObscure
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 20,
                                color: AppColor.blackColorAlpha70,
                              ),
                            ),
                            styleTextColor: const Color(0xFF111540),
                            onChanged: (passwd) => provider.password = passwd,
                            hintText: 'Senha',
                            borderRadius: BorderRadius.circular(14),
                            obscureText: provider.isObscure,
                          ),
                          if (isSignup != null) ...[
                            const SizedBox(height: 14),
                            InputText(
                              prefixIcon: Icon(
                                Icons.lock_outline_rounded,
                                size: 20,
                                color: AppColor.blackColorAlpha70,
                              ),
                              suffixIcon: InkWell(
                                onTap: () => provider.setObscureText(),
                                child: Icon(
                                  provider.isObscure
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 20,
                                  color: AppColor.blackColorAlpha70,
                                ),
                              ),
                              styleTextColor: const Color(0xFF111540),
                              onChanged: (passwd) => provider.password = passwd,
                              hintText: 'Confirmar Senha',
                              borderRadius: BorderRadius.circular(14),
                              obscureText: provider.isObscure,
                            ),
                          ],
                          const SizedBox(height: 26),
                          EventButton(
                            onTap: !provider.isLoading
                                ? () => _onSubmit(context, provider)
                                : null,
                            title: isSignup == null ? 'Entrar' : 'Criar Conta',
                            color: const Color(0xff4150F7),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Loading overlay
            if (provider.isLoading)
              Container(
                color: Colors.black.withAlpha(75),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    height: 82,
                    width: 82,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(40),
                          blurRadius: 24,
                        ),
                      ],
                    ),
                    child: const CircularProgressIndicator(
                      color: Color(0xff4150F7),
                      strokeWidth: 3,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
