import '../../domain/entities/prescription_item.dart';

class PrescriptionItemModel {
  final String id;
  final String drugName;
  final String? activeIngredient;
  final String? dose;
  final String? frequency;
  final String? route;
  final int? durationDays;
  final int? quantity;
  final String? instructions;

  const PrescriptionItemModel({
    required this.id,
    required this.drugName,
    this.activeIngredient,
    this.dose,
    this.frequency,
    this.route,
    this.durationDays,
    this.quantity,
    this.instructions,
  });

  factory PrescriptionItemModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionItemModel(
      id: json['id'] as String,
      drugName: json['drugName'] as String,
      activeIngredient: json['activeIngredient'] as String?,
      dose: json['dose'] as String?,
      frequency: json['frequency'] as String?,
      route: json['route'] as String?,
      durationDays: json['durationDays'] as int?,
      quantity: json['quantity'] as int?,
      instructions: json['instructions'] as String?,
    );
  }

  PrescriptionItem toEntity() {
    return PrescriptionItem(
      id: id,
      drugName: drugName,
      activeIngredient: activeIngredient,
      dose: dose,
      frequency: frequency,
      route: route,
      durationDays: durationDays,
      quantity: quantity,
      instructions: instructions,
    );
  }
}
