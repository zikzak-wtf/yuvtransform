package dev.zuzu.yuvtransform;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;


/** YuvtransformPlugin */
public class YuvtransformPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "yuvtransform");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("yuvtransform")) {
     List<byte[]> bytesList = call.argument("platforms");
      int[] strides = call.argument("strides");
      int width = call.argument("width");
      int height = call.argument("height");
      int quality = call.argument("quality");

      try {
          byte[] data = YuvConverter.NV21toJPEG(YuvConverter.YUVtoNV21(bytesList, strides, width, height), width, height, 100);
          Bitmap bitmapRaw = BitmapFactory.decodeByteArray(data, 0, data.length);

          Matrix matrix = new Matrix();
          matrix.postRotate(90);
          Bitmap finalbitmap = Bitmap.createBitmap(bitmapRaw, 0, 0, bitmapRaw.getWidth(), bitmapRaw.getHeight(), matrix, true);
          ByteArrayOutputStream outputStreamCompressed = new ByteArrayOutputStream();
          finalbitmap.compress(Bitmap.CompressFormat.JPEG, quality, outputStreamCompressed);

          result.success(outputStreamCompressed.toByteArray());
          outputStreamCompressed.close();
          data = null;
      } catch (IOException e) {
          e.printStackTrace();
      }
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
