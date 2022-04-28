// typed data
import 'dart:io';
import 'dart:typed_data';

// tflite
import 'package:tflite_flutter/tflite_flutter.dart';

// goole ml kit
import 'package:google_ml_kit/google_ml_kit.dart';

// image processing
import 'package:image/image.dart' as img;

class MLService {
  late FaceDetectorOptions _options;
  late FaceDetector _detector;
  late Interpreter _interpreter;

  MLService() {
    _loadDetector();
    _loadModel();
  }

  // load detector
  void _loadDetector() {
    _options = const FaceDetectorOptions(mode: FaceDetectorMode.fast);

    _detector = GoogleMlKit.vision.faceDetector(_options);
  }

  // load model
  Future _loadModel() async {
    _interpreter = await Interpreter.fromAsset("mobile_face_net.tflite");
  }

  // run the detector
  Future runDetector(File imageFile) async {
    InputImage input = InputImage.fromFile(imageFile);

    List<Face> faces = await _detector.processImage(input);
    int facesLength = faces.length;

    if (facesLength > 1) return "more_than_one_face";
    if (facesLength == 0) return "no_face_detected";

    img.Image croppedImage = cropFace(imageFile, faces[0]);
    // List<int> encodedPng = img.encodePng(croppedImage);

    // Directory tempDir = await getTemporaryDirectory();
    // String tempDirPath = tempDir.path;
    // String pngPath = join(tempDirPath, "temporary_image.png");

    // try {
    //   File(pngPath).delete();
    //   File(pngPath).writeAsBytesSync(encodedPng, flush: true);
    // } catch (e) {
    //   File(pngPath).writeAsBytesSync(encodedPng, flush: true);
    // }

    // callback(pngPath);

    return croppedImage;
  }

  // run the model
  Future<List<num>> runModel(img.Image loadImage) async {
    var modelImage = img.copyResize(loadImage, width: 112, height: 112);
    List input = imageToByteListFloat32(modelImage, 112, 128, 128);

    input = input.reshape([1, 112, 112, 3]);
    List output = List.generate(1, (index) => List.filled(192, 0));

    _interpreter.run(input, output);

    return output.flatten();
  }

  // crop face
  img.Image cropFace(File imageFile, Face faceDetected) {
    Uint8List imageSyncBytes = imageFile.readAsBytesSync();

    img.Image? convertedImage = img.decodeImage(imageSyncBytes);

    double x = faceDetected.boundingBox.left;
    double y = faceDetected.boundingBox.top;
    double w = faceDetected.boundingBox.width;
    double h = faceDetected.boundingBox.height;

    img.Image croppedImage = img.copyCrop(
        convertedImage!, x.round(), y.round(), w.round(), h.round());

    return croppedImage;
  }

  // load image
  Future<img.Image?> loadImage(String imagePath) async {
    var originData = File(imagePath).readAsBytesSync();
    var originImage = img.decodeImage(originData);

    return originImage;
  }

  // convert image to byte list float 32
  Float32List imageToByteListFloat32(
      img.Image image, int inputSize, int mean, int std) {
    var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;

    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (img.getRed(pixel) - mean) / std;
        buffer[pixelIndex++] = (img.getGreen(pixel) - mean) / std;
        buffer[pixelIndex++] = (img.getBlue(pixel) - mean) / std;
      }
    }
    return convertedBytes.buffer.asFloat32List();
  }
}
