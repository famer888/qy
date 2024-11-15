class BankCardModel {
  final int? id;
  final int? aff;
  final int? isDefault;
  final String? bank;
  final String? card;
  final String? cardType;
  final String? name;
  final String? ip;
  final String? createdAt;
  final String? updatedAt;

  BankCardModel({
    required this.id,
    required this.aff,
    required this.isDefault,
    required this.bank,
    required this.card,
    required this.cardType,
    required this.name,
    required this.ip,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BankCardModel.fromJson(Map<String, dynamic> json) => BankCardModel(
        id: json['id'],
        aff: json['aff'],
        isDefault: json['is_default'],
        bank: json['bank'],
        card: json['card'],
        cardType: json['card_type'],
        name: json['name'],
        ip: json['ip'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );
}
