import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart'
    hide ModularWatchExtension;
import 'package:search_cep/search_cep.dart';

import 'widgets/category_check_box.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/extension/size_screen_extension.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/helpers/messages.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/colors_app.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/widgets/app_button.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/widgets/calendar_picker.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/widgets/default_padding.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/widgets/mundi_app_bar.dart';
import 'package:mundi_flutter_platform_client_app/app/models/entrepreneur.dart';
import 'package:mundi_flutter_platform_client_app/app/models/user.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/auth/register/cubit/register_cubit.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/category/i_category_repository.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/auth/register/cubit/register_state.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/auth/register/widgets/card_register.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:validatorless/validatorless.dart';

part 'widgets/card_form.dart';
part 'widgets/birth_form.dart';
part 'widgets/category_form.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with Messages<RegisterPage> {
  final nameCtrl = TextEditingController();
  final cepCtrl = TextEditingController();
  final cpfCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final addressNumberCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final _stepController = PageController(initialPage: 0);

  

  Future<void> onSubmit() async {
    if (_stepController.page != 8) {
      final viaCepSearchCep = ViaCepSearchCep();
      final infoCepJSON = await viaCepSearchCep.searchInfoByCep(cep: cepCtrl.text);
      print(infoCepJSON.fold((_) => null, (data) => data));
      _stepController.nextPage(
        duration: const Duration(milliseconds: 20),
        curve: Curves.bounceIn,
      );
      Modular.get<User>().name = nameCtrl.text;
      Modular.get<User>().doc = cpfCtrl.text;
      Modular.get<User>().email = emailCtrl.text;
      Modular.get<User>().password = passwordCtrl.text;
      Modular.get<User>().phone = phoneCtrl.text;
      Modular.get<User>().address = infoCepJSON.fold((_) => "", (data) => "${data.logradouro!}, ${data.bairro!}");
      Modular.get<User>().cep = cepCtrl.text;
      Modular.get<User>().city = infoCepJSON.fold((_) => "", (data) => data.localidade!);
      Modular.get<User>().state = infoCepJSON.fold((_) => "", (data) => data.uf!);
      Modular.get<User>().addressNumber = addressNumberCtrl.text;

    } else {
      await context.read<RegisterCubit>().register(
            Modular.get<User>(),
          );
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
      body: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          state.status.matchAny(
            success: () {
              showSuccess("Usuário criado com sucesso");
              Modular.to.pop();
            },
            error: () {
              showError(state.errorMessage ?? "Erro não informado");
            },
            any: () {},
          );
        },
        builder: (context, state) {
          return PageView(
            controller: _stepController,
            physics: const NeverScrollableScrollPhysics(),
            pageSnapping: false,
            children: [
              _CardForm(
                label: 'Qual seu nome?',
                bgImagePath:
                    'assets/images/ellipses/register/registerEllipses.png',
                controller: nameCtrl,
                onSubmit: onSubmit,
                onReturn: onReturn,
                hintText: "Nome completo",
                validator: Validatorless.required("Campo é obrigatório"),
              ),
              _CardForm(
                label: 'CPF',
                bgImagePath:
                    'assets/images/ellipses/register/registerEllipses.png',
                controller: cpfCtrl,
                onSubmit: onSubmit,
                onReturn: onReturn,
                hintText: "000.000.000-XX",
                inputFormatters: [
                  MaskTextInputFormatter(mask: "###.###.###-##"),
                ],
                validator: Validatorless.multiple([
                  Validatorless.required("Campo é obrigatório"),
                  Validatorless.cpf("CPF inválido")
                ]),
              ),
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
                label: 'E o celular?',
                bgImagePath:
                    'assets/images/ellipses/register/registerEllipses.png',
                controller: phoneCtrl,
                onSubmit: onSubmit,
                onReturn: onReturn,
                hintText: "(XX) 90000-0000",
                inputFormatters: [
                  MaskTextInputFormatter(mask: "(##) #####-####"),
                ],
                validator: Validatorless.multiple([
                  Validatorless.required("Campo é obrigatório"),
                ]),
              ),
              _CardForm(
                label: 'Qual seu cep?',
                bgImagePath:
                'assets/images/ellipses/register/registerEllipses.png',
                controller: cepCtrl,
                onSubmit: onSubmit,
                onReturn: onReturn,
                hintText: "CEP sem (-)",
                validator: Validatorless.required("Campo é obrigatório"),
              ),
              _CardForm(
                label: 'Digite o numero da casa',
                bgImagePath:
                'assets/images/ellipses/register/registerEllipses.png',
                controller: addressNumberCtrl,
                onSubmit: onSubmit,
                onReturn: onReturn,
                hintText: "Numero da casa",
                validator: Validatorless.required("Campo é obrigatório"),
              ),
              _CardForm(
                label: 'Me conta baixinho, qual senha você quer colocar?',
                bgImagePath:
                    'assets/images/ellipses/register/registerEllipses.png',
                controller: passwordCtrl,
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
              _BirthForm(
                onReturn: onReturn,
                onSubmit: onSubmit,
              ),
              _CategoryForm(
                onSubmit: onSubmit,
                onReturn: onReturn,
              ),
            ],
          );
        },
      ),
    );
  }
}
