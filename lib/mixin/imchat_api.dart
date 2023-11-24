import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qypj/global.dart';
import 'package:qypj/model/homedata.dart';
import 'package:qypj/model/imchat_model.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/crypto.dart';
import 'package:provider/provider.dart';

enum Imstatus { connected, failed, closed }

enum Ichattype { photos, text }

enum Ichatapi {
  initUser,
  ping,
  chat,
  messageLog,
  queryOnline,
  updateChatList,
  getChatList,
}

extension Ichatapiparams on Ichatapi {
  static Future<Map> apiTypeForParams(BuildContext context, Ichatapi type,
      {Map request}) async {
    Member user = Provider.of<HomeConfig>(context, listen: false).member;
    ImChatModel chat = user?.chat;
    if (chat == null) {
      return Future(() {
        return {};
      });
    }

    Map dict = {"encrypt": "self", "via": chat.via, "token": chat.token};
    Map data = {};
    switch (type) {
      case Ichatapi.ping:
        dict["route"] = "chat/ping";
        break;
      case Ichatapi.initUser:
        dict["route"] = "chat/initUser";
        data = {
          "uuid": user?.uuid,
          "phone": user?.username,
          "nickname": user?.nickname,
          "oauth_type": AppGlobal.appinfo["oauth_type"],
          "oauth_id": AppGlobal.appinfo["oauth_id"],
          "avatar": user?.thumb,
        };
        break;
      case Ichatapi.chat:
        dict["route"] = "chat/chat";
        data = {
          "to_uuid": request["to_uuid"],
          "type": "friend",
          "msgType": request["msgType"],
          "content": request["content"],
          "microtime": (DateTime.now().millisecondsSinceEpoch / 1000).floor(),
        };
        break;
      case Ichatapi.messageLog:
        dict["route"] = "chat/msgLog";
        data = {
          "to_id": request["to_id"],
          "type": "friend",
        };
        break;
      case Ichatapi.queryOnline:
        dict["route"] = "chat/isOnline";
        data = {"to_uuid": request["to_uuid"]};
        break;
      case Ichatapi.updateChatList:
        dict["route"] = "chat/updateChatList";
        data = {"content": request["content"]};
        break;
      case Ichatapi.getChatList:
        dict["route"] = "chat/getChatList";
        break;
    }
    CommonUtils.debugPrint('原始参数：$data');
    dict["data"] = await PlatformAwareCrypto.encryptReqParamsWithKey(
        jsonEncode(data), chat.key ?? "", chat.iv ?? "");
    return dict;
  }
}
