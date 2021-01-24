import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:info_xplayer_flutter/data/entity/video_info.dart';
import 'package:info_xplayer_flutter/logger.dart';

import '../../main.dart';

class InfoModel extends ChangeNotifier {
  VideoInfo _videoInfo;
  static const platformChannelId = "banson.cloud/info";
  static const platform = const MethodChannel(platformChannelId);

  Future<String> _getDuration() async {
    String videoDuration = await platform.invokeMethod('getDuration');
    return videoDuration;
  }

  Future<String> _getName() async {
    String videoName = await platform.invokeMethod('getName');
    return videoName;
  }

  Future<void> inflateData() async {
    try {
      String name =
          await MethodChannel(platformChannelId).invokeMethod('getName');
      String duration =
          await MethodChannel(platformChannelId).invokeMethod('getDuration');
      _videoInfo = VideoInfo(name, duration);
      notifyListeners();
    } catch (e) {
      _videoInfo = VideoInfo(e.toString(), e.toString());
      notifyListeners();
    }
  }

  String name() {
    if (_videoInfo == null) {
      inflateData();
      return "name_missing";
    } else {
      return _videoInfo.name;
    }
  }

  String duration() {
    if (_videoInfo == null) {
      return "duration_missing";
    } else {
      return _videoInfo.duration;
    }
  }
}
