class FittingMeasurement {
  final String id;
  final String clientName;
  final String clientPhone;
  final double chestCircumference; // Lingkar Dada
  final double waistCircumference; // Lingkar Pinggang
  final double height;             // Tinggi Badan
  final double shoulderWidth;      // Lebar Bahu
  final DateTime date;

  FittingMeasurement({
    required this.id,
    required this.clientName,
    required this.clientPhone,
    required this.chestCircumference,
    required this.waistCircumference,
    required this.height,
    required this.shoulderWidth,
    required this.date,
  });

  factory FittingMeasurement.fromFirestore(Map<String, dynamic> json, String id) {
    return FittingMeasurement(
      id: id,
      clientName: json['client_name'] ?? '',
      clientPhone: json['client_phone'] ?? '',
      chestCircumference: (json['chest_circumference'] ?? 0.0).toDouble(),
      waistCircumference: (json['waist_circumference'] ?? 0.0).toDouble(),
      height: (json['height'] ?? 0.0).toDouble(),
      shoulderWidth: (json['shoulder_width'] ?? 0.0).toDouble(),
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'client_name': clientName,
      'client_phone': clientPhone,
      'chest_circumference': chestCircumference,
      'waist_circumference': waistCircumference,
      'height': height,
      'shoulder_width': shoulderWidth,
      'date': date.toIso8601String(),
    };
  }
}
