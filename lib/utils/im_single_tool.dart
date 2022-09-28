import 'package:web_socket_channel/io.dart';

//IM 处理工具
class IMSingleTool {
  final channel = IOWebSocketChannel.connect(
    Uri.parse('wss://echo.websocket.org'),
  );
  static IMSingleTool _instance;
  IMSingleTool._internal();

  static IMSingleTool instance() {
    if (_instance == null) {
      _instance = IMSingleTool._internal();
    }
    return _instance;
  }

  void sendMsg() {}
}
