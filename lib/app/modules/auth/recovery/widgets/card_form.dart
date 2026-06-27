part of '../recovery_password_page.dart';

class _CardForm extends StatefulWidget {
  final String label;
  final String bgImagePath;
  final TextEditingController controller;
  final VoidCallback onSubmit;
  final VoidCallback onReturn;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final bool obscureText;
  final String? hintText;
  const _CardForm({
    required this.label,
    required this.bgImagePath,
    required this.controller,
    required this.onSubmit,
    required this.onReturn,
    this.inputFormatters,
    this.validator,
    this.hintText,
    this.obscureText = false,
  });

  @override
  State<_CardForm> createState() => _CardFormState();
}

class _CardFormState extends State<_CardForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return DefaultPadding(
      bgImagePath: widget.bgImagePath,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            MundiAppBar(showButton: true, onButtonPress: widget.onReturn),
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.only(
                  top: 30,
                  bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
                ),
                child: CardRegister(
                  label: widget.label,
                  onSubmit: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onSubmit();
                    }
                  },
                  hintText: widget.hintText,
                  obscureText: widget.obscureText,
                  controller: widget.controller,
                  inputFormatters: widget.inputFormatters,
                  validator: widget.validator,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
