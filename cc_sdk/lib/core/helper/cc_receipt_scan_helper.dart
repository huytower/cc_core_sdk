import 'dart:typed_data';

import 'package:flutter/services.dart' show PlatformException;
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

/// A receipt/screenshot image picked via [CcReceiptScanHelper.pickReceiptImage]
/// — carries the file path (on-device OCR needs a path) plus the raw bytes
/// and real [mimeType] (the cloud Gemini-vision fallback needs both). Not
/// [XFile] itself, so callers never need a direct `image_picker` dependency.
class PickedReceiptImage {
  const PickedReceiptImage({
    required this.path,
    required this.bytes,
    required this.mimeType,
  });

  final String path;
  final Uint8List bytes;
  final String mimeType;
}

/// Outcome of [CcReceiptScanHelper.pickReceiptImage] — distinguishes *why*
/// [image] is null so callers can show "permission denied" vs. silently
/// no-op on a plain cancel.
class ReceiptPickResult {
  const ReceiptPickResult({this.image, this.permissionDenied = false});

  final PickedReceiptImage? image;
  final bool permissionDenied;
}

/// Picks a receipt image (camera or gallery) and runs on-device OCR on it.
/// Fails silently on any error — backs a best-effort local extraction that
/// must degrade gracefully rather than crash.
abstract final class CcReceiptScanHelper {
  static final ImagePicker _picker = ImagePicker();

  static Future<ReceiptPickResult> pickReceiptImage({
    required bool fromCamera,
  }) async {
    try {
      // imageQuality isn't a reliable JPEG guarantee — both platforms skip
      // re-encoding for images with an alpha channel (most PNG screenshots).
      // Sniff the real format from the bytes instead.
      final file = await _picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 85,
      );
      if (file == null) return const ReceiptPickResult();
      final bytes = await file.readAsBytes();
      final mimeType = _detectImageMimeType(bytes);
      if (mimeType == null) return const ReceiptPickResult();
      return ReceiptPickResult(
        image: PickedReceiptImage(
          path: file.path,
          bytes: bytes,
          mimeType: mimeType,
        ),
      );
    } on PlatformException catch (e) {
      // image_picker_android/image_picker_ios both use these exact codes
      // for a denied camera or photo-library permission.
      final denied =
          e.code == 'camera_access_denied' || e.code == 'photo_access_denied';
      return ReceiptPickResult(permissionDenied: denied);
    } catch (_) {
      return const ReceiptPickResult();
    }
  }

  /// Sniffs the format from the magic-number header; null (not a guessed
  /// JPEG) on an unrecognized signature, so a corrupt file fails the pick
  /// rather than reaching the cloud fallback under a wrong MIME type.
  static String? _detectImageMimeType(Uint8List bytes) {
    if (bytes.length >= 4 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return 'image/png';
    }
    if (bytes.length >= 3 &&
        bytes[0] == 0xFF &&
        bytes[1] == 0xD8 &&
        bytes[2] == 0xFF) {
      return 'image/jpeg';
    }
    if (bytes.length >= 12 &&
        bytes[0] == 0x52 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x46 &&
        bytes[8] == 0x57 &&
        bytes[9] == 0x45 &&
        bytes[10] == 0x42 &&
        bytes[11] == 0x50) {
      return 'image/webp';
    }
    return null;
  }

  /// Runs on-device Latin-script text recognition on the image at [imagePath]
  /// and returns the raw recognized text (empty string on any failure —
  /// never null/throws, so callers can feed it straight into a parser
  /// without a separate null check).
  static Future<String> recognizeText(String imagePath) async {
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final input = InputImage.fromFilePath(imagePath);
      final result = await recognizer.processImage(input);
      return result.text;
    } catch (_) {
      return '';
    } finally {
      await recognizer.close();
    }
  }
}
