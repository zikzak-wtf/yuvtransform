import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:rxdart/subjects.dart';
import 'package:yuvtransform/yuvtransform.dart';

class ImageResultProcessorService {
  /// We need to notify the page that we have finished the process of the image.
  /// The subject could possibly sink the result [Uint8List] if needed.
  final PublishSubject<Uint8List> _queue = PublishSubject();

  /// Observers that needs the result image should subscribe to this stream.
  Stream<Uint8List> get queue => _queue.stream;

  addRawImage(CameraImage cameraImage) async {
    num sTime = DateTime.now().millisecondsSinceEpoch;
    Uint8List imgJpeg = await Yuvtransform.yuvTransform(cameraImage);
    print(
        "Job took ${(DateTime.now().millisecondsSinceEpoch - sTime) / 1000} seconds to complete.");
    _queue.sink.add(imgJpeg);
  }

  void dispose() {
    _queue.close();
  }
}
