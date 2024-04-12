import 'dart:typed_data';

import 'package:binary_stream/binary_stream.dart';
import 'utils.dart';

class NetworkText {
  String text;
  Mode mode;
  NetworkText(this.text, this.mode);

  static String deserialize(BinaryStream data) {
    int mod = data.readByte();
    ModeExtension.fromId(mod);
    String text = readTString(data);
    return text;
  }

  Uint8List serialize(BinaryStream writer) {
    writer.writeByte(mode.index);
    writeTString(writer, text);
    return writer.buffer.asUint8List();
  }
}

enum Mode { LITERAL, FORMATTABLE, LOCALIZATIONKEY }

extension ModeExtension on Mode {
  static Mode fromId(int id) {
    switch (id) {
      case 0:
        return Mode.LITERAL;
      case 1:
        return Mode.FORMATTABLE;
      case 2:
        return Mode.LOCALIZATIONKEY;
      default:
        throw Exception('Invalid Mode ID');
    }
  }
}
