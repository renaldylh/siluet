class RentalOrder {
  final String id;
  final String clientName;
  final String clientPhone;
  final String attireId;
  final String attireName;
  final DateTime rentDate;   // Tanggal Keluar
  final DateTime returnDate; // Tanggal Masuk
  final String status;       // Disewa, Dikembalikan, Terlambat
  final int price;

  RentalOrder({
    required this.id,
    required this.clientName,
    required this.clientPhone,
    required this.attireId,
    required this.attireName,
    required this.rentDate,
    required this.returnDate,
    required this.status,
    required this.price,
  });

  factory RentalOrder.fromFirestore(Map<String, dynamic> json, String id) {
    return RentalOrder(
      id: id,
      clientName: json['client_name'] ?? '',
      clientPhone: json['client_phone'] ?? '',
      attireId: json['attire_id'] ?? '',
      attireName: json['attire_name'] ?? '',
      rentDate: json['rent_date'] != null ? DateTime.parse(json['rent_date']) : DateTime.now(),
      returnDate: json['return_date'] != null ? DateTime.parse(json['return_date']) : DateTime.now(),
      status: json['status'] ?? 'Disewa',
      price: json['price'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'client_name': clientName,
      'client_phone': clientPhone,
      'attire_id': attireId,
      'attire_name': attireName,
      'rent_date': rentDate.toIso8601String(),
      'return_date': returnDate.toIso8601String(),
      'status': status,
      'price': price,
    };
  }
}
