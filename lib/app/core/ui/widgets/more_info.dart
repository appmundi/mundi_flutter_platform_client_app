import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mundi_flutter_platform_client_app/app/core/helpers/environments.dart';
import 'package:mundi_flutter_platform_client_app/app/core/rest/http/http_rest_client.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/copy/status_copy.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/extension/date_time_extension.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/colors_app.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/widgets/app_button.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/widgets/reserve_tile.dart';
import 'package:mundi_flutter_platform_client_app/app/models/reservation.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/schedule/schedule_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreInfoModal {
  static Future<void> show(BuildContext context, Reservation reservation) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => _ModalContent(reservation: reservation),
    );
  }
}

class _ModalContent extends StatelessWidget {
  final Reservation reservation;

  const _ModalContent({required this.reservation});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildHeader(context),
          const SizedBox(height: 15),
          _buildScheduleInfo(context),
          const SizedBox(height: 15),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      child: Text(
        'Informações gerais',
        textAlign: TextAlign.left,
        style: context.textStyles.titleBold.copyWith(
          fontSize: 20,
          decoration: TextDecoration.none,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildScheduleInfo(BuildContext context) {
    final isAtHome = reservation.optionwork;
    final badgeBg = isAtHome
        ? context.colors.atHomeBadgeBg
        : context.colors.atVenueBadgeBg;
    final badgeFg = isAtHome
        ? context.colors.atHomeBadgeFg
        : context.colors.atVenueBadgeFg;
    final badgeIcon =
        isAtHome ? Icons.home_work_outlined : Icons.storefront_outlined;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFF2F2F2)),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(badgeIcon, size: 14, color: badgeFg),
                const SizedBox(width: 6),
                Text(
                  clientAttendsLabel(isAtHome),
                  style: context.textStyles.textRegular.copyWith(
                    color: badgeFg,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ReserveTile(
            modality: reservation.modality,
            selectedDate: reservation.startAt,
            selectedTime: reservation.startAt.appTimeFormat,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: AppButton(
            text: 'Chat',
            onPressed: () => _openWhatsApp(context),
          ),
        ),
        const SizedBox(height: 15),
        Align(
          alignment: Alignment.center,
          child: AppButton(
            text: 'Ver Loja',
            onPressed: () {
              Modular.to.pushNamed(
                '/home/entrepreneur/',
                arguments: reservation.entrepreneurId,
              );
            },
          ),
        ),
        const SizedBox(height: 15),
        Align(
          alignment: Alignment.center,
          child: AppButton(
            text: 'Cancelar agendamento',
            onPressed: () => _showCancelDialog(context),
          ),
        ),
      ],
    );
  }

  Future<void> _openWhatsApp(BuildContext context) async {
    const message =
        'Olá, estou entrando em contato através do aplicativo da mundi.';
    final encoded = Uri.encodeComponent(message);
    final url = Uri.parse(
      'https://wa.me/+55${reservation.entrepreneurPhone}?text=$encoded',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
    if (context.mounted) Navigator.pop(context);
  }

  Future<void> _showCancelDialog(BuildContext context) async {
    final shouldCancel = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirmar cancelamento'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16),
            Text('Deseja cancelar o agendamento?'),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Não'),
            onPressed: () => Navigator.of(dialogContext).pop(false),
          ),
          TextButton(
            child: const Text('Sim'),
            onPressed: () => Navigator.of(dialogContext).pop(true),
          ),
        ],
      ),
    );

    if (shouldCancel == true) {
      await _cancelSchedule(context);
      if (context.mounted) Navigator.pop(context);
    }
  }

  Future<void> _cancelSchedule(BuildContext context) async {
    try {
      final repo = ScheduleRepository(
        rest: HttpRestClient(baseUrl: Environments.get('BASE_URL') ?? ''),
      );
      await repo.cancelSchedule(reservation.scheduleId);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao cancelar agendamento'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
