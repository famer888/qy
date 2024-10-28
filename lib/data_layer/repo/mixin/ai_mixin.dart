part of '../repo.dart';

mixin _AI on _BaseAppRepo implements AIDomain {
  @override
  AsyncResult<AIWithBannersModel> aIListFaceMaterial({
    required int id,
    required int page,
    required int limit,
  }) =>
      _aiService
          .aIListFaceMaterial(
            id: id,
            page: page,
            limit: limit,
          )
          .deserializeJsonBy(AIWithBannersModel.fromJson)
          .guard;

  @override
  AsyncResult<List<AIModel>?> aIMyFace({
    required int status,
    required int page,
    required int limit,
  }) =>
      _aiService
          .aIMyFace(
            status: status,
            page: page,
            limit: limit,
          )
          .deserializeJsonListBy((e) => e.map(AIModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<AIModel>?> aIMyStrip({
    required int status,
    required int page,
    required int limit,
  }) =>
      _aiService
          .aIMyStrip(
            status: status,
            page: page,
            limit: limit,
          )
          .deserializeJsonListBy((e) => e.map(AIModel.fromJson).toList())
          .guard;

  @override
  AsyncResult aIChangeFace(
          {required int id,
          required String thumb,
          required int thumbW,
          required int thumbH}) =>
      _aiService
          .aIChangeFace(id: id, thumb: thumb, thumbW: thumbW, thumbH: thumbH)
          .deserialize()
          .guard;

  @override
  AsyncResult aICustomizeFace(
          {required String ground,
          required int groundW,
          required int groundH,
          required String thumb,
          required int thumbW,
          required int thumbH}) =>
      _aiService
          .aICustomizeFace(
              ground: ground,
              groundW: groundW,
              groundH: groundH,
              thumb: thumb,
              thumbW: thumbW,
              thumbH: thumbH)
          .deserialize()
          .guard;

  @override
  AsyncResult aIDelFace({required int id}) =>
      _aiService.aIDelFace(id: id).deserialize().guard;

  @override
  AsyncResult aIDelStrip({required int id}) =>
      _aiService.aIDelStrip(id: id).deserialize().guard;

  @override
  AsyncResult aIStrip(
          {required String thumb, required int thumbW, required int thumbH}) =>
      _aiService
          .aIStrip(thumb: thumb, thumbW: thumbW, thumbH: thumbH)
          .deserialize()
          .guard;

  @override
  AsyncResult delStrip({required String ids}) =>
      _aiService.delStrip(ids: ids).deserialize().guard;

  @override
  AsyncResult delFace({required String ids}) =>
      _aiService.delFace(ids: ids).deserialize().guard;
}
