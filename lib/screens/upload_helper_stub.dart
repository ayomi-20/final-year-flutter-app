import 'dart:typed_data';

class PickedWebFile {
  final Uint8List bytes;
  final String name;

  PickedWebFile({
    required this.bytes,
    required this.name,
  });
}

Future<PickedWebFile?> pickFileWeb() async {
  return null;
}