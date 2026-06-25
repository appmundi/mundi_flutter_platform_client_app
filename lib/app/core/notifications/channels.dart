import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

abstract class AppChannels {
  static const String transactionalGroupKey = 'transactional';
  static const String marketingGroupKey = 'marketing';

  static const String dailyReminderChannelKey = 'daily_reminder_channel';
  static const String cancellationChannelKey = 'cancellation_channel';
  static const String serviceStepChannelKey = 'service_step_channel';
  static const String marketingChannelKey = 'marketing_channel';

  static List<NotificationChannelGroup> get groups => [
        NotificationChannelGroup(
          channelGroupKey: transactionalGroupKey,
          channelGroupName: 'Transacional',
        ),
        NotificationChannelGroup(
          channelGroupKey: marketingGroupKey,
          channelGroupName: 'Marketing',
        ),
      ];

  static List<NotificationChannel> get channels => [
        NotificationChannel(
          channelGroupKey: transactionalGroupKey,
          channelKey: dailyReminderChannelKey,
          channelName: 'Lembretes de Agendamento',
          channelDescription: 'Lembretes dos seus agendamentos do dia',
          importance: NotificationImportance.High,
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          playSound: true,
          enableVibration: true,
        ),
        NotificationChannel(
          channelGroupKey: transactionalGroupKey,
          channelKey: cancellationChannelKey,
          channelName: 'Cancelamentos',
          channelDescription: 'Alertas de agendamentos cancelados',
          importance: NotificationImportance.High,
          playSound: true,
          enableVibration: true,
        ),
        NotificationChannel(
          channelGroupKey: transactionalGroupKey,
          channelKey: serviceStepChannelKey,
          channelName: 'Progresso do Serviço',
          channelDescription: 'Atualizações em tempo real do seu serviço',
          importance: NotificationImportance.Max,
          playSound: false,
          enableVibration: false,
          locked: true,
        ),
        NotificationChannel(
          channelGroupKey: marketingGroupKey,
          channelKey: marketingChannelKey,
          channelName: 'Promoções e Novidades',
          channelDescription: 'Campanhas e novidades da Mundi',
          importance: NotificationImportance.Default,
          playSound: true,
        ),
      ];
}
