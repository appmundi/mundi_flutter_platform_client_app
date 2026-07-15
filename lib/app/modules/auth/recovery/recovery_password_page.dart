import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart' hide ModularWatchExtension;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/widgets/default_padding.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/auth/recovery/cubit/recovery_password_cubit.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/auth/recovery/cubit/recovery_password_state.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/ui/helpers/messages.dart';
import '../../../core/ui/widgets/mundi_app_bar.dart';
import '../register/widgets/card_register.dart';

part 'widgets/card_form.dart';

class RecoveryPasswordPage extends StatefulWidget {
  const RecoveryPasswordPage({super.key});

  @override
  State<RecoveryPasswordPage> createState() => _RecoveryPasswordPageState();
}

class _RecoveryPasswordPageState extends State<RecoveryPasswordPage> with Messages<RecoveryPasswordPage>{
  final newPasswordCtrl = TextEditingController();
  final codeCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  final _stepController = PageController(initialPage: 0);

  Future<void> onSubmit() async {
    if (_stepController.page == 0) {
      await context.read<RecoveryPasswordCubit>().resetPassword(emailCtrl.text);
    } else if(_stepController.page == 1){
      await context.read<RecoveryPasswordCubit>().validateCode(emailCtrl.text, codeCtrl.text);

    }else if(_stepController.page == 2){
      await context.read<RecoveryPasswordCubit>().newPassword(emailCtrl.text, codeCtrl.text, newPasswordCtrl.text);
    }
  }

  void onReturn() {
    if (_stepController.page != 0) {
      _stepController.previousPage(
          duration: const Duration(milliseconds: 20), curve: Curves.bounceIn);
    } else {
      Modular.to.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(6, 14, 39, 1),
      body: BlocConsumer<RecoveryPasswordCubit, RecoveryPasswordState>(
        listener: (context, state) {
          state.status.matchAny(
            success: () {
              showSuccess("Codigo enviado com sucesso!");
            },
            error: () {
              showError(state.errorMessage ?? "Erro não informado");
            },
            any: () {},
            sendCode: (){
              showSuccess("Codigo validado com sucesso!");
              _stepController.nextPage(
                duration: const Duration(milliseconds: 20),
                curve: Curves.bounceIn,
              );
            },
            resetPassword: (){
              showSuccess("Codigo enviado com sucesso!");
              _stepController.nextPage(
                duration: const Duration(milliseconds: 20),
                curve: Curves.bounceIn,
              );
            },
            newPassword: (){
              showSuccess("Senha alterada com sucesso!");
              Modular.to.pop();
            }

          );
        },
        builder: (context, state) {
          return PageView(
            controller: _stepController,
            physics: const NeverScrollableScrollPhysics(),
            pageSnapping: false,
            children: [
              _CardForm(
                label: 'Qual seu melhor e-mail?',
                bgImagePath:
                'assets/images/ellipses/register/registerEllipses.png',
                controller: emailCtrl,
                onSubmit: onSubmit,
                onReturn: onReturn,
                hintText: "Exemplo@exemplo.com",
                validator: Validatorless.multiple([
                  Validatorless.required("Campo é obrigatório"),
                  Validatorless.email("E-mail inválido")
                ]),
              ),
              _CardForm(
                label: 'Qual codigo de chegou no seu email?',
                bgImagePath:
                'assets/images/ellipses/register/registerEllipses.png',
                controller: codeCtrl,
                onSubmit: onSubmit,
                onReturn: onReturn,
                hintText: "00000000",
                inputFormatters: [
                  MaskTextInputFormatter(mask: "########"),
                ],
                validator: Validatorless.multiple([
                  Validatorless.required("Campo é obrigatório"),
                ]),
              ),
              _CardForm(
                label: 'Me conta baixinho, qual senha você quer colocar?',
                bgImagePath:
                'assets/images/ellipses/register/registerEllipses.png',
                controller: newPasswordCtrl,
                onSubmit: onSubmit,
                onReturn: onReturn,
                hintText: "**********",
                obscureText: true,
                validator: Validatorless.multiple([
                  Validatorless.required("Campo é obrigatório"),
                  Validatorless.min(
                      4, "A senha deve ter mais do que 4 caracteres"),
                ]),
              ),
            ],
          );
        },
      ),
    );
  }
}
