part of '../register_page.dart';

class _CategoryForm extends StatefulWidget {
  final VoidCallback onSubmit;
  final VoidCallback onReturn;

  const _CategoryForm({
    required this.onSubmit,
    required this.onReturn,
  });

  @override
  State<_CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<_CategoryForm> {
  Map<String, bool> categories = {
    'barber': false,
    'beauty': false,
    'manicure': false,
    'makeup': false,
    'health': false,
    'aesthetics': false,
  };

  @override
  Widget build(BuildContext context) {
    return DefaultPadding(
      bgImagePath: 'assets/images/ellipses/register/registerEllipses6.png',
      child: Column(
        children: [
          MundiAppBar(
            showButton: true,
            onButtonPress: widget.onReturn,
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: .1,
              ),
              borderRadius: BorderRadius.circular(40),
            ),
            child: BlurryContainer(
              color: const Color.fromRGBO(11, 22, 70, .2),
              blur: 30,
              width: .87.sw,
              height: 120,
              elevation: 1,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              borderRadius: BorderRadius.circular(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Quais tipos de serviços você mais se interessa?",
                    textAlign: TextAlign.center,
                    style: context.textStyles.titleBold.copyWith(
                      fontSize: 25,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Escolha entre 1 e 3 serviços para exibirmos na sua tela inicial.",
            style: context.textStyles.textMedium
                .copyWith(color: Colors.white, fontSize: 8,),),
          const SizedBox(
            height: 20,
          ),
          CategoryCheckbox(
            text: 'Barbearia',
            value: categories['barber']!,
            onChanged: (bool? value) {
              setState(() {
                categories['barber'] = value ?? false;
              });
            },
          ),
          const SizedBox(
            height: 15,
          ),
          CategoryCheckbox(
            text: 'Salão de Beleza',
            value: categories['beauty']!,
            onChanged: (bool? value) {
              setState(() {
                categories['beauty'] = value ?? false;
              });
            },
          ),
          const SizedBox(
            height: 15,
          ),
          CategoryCheckbox(
            text: 'Manicure',
            value: categories['manicure']!,
            onChanged: (bool? value) {
              setState(() {
                categories['manicure'] = value ?? false;
              });
            },
          ),
          const SizedBox(
            height: 15,
          ),
          CategoryCheckbox(
            text: 'Makeup',
            value: categories['makeup']!,
            onChanged: (bool? value) {
              setState(() {
                categories['makeup'] = value ?? false;
              });
            },
          ),
          const SizedBox(
            height: 15,
          ),
          CategoryCheckbox(
            text: 'Saúde e Bem-estar',
            value: categories['health']!,
            onChanged: (bool? value) {
              setState(() {
                categories['health'] = value ?? false;
              });
            },
          ),
          const SizedBox(
            height: 15,
          ),
          CategoryCheckbox(
            text: 'Estética',
            value: categories['aesthetics']!,
            onChanged: (bool? value) {
              setState(() {
                categories['aesthetics'] = value ?? false;
              });
            },
          ),
          const SizedBox(
            height: 20,
          ),
          AppButton(
            width: .85.sw,
            text: 'Seguir',
            onPressed: widget.onSubmit,
          )
        ],
      ),
    );
  }
}
