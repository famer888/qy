class BitSeedNavModel {
  final String title;
  final String type;
  BitSeedNavModel({required this.title, required this.type});
  factory BitSeedNavModel.fromJson(Map<String, dynamic> json) =>
      BitSeedNavModel(title: json['title'], type: json['type']);
}
