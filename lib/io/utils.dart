import 'dart:typed_data';
import 'dart:convert';

import 'package:binary_stream/binary_stream.dart';

void write7BitEncodedInt(BinaryStream writer, int value) {
  do {
    int b = value & 0x7F;
    value >>= 7;
    if (value == 0) {
      writer.writeByte(b);
      break;
    } else {
      b |= 0x80;
      writer.writeByte(b);
    }
  } while (true);
}

int read7BitEncodedInt(BinaryStream reader) {
  int value = 0;
  int shift = 0;
  int b;
  do {
    b = reader.readByte();
    value |= (b & 0x7F) << shift;
    shift += 7;
    if ((b & 0x80) == 0) {
      break;
    }
  } while (true);
  return value;
}

String readTString(BinaryStream reader) {
  int length = read7BitEncodedInt(reader);
  ByteBuffer bytes = reader.read(length);
  List<int> str = bytes.asUint8List();
  return utf8.decode(str);
}

void writeTString(BinaryStream writer, String s) {
  Uint8List bytes = utf8.encode(s);
  write7BitEncodedInt(writer, bytes.length);
  writer.write(bytes.buffer);
}

void writePacket(BinaryStream s, int p) {
  s.writeByte(0); // index terreria ++
  s.writeByte(p);
}
