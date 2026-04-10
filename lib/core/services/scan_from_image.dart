import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanFromImage {
  final ImagePicker _picker = ImagePicker();
  final MobileScannerController _scannerController = MobileScannerController();

  Future<XFile?> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );
      return image;
    } catch (e) {
      print('error picking image: $e');
      return null;
    }
  }

  Future<String?> scanBarcodeFromImage(XFile image) async {
    try {
      final BarcodeCapture? capture = await _scannerController.analyzeImage(
        image.path,
      );
      if (capture != null && capture.barcodes.isNotEmpty) {
        return capture.barcodes.first.displayValue;
      }
      return null;
    } catch (e) {
      print("Error scanning image: $e");
      return null;
    }
  }
}
