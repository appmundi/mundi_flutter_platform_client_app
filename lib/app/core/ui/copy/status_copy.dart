String labelForScheduleStatus(String status) {
  switch (status.toUpperCase()) {
    case 'RESERVED':
      return 'Agendado';
    case 'STARTED':
      return 'Em andamento';
    case 'ENDED':
      return 'Finalizado';
    case 'CANCELED':
      return 'Cancelado';
    case 'FEEDBACK':
      return 'Aguardando avaliação';
    default:
      return status;
  }
}

/// CTA text for the reserve confirmation button.
String ctaForOptionwork(bool optionwork) =>
    optionwork ? 'Confirmar visita' : 'Confirmar reserva';

/// Badge text shown to the client.
String clientAttendsLabel(bool optionwork) =>
    optionwork ? 'Atendimento em sua casa' : 'No estabelecimento';

/// Badge text shown to the freelancer.
String freelancerAttendsLabel(bool optionwork) =>
    optionwork ? 'Você vai até o cliente' : 'Cliente vem até você';
