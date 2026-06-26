import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/extension/date_time_extension.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/extension/double_extension.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/extension/size_screen_extension.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/extension/string_extension.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/helpers/messages.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/colors_app.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/widgets/app_button.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/widgets/calendar_picker.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/widgets/reserve_modal.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/widgets/reserve_tile.dart';
import 'package:mundi_flutter_platform_client_app/app/models/entrepreneur.dart';
import 'package:mundi_flutter_platform_client_app/app/models/modality.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/entrepreneur/modules/reserve/widgets/add_services_dialog.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/entrepreneur/modules/reserve/widgets/text_area.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'cubit/reserve_cubit.dart';
import 'cubit/reserve_state.dart';
import 'widgets/available_times_input.dart';

class ReservePageArguments {
  final Modality modality;
  final int entrepreneurId;
  final Entrepreneur entrepreneur;

  ReservePageArguments({
    required this.entrepreneurId,
    required this.modality,
    required this.entrepreneur,
  });
}

class ReservePage extends StatefulWidget {
  final ReservePageArguments reservePageArguments;

  const ReservePage({super.key, required this.reservePageArguments});

  @override
  State<ReservePage> createState() => _ReservePageState();
}

class _ReservePageState extends State<ReservePage> with Messages<ReservePage> {
  final descriptionController = TextEditingController();

  // Controladores para os campos de endereço
  final zipCodeController = TextEditingController();
  final numberController = TextEditingController();
  final complementController = TextEditingController();

  late final _dateController = DateRangePickerController();
  List<String> availablesTimes = [];
  String selectedTime = '';
  late List<Modality> modalities = [widget.reservePageArguments.modality];

  @override
  void initState() {
    super.initState();
    _dateController.selectedDate = DateTime.now();
    _loadAvailableTimes();
  }

  void _loadAvailableTimes() {
    final selectedDate = _dateController.selectedDate!;
    final duration = modalities
        .map((modality) => modality.getDuration())
        .reduce((a, b) => a + b);
    final formattedDate = selectedDate.toIso8601String().split('T').first;
    ReadContext(context).read<ReserveCubit>().checkHour(
      entrepreneurId: widget.reservePageArguments.entrepreneurId,
      date: formattedDate,
      duration: duration,
    );
  }

  Entrepreneur get entrepreneur => widget.reservePageArguments.entrepreneur;

  void onAddModalities() async {
    final addedModalities =
    await showDialog(
      context: context,
      builder: (context) {
        return AddServicesDialog(entrepreneur: entrepreneur);
      },
    )
    as List<Modality>?;
    if (addedModalities == null) {
      return;
    }

    setState(() {
      modalities = [widget.reservePageArguments.modality, ...addedModalities];
    });
    selectedTime = '';
    _loadAvailableTimes();
  }

  void _removeModality(int index) {
    setState(() {
      modalities.removeAt(index);
    });
  }

  Widget _buildAdditionalModalitiesContainer() {
    final additionalModalities = modalities.skip(1).toList();

    return Container(
      width: .8.sw,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.secondary, width: .5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (additionalModalities.isEmpty)
            Text(
              "Adicione mais serviços",
              style: context.textStyles.titleBold.copyWith(fontSize: 10),
            )
          else ...[
            Text(
              "Serviços adicionais:",
              style: context.textStyles.titleBold.copyWith(
                fontSize: 10,
                color: context.colors.secondary,
              ),
            ),
            const SizedBox(height: 10),
            ...additionalModalities.asMap().entries.map((entry) {
              final index = entry.key + 1;
              final modality = entry.value;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: context.colors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            modality.title,
                            style: context.textStyles.titleBold.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                modality.getPrice(),
                                style: context.textStyles.titleBold.copyWith(
                                  fontSize: 9,
                                  color: context.colors.secondary,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "${modality.getDuration()} MIN",
                                style: context.textStyles.titleBold.copyWith(
                                  fontSize: 9,
                                  color: context.colors.secondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _removeModality(index),
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: context.colors.secondary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ],
      ),
    );
  }

// Substitua o método _buildAddressFields() por este:
  Widget _buildAddressFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Endereço do atendimento",
          style: context.textStyles.titleBold.copyWith(
            fontSize: 16,
            color: context.colors.primary,
          ),
        ),
        const SizedBox(height: 20),

        // CEP e Número na mesma linha
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildAddressTextField(
                label: "CEP *",
                hintText: "00000-000",
                controller: zipCodeController,
                formatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(8),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              flex: 1,
              child: _buildAddressTextField(
                label: "Número *",
                hintText: "Nº",
                controller: numberController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),

        // Complemento
        _buildAddressTextField(
          label: "Complemento",
          hintText: "Apto, bloco, casa, etc. (opcional)",
          controller: complementController,
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  bool _validateAddressFields() {
    if (!entrepreneur.optionwork) return true;

    bool isValid = true;

    if (zipCodeController.text.trim().isEmpty) {
      showError("CEP é obrigatório");
      isValid = false;
    } else if (zipCodeController.text.trim().length < 8) {
      showError("CEP deve ter 8 dígitos");
      isValid = false;
    }

    if (numberController.text.trim().isEmpty) {
      showError("Número é obrigatório");
      isValid = false;
    }

    return isValid;
  }


  Widget _buildAddressTextField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    List<TextInputFormatter>? formatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textStyles.titleBold.copyWith(
            fontSize: 10,
            color: context.colors.darkGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: context.colors.secondary, width: .5),
            borderRadius: BorderRadius.circular(15),
          ),
          height: 45,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextField(
              controller: controller,
              inputFormatters: formatters,
              style: context.textStyles.textRegular.copyWith(
                fontSize: 12,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                errorBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                hintText: hintText,
                hintStyle: context.textStyles.textRegular.copyWith(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReserveCubit, ReserveState>(
      listener: (context, state) {
        state.status.matchAny(
          any: () {},
          loaded: () {
            availablesTimes = state.checkHour!;
          },
          success: () async {
            final [hour, minute] =
                selectedTime.getHourAndMinuteFromAppTimeFormat;
            await ReserveModal.show(
              context,
              modalities,
              _dateController.selectedDate!.fillHourAndMinute(hour, minute),
            );
            Modular.to.popUntil(
              ModalRoute.withName('/home/'),
            ); // Atualiza a lista de horários disponíveis
            setState(() {}); // Atualiza a interface
          },
          error: () {
            showError(
              state.errorMessage ?? "Ops, Algo de inesperado aconteceu!",
            );
          },
        );
      },
      builder:
          (context, state) => Scaffold(
        appBar: AppBar(
          title: Image.asset('assets/images/dark_logo.png', height: 32),
          automaticallyImplyLeading: false,
          centerTitle: false,
        ),
        body: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20)
                  .copyWith(bottom: 120),
              children: [
                SizedBox(
                  height: 30,
                  child: Center(
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Modular.to.pop();
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: context.colors.secondary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "Fazer uma reserva",
                          style: context.textStyles.titleBold.copyWith(
                            color: context.colors.primary,
                            fontSize: 20,
                            height: .7,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    DateTime.now().year.toString(),
                    style: context.textStyles.titleBold.copyWith(
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CalendarPicker(
                  controller: _dateController,
                  minDate: DateTime.now(),
                  onSelectionChanged: (args) {
                    _loadAvailableTimes();
                  },
                ),
                const SizedBox(height: 20),
                AvailableTimesInput(
                  availablesTimes: availablesTimes,
                  onSelectTime: (time) {
                    setState(() {
                      selectedTime = time;
                    });
                  },
                  selectedTime: selectedTime,
                ),
                const SizedBox(height: 30),
                ReserveTile(
                  modality: widget.reservePageArguments.modality,
                  selectedTime: selectedTime,
                  selectedDate: _dateController.selectedDate!,
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: onAddModalities,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.add,
                        size: 25,
                        color: context.colors.secondary,
                      ),
                      _buildAdditionalModalitiesContainer(),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Campos de endereço (apenas se entrepreneur.optionwork == 1)
                if (entrepreneur.optionwork) ...[
                  _buildAddressFields(),
                ],

                TextArea(controller: descriptionController),
                const SizedBox(height: 20),
              ],
            ),
            Positioned(
              bottom: 20,
              child: Container(
                width: 1.sw,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 15,
                ),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          modalities
                              .map((modality) => modality.price)
                              .reduce((a, b) => a + b)
                              .currency,
                          style: context.textStyles.titleBold.copyWith(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "${modalities.map((modality) => modality.getDuration()).reduce((a, b) => a + b)} MIN",
                          style: context.textStyles.titleBold.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    AppButton(
                      width: .43.sw,
                      text: 'Reservar',
                      onPressed: () async {
                        if (selectedTime.isEmpty) {
                          showError('Escolha um horário para atendimento!');
                          return;
                        }

                        if (!_validateAddressFields()) {
                          return;
                        }

                        final [hour, minute] =
                            selectedTime.getHourAndMinuteFromAppTimeFormat;

                        // Monta data/hora no formato local selecionado pelo usuário
                        final localDateTime = _dateController.selectedDate!
                            .fillHourAndMinute(hour, minute);

                        ReadContext(context).read<ReserveCubit>().createReserve(
                          entrepreneurId: widget.reservePageArguments.entrepreneurId,
                          modalityIds: modalities.map((modality) => modality.id).toList(),
                          // Envia sempre em UTC para evitar variação por timezone do servidor
                          scheduledDate: localDateTime.toUtc().toIso8601String(),
                          description: descriptionController.text,
                          address: entrepreneur.optionwork ? {
                            'number': numberController.text.trim(),
                            'zipCode': zipCodeController.text.trim(),
                            'complement': complementController.text.trim(),
                          } : null,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}