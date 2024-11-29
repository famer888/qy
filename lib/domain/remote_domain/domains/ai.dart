import '../../enum.dart';
import '../../model/ai/ai_face_materials_with_banners_model.dart';
import '../../model/ai/ai_record_model.dart';
import '../../type_def.dart';

abstract class AIDomain {
  /// 换脸列表排序
  AsyncResult<AiFaceMaterialsWithBannersModel> faceMaterialList({
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
  AsyncResult<List<AiRecordModel>?> aIMyFace({
    required AiStatus status,
    required int page,
    required int limit,
  });

  ///我的脱衣记录
  AsyncResult<List<AiRecordModel>?> aIMyStrip({
    required AiStatus status,
    required int page,
    required int limit,
  });

  /// 删除我的脱衣记录
  AsyncResult delStrip({required String ids});

  /// 删除我的换脸记录
  AsyncResult delFace({required String ids});
}
