import '../../model/ai/ai_model.dart';
import '../../type_def.dart';

abstract class AIDomain {
  /// 换脸列表排序
  AsyncResult<AIFaceMaterialsWithBannersModel> faceMaterialList({
    required int id,
    required int page,
    required int limit,
    required String sort,
    required String type,
  });

  AsyncResult changeFace({
    required int id,
    required String thumb,
    required int thumbW,
    required int thumbH,
  });

  AsyncResult customizeFace({
    required String ground,
    required int groundW,
    required int groundH,
    required String thumb,
    required int thumbW,
    required int thumbH,
  });

  AsyncResult strip({
    required String thumb,
    required int thumbW,
    required int thumbH,
  });

  ///我的换脸记录
  AsyncResult<List<AIFaceMaterials>?> aIMyFace({
    required int status, // 0-待处理 1-处理中 2-已成功 3-已失败
    required int page,
    required int limit,
  });

  ///我的脱衣记录
  AsyncResult<List<AIFaceMaterials>?> aIMyStrip({
    required int status, // 0-待处理 1-处理中 2-已成功 3-已失败
    required int page,
    required int limit,
  });

  /// 删除我的脱衣记录
  AsyncResult delStrip({required String ids});

  /// 删除我的换脸记录
  AsyncResult delFace({required String ids});
}
