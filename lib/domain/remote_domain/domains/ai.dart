import '../../model/ai/ai_model.dart';
import '../../type_def.dart';

abstract class AIDomain {
  ///换脸素材列表
  AsyncResult<AIWithBannersModel?> aIListFaceMaterial({
    required int id, // home/config中face_top_nav中的ID
    required int page,
    required int limit,
  });

  ///我的换脸记录
  AsyncResult<List<AIModel>?> aIMyFace({
    required int status, // 0-待处理 1-处理中 2-已成功 3-已失败
    required int page,
    required int limit,
  });

  ///我的脱衣记录
  AsyncResult<List<AIModel>?> aIMyStrip({
    required int status, // 0-待处理 1-处理中 2-已成功 3-已失败
    required int page,
    required int limit,
  });

  ///素材换脸
  AsyncResult aIChangeFace({
    required int id,
    required String thumb,
    required int thumbW,
    required int thumbH,
  });

  ///自定义换脸
  AsyncResult aICustomizeFace({
    required String ground,
    required int groundW,
    required int groundH,
    required String thumb,
    required int thumbW,
    required int thumbH,
  });

  ///删除我的换脸记录
  AsyncResult aIDelFace({
    required int id,
  });

  ///删除我的脱衣记录
  AsyncResult aIDelStrip({
    required int id,
  });

  ///脱衣
  AsyncResult aIStrip({
    required String thumb,
    required int thumbW,
    required int thumbH,
  });

  /// 删除我的脱衣记录
  AsyncResult delStrip({required String ids});

  /// 删除我的换脸记录
  AsyncResult delFace({required String ids});
}
