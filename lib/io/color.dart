import 'package:binary_stream/binary_stream.dart';

class GameColor {
  late int red;
  late int green;
  late int blue;
  late int alpha;

  TColor(int red, int green, int blue) {
    this.red = red & 0xFF;
    this.green = green & 0xFF;
    this.blue = blue & 0xFF;
    this.alpha = 255;
  }

  fromRGBA(int red, int green, int blue, int alpha) {
    this.red = red & 0xFF;
    this.green = green & 0xFF;
    this.blue = blue & 0xFF;
    this.alpha = alpha & 0xFF;
  }

  serialize(BinaryStream data1) {
    data1.writeByte(red);
    data1.writeByte(green);
    data1.writeByte(alpha);
  }

  deserialize(BinaryStream data) {
    return TColor(data.readByte(), data.readByte(), data.readByte());
  }
}
