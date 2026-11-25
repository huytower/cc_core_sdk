import 'dart:typed_data';

/// An image sent with a prompt.
class CcAiImage {
  const CcAiImage({required this.bytes, required this.mimeType});

  final Uint8List bytes;

  /// e.g. `image/jpeg`, `image/png`, `image/webp`.
  final String mimeType;
}

