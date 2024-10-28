
import '../../../domain/type_def.dart';
import 'base_service.dart';

class AIService extends BaseService {
  AIService(super._dio);

  @override
  final service = 'ai';

  AsyncJson aIListFaceMaterial({
    required int id, // home/config中face_top_nav中的ID
    required int page,
    required int limit,
  }) =>
      post('/list_face_material', data: {'id': id, 'page': page, 'limit': limit});


  AsyncJson aIMyFace({
    required int status,// 0-待处理 1-处理中 2-已成功 3-已失败
    required int page,
    required int limit,
  }) => post('/my_face', data: {'status': status, 'page': page, 'limit': limit});

  AsyncJson aIMyStrip({
    required int status,// 0-待处理 1-处理中 2-已成功 3-已失败
    required int page,
    required int limit,
  }) => post('/my_strip', data: {'status': status, 'page': page, 'limit': limit});


  AsyncJson aIChangeFace({
    required int id,
    required String thumb,
    required int thumbW,
    required int thumbH,
  }) => post('/change_face', data: {'id': id, 'thumb': thumb, 'thumb_w': thumbW, 'thumb_h': thumbH});

  AsyncJson aICustomizeFace({
    required String ground,
    required int groundW,
    required int groundH,
    required String thumb,
    required int thumbW,
    required int thumbH,
  }) => post('/customize_face', data: {
    'ground': ground, 'ground_w': groundW, 'ground_h': groundH,
    'thumb': thumb, 'thumb_w': thumbW, 'thumb_h': thumbH});

  AsyncJson aIDelFace({
    required int id,
  }) => post('/del_face', data: {'id': id});

  AsyncJson aIDelStrip({
    required int id,
  }) => post('/del_strip', data: {'id': id});

  AsyncJson aIStrip({
    required String thumb,
    required int thumbW,
    required int thumbH,
  }) => post('/strip', data: {'thumb': thumb, 'thumb_w': thumbW, 'thumb_h': thumbH});

  /// 删除我的脱衣记录
  AsyncJson delStrip({required String ids}) =>
      post('/del_strip', data: {'ids': ids});

  /// 删除我的换脸记录
  AsyncJson delFace({required String ids}) =>
      post('/del_face', data: {'ids': ids});

}