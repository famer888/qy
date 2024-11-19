import '../../../domain/type_def.dart';
import 'base_service.dart';

class IndexService extends BaseService {
  IndexService(super._dio);

  @override
  final service = 'index';

  AsyncJson getRecommendVideosWithBanners({
    required int id,
    required int page,
    required int limit,
  }) =>
      post('/index', data: {
        'id': id,
        'page': page,
        'limit': limit,
      });

  //排序更多列表
  AsyncJson getMoreRecommendVideosBySort({
    required int id,
    required int limit,
    required int page,
  }) =>
      post(
        '/sort',
        data: {
          'id': id,
          'page': page,
          'limit': limit,
        },
      );

  //主题更多列表
  AsyncJson getMoreRecommendVideosByPart({
    required int id,
    required int limit,
    required int page,
    required String sort,
  }) =>
      post(
        '/part',
        data: {
          'id': id,
          'page': page,
          'limit': limit,
          'sort': sort,
        },
      );
}
