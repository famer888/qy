part of '../repo.dart';

mixin _AI on _BaseAppRepo implements AIDomain {
  @override
  AsyncResult<AIFaceMaterialsWithBannersModel> faceMaterialList({
    required int id,
    required int page,
    required int limit,
    required String sort,
    required String type,
  }) =>
      _aiService
          .faceMaterialList(
              id: id, page: page, limit: limit, sort: sort, type: type)
          .deserializeJsonBy(AIFaceMaterialsWithBannersModel.fromJson)
          .guard;

  @override
  AsyncResult changeFace({
    required int id,
    required String thumb,
    required int thumbW,
    required int thumbH,
  }) =>
      _aiService
          .changeFace(id: id, thumb: thumb, thumbW: thumbW, thumbH: thumbH)
          .deserialize()
          .guard;

  @override
  AsyncResult customizeFace({
    required String ground,
    required int groundW,
    required int groundH,
    required String thumb,
    required int thumbW,
    required int thumbH,
  }) =>
      _aiService
          .customizeFace(
              ground: ground,
              groundW: groundW,
              groundH: groundH,
              thumb: thumb,
              thumbW: thumbW,
              thumbH: thumbH)
          .deserialize()
          .guard;

  @override
  AsyncResult strip({
    required String thumb,
    required int thumbW,
    required int thumbH,
  }) =>
      _aiService
          .strip(thumb: thumb, thumbW: thumbW, thumbH: thumbH)
          .deserialize()
          .guard;

  @override
  AsyncResult<List<AIFaceMaterials>?> aIMyFace({
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
          .deserializeJsonListBy(
              (e) => e.map(AIFaceMaterials.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<AIFaceMaterials>?> aIMyStrip({
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
          .deserializeJsonListBy(
              (e) => e.map(AIFaceMaterials.fromJson).toList())
          .guard;

  @override
  AsyncResult delStrip({required String ids}) =>
      _aiService.delStrip(ids: ids).deserialize().guard;

  @override
  AsyncResult delFace({required String ids}) =>
      _aiService.delFace(ids: ids).deserialize().guard;
}
