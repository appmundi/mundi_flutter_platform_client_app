part of "../register_page.dart";

class _BirthForm extends StatefulWidget {
  final VoidCallback onSubmit;
  final VoidCallback onReturn;
  const _BirthForm({
    required this.onReturn,
    required this.onSubmit,
  });

  @override
  State<_BirthForm> createState() => _BirthFormState();
}

class _BirthFormState extends State<_BirthForm> {
  final _dateController = DateRangePickerController();
  int selectedIndex = 0;
  late final List<int> years;
  DateTime? birthday;

  @override
  void initState() {
    super.initState();
    years = getYearsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultPadding(
        bgImagePath: 'assets/images/ellipses/register/registerEllipses5.png',
        child: Column(
          children: [
            MundiAppBar.darkTheme(
              showButton: true,
              onButtonPress: widget.onReturn,
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              "Qual sua data de \naniversário?",
              textAlign: TextAlign.center,
              style: context.textStyles.titleBold.copyWith(
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Selecione o ano, dia e mês que você nasceu.",
              style: context.textStyles.textRegular.copyWith(
                fontSize: 10,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Ano",
              style: context.textStyles.titleBold.copyWith(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 100,
              child: ListWheelScrollView(
                itemExtent: 30,
                onSelectedItemChanged: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
                children: getYearsList()
                    .map(
                      (year) => SizedBox(
                        width: 100,
                        child: Text(
                          "$year",
                          textAlign: TextAlign.center,
                          style: context.textStyles.titleBold.copyWith(
                            fontSize:
                                years.indexOf(year) == selectedIndex ? 18 : 14,
                            color: years.indexOf(year) == selectedIndex
                                ? context.colors.decorationPrimary
                                : Colors.black.withValues(alpha: .25),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CalendarPicker(
              controller: _dateController,
              onSelectionChanged: (b) {
                setState(() {
                  birthday = _dateController.selectedDate;
                });
              },
              maxDate: DateTime(years[selectedIndex], 12, 31),
              minDate: DateTime(years[selectedIndex], 1, 1),
            ),
            AppButton(
              text: 'Seguir',
              onPressed: birthday == null ? null : widget.onSubmit,
            ),
          ],
        ),
      ),
    );
  }

  List<int> getYearsList() {
    List<int> years = [];
    for (int i = DateTime.now().year; i > DateTime.now().year - 80; i--) {
      years.add(i);
    }
    return years;
  }
}
