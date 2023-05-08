import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';

class Yuvtransform {
  static const MethodChannel _channel = MethodChannel('yuvtransform');

  static Future<Uint8List> yuvTransform(
    CameraImage image, {
    int? quality = 60,
  }) async {
    List<int> strides = Int32List(image.planes.length * 2);
    int index = 0;
    // We need to transform the image to Uint8List so that the native code could
    // transform it to byte[]
    List<Uint8List> data = image.planes.map((plane) {
      strides[index] = (plane.bytesPerRow);
      index++;
      strides[index] = (plane.bytesPerPixel)!;
      index++;
      return plane.bytes;
    }).toList();
    Uint8List imageJpeg = await _channel.invokeMethod('yuvtransform', {
      'platforms': data,
      'height': image.height,
      'width': image.width,
      'strides': strides,
      'quality': quality
    });

    return imageJpeg;
  }

  static Future<Uint8List> nv21ToJPEG(
    CameraImage image, {
    int? quality = 100,
  }) async {
    Uint8List imageJpeg = await _channel.invokeMethod('nv21_to_jpeg', {
      'bytes': image.planes[0].bytes,
      'height': image.height,
      'width': image.width,
      'quality': quality
    });

    return imageJpeg;
  }
}
