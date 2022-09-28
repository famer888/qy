/*
 * @Author: Tom
 * @Date: 2021-12-28 09:46:10
 * @LastEditTime: 2021-12-28 10:01:36
 * @LastEditors: Tom
 * @Description: 
 * @FilePath: /flutter2021/lib/utils/download_comics.dart
 */
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:qypj/utils/crypto.dart';
import 'package:hive/hive.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/index.dart';
import 'package:qypj/utils/logUtil.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadComics {
  static List downloadTasks = []; // 下载任务队列
  static bool downloading = false; // 是否存在下载任务
  static int finishCount = 0; // 当前下载完成的章节数量
  static bool creating = false; // 防止连点
  static bool currentRemove = false; // 当前下载任务是否被删除

  static createDownloadTask(Map taskInfo) async {
    if (creating) {
      CommonUtils.showText(CommonUtils.txt('dtkts'));
      return;
    }
    try {
      Box box = await Hive.openBox('qypjbox');
      List tasks = box.get('download_comics_tasks') ?? [];
      int existTaskIndex = tasks.indexWhere((e) => e["id"] == taskInfo["id"]);
      int existDownloadTaskIndex = downloadTasks
          .indexWhere((e) => e["taskInfo"]["id"] == taskInfo["id"]);
      // 存在下载任务
      if (tasks.isNotEmpty && existTaskIndex != -1) {
        if (tasks[existTaskIndex]["downloading"] ||
            tasks[existTaskIndex]["progress"] == 1 ||
            existDownloadTaskIndex != -1) {
          CommonUtils.showText(CommonUtils.txt('yczxz'));
        } else if (downloading) {
          CommonUtils.showText(CommonUtils.txt('ztjdl'));
          downloadTasks.add({"taskInfo": tasks[existTaskIndex]});
          tasks[existTaskIndex]["isWaiting"] = true;
          box.put("download_video_tasks", tasks);
        } else {
          CommonUtils.showText(CommonUtils.txt('jxxz'));
          downloadTasks.add({"taskInfo": tasks[existTaskIndex]});
          downloadContent(tasks[existTaskIndex], box);
          tasks[existTaskIndex]["downloading"] = true;
          tasks[existTaskIndex]["isWaiting"] = false;
          box.put("download_video_tasks", tasks);
        }
        creating = false;
        return;
      }
      CommonUtils.showText(CommonUtils.txt('ytjzwck'));
      taskInfo["tsListsFinished"] = [];
      // 添加下载队列
      downloadTasks.add({"taskInfo": taskInfo});
      if (!downloading) {
        taskInfo["downloading"] = true;
        taskInfo["isWaiting"] = false;
        downloadContent(taskInfo, box);
      }
      // 储存下载任务信息
      taskInfo["progress"] = 0;
      tasks.insert(0, taskInfo);
      box.put("download_video_tasks", tasks);
      creating = false;
    } catch (e) {
      CommonUtils.showText(CommonUtils.txt('xzcjsb'));
      creating = false;
    }
  }

  static Future<void> downloadContent(Map taskInfo, Box box) async {}
}
