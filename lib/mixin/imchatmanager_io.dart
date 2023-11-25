// ignore_for_file: prefer_final_fields, prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qypj/global.dart';
import 'package:qypj/mixin/imchat_api.dart';
import 'package:qypj/model/homedata.dart';
import 'package:qypj/model/imchat_model.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/crypto.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/html.dart'; //运行web需要引入 否则注释掉
// import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class IMChatManagerIO {
  var _channel;
  Imstatus _state = Imstatus.closed;
  Timer _heartBeat; // 心跳定时器
  int _heartTimes = 3000; // 心跳间隔(毫秒)
  int _reconnectCount = 60; // 重连次数，默认60次
  int _reconnectTimes = 0; // 重连计数器
  Timer _reconnectTimer; // 重连定时器
  bool _isActiveClose = false; //是否手动关闭
  BuildContext _context = AppGlobal.appContext;
  Member user;

  Function(Map) receiveCall;
  Function wodeCall; //个人中心监听
  Function msgCall; //消息中心监听

  static final IMChatManagerIO _instance = IMChatManagerIO._();
  static IMChatManagerIO instance() => _instance;
  IMChatManagerIO._();

  //开启WebSocket连接
  void openSocket() {
    user = Provider.of<HomeConfig>(_context, listen: false).member;

    if (user?.chat?.line == null) return;
    if (_state == Imstatus.connected) return;
    closeSocket();
    _isActiveClose = false;

    if (kIsWeb) {
      //运行web需要引入 否则注释掉
      _channel = HtmlWebSocketChannel.connect(user?.chat?.line ?? "");
    } else {
      // _channel = IOWebSocketChannel.connect(user?.chat?.line ?? "");
    }
    CommonUtils.debugPrint('WebSocket连接成功: ${user?.chat?.line}');
    //连接成功，返回WebSocket实例
    _state = Imstatus.connected;
    //连接成功，重置重连计数器
    if (_reconnectTimer != null) {
      _reconnectTimes = 0;
      _reconnectTimer?.cancel();
      _reconnectTimer = null;
    }
    //接收消息
    _channel.stream.listen((data) => webSocketOnMessage(data),
        onError: webSocketOnError, onDone: webSocketOnDone);
    //发送心跳包
    initHeartBeat();
    //注册用户
    initUserIM();
  }

  //WebSocket接收消息回调
  webSocketOnMessage(data) async {
    String jsonstr = Uri.decodeComponent(data).toString();
    CommonUtils.debugPrint(jsonstr);
    //屏蔽心跳接口
    if (jsonstr.contains("pong")) return;

    Map dataMap = jsonDecode(data);
    Map matterMap = jsonDecode(await PlatformAwareCrypto.decryptResDataWithKey(
        dataMap, user?.chat?.key ?? "", user?.chat?.iv ?? ""));
    CommonUtils.debugPrint("decrypt data: $matterMap");
    if (dataMap["message_type"] == "chatMessage") {
      ChatMessage chat = ChatMessage();
      chat.nickname = Uri.encodeComponent(matterMap["nickname"]);
      chat.content = matterMap["content"];
      chat.type = 1;
      chat.content_type = matterMap["content_type"] == "photos" ? 1 : 0;
      chat.avatar = Uri.encodeComponent(matterMap["avatar"]);
      chat.time = matterMap["timestamp"].toString();
      chat.touser = ChatUser(
        nickname: Uri.encodeComponent(matterMap["nickname"]),
        avatar: Uri.encodeComponent(matterMap["avatar"]),
        uuid: matterMap["from_uuid"],
      );
      updateChatIM(chat);
      if (wodeCall != null) wodeCall?.call();
      if (msgCall != null) msgCall?.call();
      if (msgCall != null && receiveCall == null) CommonUtils.showMsgNoti(chat);
    } else if (dataMap["message_type"] == "unReadMessage") {
      ChatMessage chat = ChatMessage();
      chat.nickname = Uri.encodeComponent(matterMap["nickname"]);
      chat.content = matterMap["content"];
      chat.content_type = matterMap["content_type"] == "photos" ? 1 : 0;
      chat.type = 1;
      chat.avatar = Uri.encodeComponent(matterMap["avatar"]);
      chat.time = matterMap["created_at"].toString();
      chat.touser = ChatUser(
        nickname: Uri.encodeComponent(matterMap["nickname"]),
        avatar: Uri.encodeComponent(matterMap["avatar"]),
        uuid: matterMap["from_uuid"],
      );
      updateChatIM(chat);
      if (wodeCall != null) wodeCall?.call();
      if (msgCall != null) msgCall?.call();
      if (msgCall != null && receiveCall == null) CommonUtils.showMsgNoti(chat);
    } else {
      CommonUtils.debugPrint("other type data: $matterMap");
    }
    matterMap["message_type"] = dataMap["message_type"];
    if (receiveCall != null) receiveCall?.call(matterMap);
  }

  //获取本地im列表
  List<ChatList> getChats() {
    if (AppGlobal.chats?.get("imchats") == null) return [];
    List st = jsonDecode(AppGlobal.chats?.get("imchats"));
    List<ChatList> chats =
        List<ChatList>.from(st.map((x) => ChatList.fromJson(x)));
    return chats;
  }

  saveChats(List<ChatList> chats) {
    AppGlobal.chats?.put("imchats", jsonEncode(chats));
  }

  clearChats() {
    //清除IM数据
    AppGlobal.chats?.put("imchats", null);
  }

  removeChat(String touid) {
    List<ChatList> chats = getChats();
    chats.removeWhere((el) => el.id == "${user?.uuid}_$touid");
    saveChats(chats);
  }

  //更新chats列表
  updateChatIM(ChatMessage chat) {
    if (chat.touser?.uuid == "") return;
    List<ChatList> chats = getChats();
    ChatList child;
    for (var item in chats) {
      if (item.id == "${user?.uuid}_${chat.touser?.uuid}") {
        child = item;
        break;
      }
    }
    if (child == null) {
      ChatList tp = ChatList();
      tp.id = "${user?.uuid}_${chat.touser?.uuid}";
      tp.touser = chat.touser;
      if (tp.list == null) {
        tp.list = [];
        tp.list?.add(ChatMessage.fromJson(chat.toJson()));
      } else {
        tp.list?.add(ChatMessage.fromJson(chat.toJson()));
      }
      //处理未读消息 只针对他人
      if (chat.type == 1) tp.count = 1;
      //save
      chats.add(ChatList.fromJson(tp.toJson()));
    } else {
      if (chat.type == 1) child.count = (child.count ?? 0) + 1;
      //save
      child.list?.add(ChatMessage.fromJson(chat.toJson()));
    }
    CommonUtils.debugPrint("======updateChatIM==$chats");
    saveChats(chats);
  }

  //WebSocket关闭连接回调
  webSocketOnDone() {
    CommonUtils.debugPrint('closed');
    _state = Imstatus.closed;
    if (!_isActiveClose) reconnect();
  }

  //WebSocket连接错误回调
  webSocketOnError(e) {
    WebSocketChannelException ex = e;
    _state = Imstatus.failed;
    CommonUtils.debugPrint(ex.message);
    closeSocket();
  }

  //初始化心跳
  void initHeartBeat() {
    destroyHeartBeat();
    _heartBeat = Timer.periodic(Duration(milliseconds: _heartTimes), (timer) {
      sentHeart();
    });
  }

  //心跳
  void sentHeart() {
    sendMessage(Ichatapi.ping);
  }

  //注册用户
  void initUserIM() {
    sendMessage(Ichatapi.initUser);
  }

  //销毁心跳
  void destroyHeartBeat() {
    if (_heartBeat != null) {
      _heartBeat?.cancel();
      _heartBeat = null;
    }
  }

  //关闭WebSocket
  void closeSocket() {
    if (_channel != null) {
      CommonUtils.debugPrint('WebSocket连接关闭');
      _channel.sink.close();
      destroyHeartBeat();
      _state = Imstatus.closed;
    }
  }

  //手动关闭WebSocket 不再重链
  void activeClose() {
    _isActiveClose = true;
    closeSocket();
    clearChats();
  }

  //发送WebSocket消息
  Future<void> sendMessage(Ichatapi t, {Map req}) async {
    if (_state != Imstatus.connected) {
      //发送消息前先检测是否链接
      CommonUtils.showText(CommonUtils.txt('sqljzcl'));
      openSocket();
      return;
    }
    if (_channel != null) {
      switch (_state) {
        case Imstatus.connected:
          String strdata = jsonEncode(
              await Ichatapiparams.apiTypeForParams(_context, t, request: req));
          CommonUtils.debugPrint('发送中：$strdata  参数：$req');
          _channel.sink.add(strdata);
          if (t == Ichatapi.chat) {
            ChatMessage chat = ChatMessage();
            chat.nickname = Uri.encodeComponent(user?.nickname ?? "");
            chat.content = req["content"];
            chat.type = 0;
            chat.content_type = req["msgType"] == "photos" ? 1 : 0;
            chat.avatar = Uri.encodeComponent(user?.thumb ?? "");
            chat.time = (DateTime.now().millisecondsSinceEpoch / 1000)
                .floor()
                .toString();
            chat.touser = ChatUser(
              avatar: Uri.encodeComponent(req["thumb"] ?? ""),
              nickname: Uri.encodeComponent(req["nickname"]),
              uuid: req["to_uuid"],
            );
            updateChatIM(chat);
          }
          return Future(() {});
        case Imstatus.closed:
          CommonUtils.debugPrint('连接已关闭');
          return Future(() {});
        case Imstatus.failed:
          CommonUtils.debugPrint('发送失败');
          return Future(() {});
        default:
          break;
      }
    }
  }

  //重连机制
  void reconnect() {
    if (_reconnectTimes < _reconnectCount) {
      _reconnectTimes++;
      _reconnectTimer =
          Timer.periodic(Duration(milliseconds: _heartTimes), (timer) {
        openSocket();
      });
    } else {
      if (_reconnectTimer != null) {
        CommonUtils.debugPrint('重连次数超过最大次数');
        _reconnectTimer?.cancel();
        _reconnectTimer = null;
      }
      return;
    }
  }
}
