class OfficialGroupModel {
  final OfficeGroupDataListModel? officeContact;

  OfficialGroupModel({this.officeContact});

  OfficialGroupModel.fromJson(Map<String, dynamic> json)
      : officeContact = json['office_contact'] != null
            ? OfficeGroupDataListModel.fromJson(json['office_contact'])
            : null;
}

class OfficeGroupDataListModel {
  final List<OfficeGroupDataModel>? data;

  OfficeGroupDataListModel({this.data});

  OfficeGroupDataListModel.fromJson(Map<String, dynamic> json)
      : data = json['data'] != null
            ? List.from(
                json['data'].map((e) => OfficeGroupDataModel.fromJson(e)))
            : null;
}

class OfficeGroupDataModel {
  final String? name;
  final String? decs;
  final List<OfficeGroupContactModel>? list;

  OfficeGroupDataModel({
    this.name,
    this.decs,
    this.list,
  });

  OfficeGroupDataModel.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String?,
        decs = json['decs'] as String?,
        list = json['list'] != null
            ? List.from(
                json['list'].map((e) => OfficeGroupContactModel.fromJson(e)))
            : null;
}

class OfficeGroupContactModel {
  final String? name;
  final String? decs;
  final String? type;
  final String? url;

  OfficeGroupContactModel({
    this.name,
    this.decs,
    this.type,
    this.url,
  });

  OfficeGroupContactModel.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String?,
        decs = json['decs'] as String?,
        type = json['type'] as String?,
        url = json['url'] as String?;
}
