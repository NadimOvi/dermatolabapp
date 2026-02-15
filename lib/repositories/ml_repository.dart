import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import '../models/detection_result.dart';
import '../utils/constants.dart';

class MLRepository {
  Interpreter? _interpreter;
  List<String>? _labels;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Load the TFLite model
      _interpreter = await Interpreter.fromAsset(ModelConstants.modelPath);
      
      // Load labels
      _labels = [
        'akiec',
        'bcc',
        'bkl',
        'df',
        'mel',
        'nv',
        'vasc',
      ];

      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to initialize ML model: $e');
    }
  }

  Future<DetectionResult> detectDisease(File imageFile) async {
    if (!_isInitialized) {
      await initialize();
    }

    if (_interpreter == null || _labels == null) {
      throw Exception('Model not properly initialized');
    }

    try {
      // Preprocess image
      final input = await _preprocessImage(imageFile);
      
      // Prepare output buffer
      final output = List.filled(1 * ModelConstants.numClasses, 0.0)
          .reshape([1, ModelConstants.numClasses]);

      // Run inference
      _interpreter!.run(input, output);

      // Get predictions
      final predictions = output[0] as List<double>;
      
      // Create map of all predictions
      final allPredictions = <String, double>{};
      for (int i = 0; i < _labels!.length; i++) {
        allPredictions[_labels![i]] = predictions[i];
      }

      // Get top prediction
      double maxConfidence = 0.0;
      int maxIndex = 0;
      
      for (int i = 0; i < predictions.length; i++) {
        if (predictions[i] > maxConfidence) {
          maxConfidence = predictions[i];
          maxIndex = i;
        }
      }

      final diseaseCode = _labels![maxIndex];
      final diseaseName = DiseaseLabels.labels[diseaseCode] ?? 'Unknown';

      return DetectionResult(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        imagePath: imageFile.path,
        diseaseName: diseaseName,
        diseaseCode: diseaseCode,
        confidence: maxConfidence,
        timestamp: DateTime.now(),
        allPredictions: allPredictions,
      );
    } catch (e) {
      throw Exception('Error during disease detection: $e');
    }
  }

  Future<List<List<List<List<double>>>>> _preprocessImage(File imageFile) async {
    // Read image file
    final bytes = await imageFile.readAsBytes();
    img.Image? image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Failed to decode image');
    }

    // Resize image to model input size
    img.Image resizedImage = img.copyResize(
      image,
      width: ModelConstants.inputSize,
      height: ModelConstants.inputSize,
    );

    // Convert to float32 and normalize [0, 1]
    final imageMatrix = List.generate(
      1,
      (i) => List.generate(
        ModelConstants.inputSize,
        (y) => List.generate(
          ModelConstants.inputSize,
          (x) {
            final pixel = resizedImage.getPixel(x, y);
            return [
              pixel.r / 255.0,
              pixel.g / 255.0,
              pixel.b / 255.0,
            ];
          },
        ),
      ),
    );

    return imageMatrix;
  }

  void dispose() {
    _interpreter?.close();
    _isInitialized = false;
  }
}
