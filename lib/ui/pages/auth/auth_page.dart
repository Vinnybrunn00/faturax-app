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
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 450),
                    child: Text(
                      provider.isLogin
                          ? 'Faça login em sua conta'
                          : 'Crie sua conta',
                      key: ValueKey(provider.isLogin),
                      style: TextStyle(
                        color: Colors.white.withAlpha(170),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.2,
                      ),
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
                            provider.isLogin ? 'Entrar' : 'Criar Conta',
                            style: const TextStyle(
                              color: Color(0xFF111540),
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            provider.isLogin
                                ? 'Acesse sua conta para continuar'
                                : 'Preencha os dados abaixo',
                            style: TextStyle(
                              color: AppColor.greyColor,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 22),
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
                          if (provider.isSignup) ...[
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
                            title: provider.isLogin ? 'Entrar' : 'Criar Conta',
                            color: const Color(0xff4150F7),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                provider.isLogin
                                    ? 'Não tem uma conta?  '
                                    : 'Já tem uma conta?  ',
                                style: TextStyle(
                                  color: AppColor.greyColor,
                                  fontSize: 13,
                                ),
                              ),
                              GestureDetector(
                                onTap: provider.isLoading
                                    ? null
                                    : () => provider.changeMode(),
                                child: const Text(
                                  '',
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                              GestureDetector(
                                onTap: provider.isLoading
                                    ? null
                                    : () => provider.changeMode(),
                                child: Text(
                                  provider.isLogin
                                      ? 'Criar conta'
                                      : 'Fazer login',
                                  style: const TextStyle(
                                    color: Color(0xff4150F7),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
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
