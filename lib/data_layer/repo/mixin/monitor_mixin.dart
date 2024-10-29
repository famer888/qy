part of '../repo.dart';

mixin _Monitor on _BaseAppRepo implements MonitorDomain {

  @override
  AsyncResult<MonitorWithBannersModel> getMonitorIndex({
    required int id,
    required int page,
    required int limit,
  }) =>
      _monitorService.getMonitorIndex(
        id: id,
        page: page,
        limit: limit
      ).deserializeJsonBy(MonitorWithBannersModel.fromJson).guard;

  @override
  AsyncResult<List<MonitorModel>?> getMonitorSearch({
    required String word,
    required int page,
    required int limit,
  }) => _monitorService.getMonitorSearch(
    word: word,
    page: page,
    limit: limit,
  ).deserializeJsonListBy((e) => e.map(MonitorModel.fromJson).toList()).guard;

  @override
  AsyncResult<MonitorVideoDetailData?> getMonitorDetail({required int id}) =>
      _monitorService.getMonitorDetail(id: id)
          .deserializeJsonBy(MonitorVideoDetailData.fromJson).guard;

  @override
  AsyncResult<List<MonitorModel>?> getMonitorRecommend({
    required int id,
    required int page,
    required int limit,
  }) => _monitorService.getMonitorRecommend(
    id: id,
    page: page,
    limit: limit,
  ).deserializeJsonListBy((e) => e.map(MonitorModel.fromJson).toList()).guard;

  @override
  AsyncResult getMonitorFavorite({required int id}) =>
      _monitorService.getMonitorFavorite(id: id).deserialize().guard;

  @override
  AsyncResult getMonitorBuy({required int id}) =>
      _monitorService.getMonitorBuy(id: id).deserialize().guard;

  @override
  AsyncResult<List<MonitorModel>?> getMonitorListFavorite({
    required int page,
    required int limit,
  }) => _monitorService.getMonitorListFavorite(
    page: page,
    limit: limit,
  ).deserializeJsonListBy((e) => e.map(MonitorModel.fromJson).toList()).guard;

  @override
  AsyncResult<List<MonitorModel>?> getMonitorListBuy({
    required int page,
    required int limit,
  }) => _monitorService.getMonitorListBuy(
    page: page,
    limit: limit,
  ).deserializeJsonListBy((e) => e.map(MonitorModel.fromJson).toList()).guard;

  @override
  AsyncResult getMonitorComment({
    required String text,
    required int id}) =>
      _monitorService.getMonitorComment(text: text, id: id).deserialize().guard;

  @override
  AsyncResult<List<VideoCommentListModel>?> getMonitorListComment({
    required int id,
    required int page,
    required int limit,
  }) => _monitorService.getMonitorListComment(
    id: id,
    page: page,
    limit: limit,
  ).deserializeJsonListBy((e) => e.map(VideoCommentListModel.fromJson).toList()).guard;

  @override
  AsyncResult getMonitorLikeComment({required int id}) =>
      _monitorService.getMonitorLikeComment(id: id).deserialize().guard;

  @override
  AsyncResult monitorLike({required int id}) =>
      _monitorService.monitorLike(id: id).deserialize().guard;
}
