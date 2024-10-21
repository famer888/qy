class BitNavModel {
  final int id;
  final String name;
  final int postCt;
  BitNavModel({required this.id, required this.name, required this.postCt});
  factory BitNavModel.fromJson(Map<String, dynamic> json) =>
      BitNavModel(id: json['id'], name: json['name'], postCt: json['post_ct']);
}
