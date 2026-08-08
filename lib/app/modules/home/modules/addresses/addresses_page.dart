import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/helpers/messages.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/colors_app.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/widgets/app_button.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/widgets/mundi_app_bar.dart';
import 'package:mundi_flutter_platform_client_app/app/models/address.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/addresses/cubit/addresses_cubit.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/addresses/cubit/addresses_state.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/addresses/widgets/address_form_field.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/addresses/widgets/address_label_chips.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/addresses/widgets/saved_address_card.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/cep_lookup/i_cep_lookup_repository.dart';

/// Argumentos de rota de `/home/addresses`.
///
/// `selectMode` distingue os dois pontos de entrada da tela: vindo da
/// reserva (true — tocar num card ou salvar devolve a seleção pra tela
/// anterior) ou vindo do perfil, "Meus Endereços" (false — tela de
/// gerenciamento simples, sem seleção).
class AddressesPageArguments {
  final bool selectMode;
  final int? currentAddressId;

  const AddressesPageArguments({
    this.selectMode = true,
    this.currentAddressId,
  });
}

class AddressesPage extends StatefulWidget {
  final bool selectMode;
  final int? currentAddressId;

  const AddressesPage({
    super.key,
    this.selectMode = true,
    this.currentAddressId,
  });

  @override
  State<AddressesPage> createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage>
    with Messages<AddressesPage> {
  final _cepController = TextEditingController();
  final _streetController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _numberController = TextEditingController();
  final _complementController = TextEditingController();
  final _customLabelController = TextEditingController();

  Address? _cepResult;
  String? _lastLookedUpCep;
  String? _selectedChipLabel;
  bool _saveToggle = true;
  bool _cepLoading = false;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    ReadContext(context).read<AddressesCubit>().load();
  }

  @override
  void dispose() {
    _cepController.dispose();
    _streetController.dispose();
    _neighborhoodController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _numberController.dispose();
    _complementController.dispose();
    _customLabelController.dispose();
    super.dispose();
  }

  Future<void> _onCepChanged(String value) async {
    final digits = value.replaceAll(RegExp(r'\D'), '');

    if (digits.length < 8) {
      // CEP incompleto: invalida a última busca sem tentar de novo ainda.
      if (_cepResult != null) {
        setState(() {
          _cepResult = null;
          _lastLookedUpCep = null;
        });
      }
      return;
    }

    if (digits == _lastLookedUpCep && _cepResult != null) return;
    _lastLookedUpCep = digits;

    setState(() => _cepLoading = true);
    final result =
        await Modular.get<ICepLookupRepository>().lookupCep(cep: value);
    if (!mounted) return;

    setState(() {
      _cepLoading = false;
      _cepResult = result;
      if (result != null) {
        _streetController.text = result.street;
        _neighborhoodController.text = result.neighborhood ?? '';
        _cityController.text = result.city;
        _stateController.text = result.state;
      } else {
        _cityController.clear();
        _stateController.clear();
      }
    });

    if (result == null) {
      showError('CEP não encontrado. Verifique e tente novamente.');
    }
  }

  String? get _resolvedLabel {
    if (_selectedChipLabel == null) return null;
    if (_selectedChipLabel == 'Casa' || _selectedChipLabel == 'Trabalho') {
      return _selectedChipLabel;
    }
    final custom = _customLabelController.text.trim();
    return custom.isEmpty ? null : custom;
  }

  Future<void> _onSubmit() async {
    if (_submitting) return;

    final street = _streetController.text.trim();
    final neighborhood = _neighborhoodController.text.trim();
    final number = _numberController.text.trim();

    if (_cepResult == null) {
      showError('Informe um CEP válido.');
      return;
    }
    if (street.isEmpty) {
      showError('Informe a rua.');
      return;
    }
    if (neighborhood.isEmpty) {
      showError('Informe o bairro.');
      return;
    }
    if (number.isEmpty) {
      showError('Informe o número.');
      return;
    }

    final address = Address(
      label: _resolvedLabel,
      zipCode: _cepResult!.zipCode,
      street: street,
      neighborhood: neighborhood,
      city: _cepResult!.city,
      state: _cepResult!.state,
      number: number,
      complement: _complementController.text.trim().isEmpty
          ? null
          : _complementController.text.trim(),
    );

    // Fora do modo de seleção (perfil → "Meus Endereços"), todo endereço
    // criado é salvo — não há pra onde devolver um endereço não persistido.
    final shouldPersist = !widget.selectMode || _saveToggle;

    if (!shouldPersist) {
      Modular.to.pop(address);
      return;
    }

    final cubit = ReadContext(context).read<AddressesCubit>();
    setState(() => _submitting = true);
    final created = await cubit.create(address);
    if (!mounted) return;
    setState(() => _submitting = false);

    if (created == null) {
      showError(cubit.state.errorMessage ?? 'Não foi possível salvar o endereço.');
      return;
    }

    if (widget.selectMode) {
      Modular.to.pop(created);
    } else {
      showSuccess('Endereço salvo!');
      _clearForm();
    }
  }

  void _clearForm() {
    _cepController.clear();
    _streetController.clear();
    _neighborhoodController.clear();
    _cityController.clear();
    _stateController.clear();
    _numberController.clear();
    _complementController.clear();
    _customLabelController.clear();
    setState(() {
      _cepResult = null;
      _lastLookedUpCep = null;
      _selectedChipLabel = null;
    });
  }

  Future<void> _confirmDelete(Address address) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Excluir endereço'),
        content: Text(
          'Remover "${(address.label?.isNotEmpty ?? false) ? address.label : address.street}" '
          'dos seus endereços salvos?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              'Excluir',
              style: TextStyle(
                color: Colors.red[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && address.id != null) {
      final cubit = ReadContext(context).read<AddressesCubit>();
      final ok = await cubit.delete(address.id!);
      if (!mounted) return;
      if (ok) {
        showSuccess('Endereço excluído.');
      } else {
        showError(cubit.state.errorMessage ?? 'Erro ao excluir o endereço.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<AddressesCubit, AddressesState>(
          builder: (context, state) {
            final isFirstLoad =
                state.status == AddressesStatus.loading && state.addresses.isEmpty;

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [
                MundiAppBar.darkTheme(
                  showButton: true,
                  onButtonPress: () => Modular.to.pop(),
                ),
                const SizedBox(height: 24),
                Text(
                  widget.selectMode
                      ? 'Endereço do atendimento'
                      : 'Meus Endereços',
                  style: context.textStyles.titleBold.copyWith(
                    fontSize: 21,
                    color: context.colors.primary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.selectMode
                      ? 'Escolha onde o serviço será realizado'
                      : 'Gerencie os endereços salvos na sua conta',
                  style: context.textStyles.textRegular.copyWith(
                    fontSize: 13,
                    color: context.colors.mutedText,
                  ),
                ),
                const SizedBox(height: 20),
                if (isFirstLoad)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else ...[
                  if (state.addresses.isNotEmpty) ...[
                    for (final address in state.addresses) ...[
                      SavedAddressCard(
                        address: address,
                        selected: widget.selectMode &&
                            address.id == widget.currentAddressId,
                        showSelectionIndicator: widget.selectMode,
                        onTap: widget.selectMode
                            ? () => Modular.to.pop(address)
                            : null,
                        onLongPress: () => _confirmDelete(address),
                      ),
                      const SizedBox(height: 12),
                    ],
                    Row(
                      children: [
                        Expanded(child: Divider(color: context.colors.border)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'OU USAR UM NOVO',
                            style: context.textStyles.textMedium.copyWith(
                              fontSize: 11,
                              color: context.colors.mutedText,
                              letterSpacing: .5,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: context.colors.border)),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                  _buildForm(context),
                ],
                const SizedBox(height: 28),
                AppButton(
                  text: widget.selectMode ? 'Usar este endereço' : 'Salvar endereço',
                  loading: _submitting,
                  onPressed: _submitting ? null : _onSubmit,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final labelChips = AddressLabelChips(
      selectedLabel: _selectedChipLabel,
      customLabelController: _customLabelController,
      onSelect: (label) => setState(() => _selectedChipLabel = label),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddressFormField(
          label: 'CEP',
          hintText: '00000-000',
          controller: _cepController,
          required: true,
          keyboardType: TextInputType.number,
          formatters: [
            MaskTextInputFormatter(
              mask: '#####-###',
              filter: {"#": RegExp(r'[0-9]')},
            ),
          ],
          onChanged: _onCepChanged,
        ),
        if (_cepLoading)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              'Buscando endereço...',
              style: context.textStyles.textRegular.copyWith(
                fontSize: 11,
                color: context.colors.mutedText,
              ),
            ),
          ),
        const SizedBox(height: 14),
        AddressFormField(
          label: 'Rua / Avenida',
          hintText: 'Ex.: Avenida Leopoldo Leão',
          controller: _streetController,
          required: true,
        ),
        const SizedBox(height: 14),
        AddressFormField(
          label: 'Bairro',
          hintText: 'Ex.: Centro',
          controller: _neighborhoodController,
          required: true,
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: AddressFormField(
                label: 'Cidade',
                hintText: '—',
                controller: _cityController,
                readOnly: true,
                required: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: AddressFormField(
                label: 'UF',
                hintText: '—',
                controller: _stateController,
                readOnly: true,
                required: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AddressFormField(
                label: 'Número',
                hintText: 'Nº',
                controller: _numberController,
                required: true,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: AddressFormField(
                label: 'Complemento',
                hintText: 'Apto, bloco, casa...',
                controller: _complementController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (widget.selectMode) ...[
          _buildSaveToggle(context),
          if (_saveToggle) ...[
            const SizedBox(height: 16),
            labelChips,
          ],
        ] else
          labelChips,
      ],
    );
  }

  Widget _buildSaveToggle(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: context.colors.border, width: .5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Salvar este endereço',
                  style: context.textStyles.textMedium.copyWith(
                    fontSize: 13,
                    color: context.colors.primary,
                  ),
                ),
                Text(
                  'Para usar nos próximos serviços',
                  style: context.textStyles.textRegular.copyWith(
                    fontSize: 11,
                    color: context.colors.mutedText,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _saveToggle,
            activeThumbColor: context.colors.secondary,
            onChanged: (value) => setState(() => _saveToggle = value),
          ),
        ],
      ),
    );
  }
}
