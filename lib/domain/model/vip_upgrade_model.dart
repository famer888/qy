import 'product_vip_coin_model.dart';

class VipUpgradeModel {
  final Product? payed;
  final List<Product> goods;

  VipUpgradeModel({
    this.payed,
    required this.goods,
  });

  factory VipUpgradeModel.fromJson(Map<String, dynamic> json) {
    return VipUpgradeModel(
      payed: Product.fromJson(json['payed']),
      goods: List.from(
          json['goods']?.map((productJson) => Product.fromJson(productJson)) ??
              []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payed': payed?.toJson(),
      'goods': goods.map((product) => product.toJson()).toList(),
    };
  }
}
