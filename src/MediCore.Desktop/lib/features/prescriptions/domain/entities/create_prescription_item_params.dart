class CreatePrescriptionItemParams {
  final String drugName;
  final String? activeIngredient;
  final String? dose;
  final String? frequency;
  final String? route;
  final int? durationDays;
  final int? quantity;
  final String? instructions;

  const CreatePrescriptionItemParams({
    required this.drugName,
    this.activeIngredient,
    this.dose,
    this.frequency,
    this.route,
    this.durationDays,
    this.quantity,
    this.instructions,
  });
}
