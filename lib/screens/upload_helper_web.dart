import 'dart:async';
import 'dart:typed_data';
import 'dart:html' as html;

class PickedFile {
  final Uint8List bytes;
  final String name;
  PickedFile({required this.bytes, required this.name});
}

Future<PickedFile?> pickFileWeb() async {
  final completer = Completer<PickedFile?>();

  final input = html.FileUploadInputElement();
  input.accept = 'image/jpeg,image/png,application/pdf';
  input.click();

  input.onChange.listen((event) {
    final file = input.files?.first;
    if (file == null) {
      completer.complete(null);
      return;
    }
    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);
    reader.onLoad.listen((_) {
      final bytes = reader.result as Uint8List;
      completer.complete(PickedFile(bytes: bytes, name: file.name));
    });
    reader.onError.listen((_) => completer.complete(null));
  });

  input.onAbort.listen((_) => completer.complete(null));

  return completer.future;
}