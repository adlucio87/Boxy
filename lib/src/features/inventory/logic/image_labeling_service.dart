import 'package:google_ml_kit_image_labeling/google_ml_kit_image_labeling.dart';
import 'dart:io';

class ImageLabelingService {
  final ImageLabeler _imageLabeler;

  ImageLabelingService({ImageLabeler? imageLabeler})
      : _imageLabeler = imageLabeler ??
            ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.5));

  /// Processes the image at [imagePath] and returns a list of detected labels (Strings).
  Future<List<String>> getLabels(String imagePath) async {
    try {
      final inputImage = InputImage.fromFile(File(imagePath));
      final List<ImageLabel> labels = await _imageLabeler.processImage(inputImage);

      // Extract text from labels
      final List<String> tagList = labels.map((label) => label.label).toList();

      return tagList;
    } catch (e) {
      // In a real app, use a logger
      print('Error labeling image: $e');
      return [];
    }
  }

  void dispose() {
    _imageLabeler.close();
  }
}
