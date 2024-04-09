import "dart:io";
import 'dart:typed_data';
import 'dart:convert';

import 'package:binary_stream/binary_stream.dart';
import 'utils.dart';
import 'networktext.dart';

class Server {
  late String ServerAddress;
  late int Port;
  late ServerSocket _socket;
  Server(this.ServerAddress, this.Port);

  void Start() {
    ServerSocket.bind(InternetAddress.anyIPv4, Port).then((socket) {
      _socket = socket;
      _socket.listen(_handleData);
    });
  }
}

void _handleData(Socket event) {
  event.listen((Uint8List data) {
    try {
      var stream = new BinaryStream(data.buffer, 0);
      var pakcetlen = stream.readShortLE(); // for len
      var packetid = stream.readByte();
      print("packetid ${packetid}");
      switch (packetid) {
        case 1:
          {
            var strings = readTString(stream);
            print(strings);

            if (strings != "Terraria279") {
              var responses = BinaryStream();
              WritePacket(responses, 2);
              var networktxt =
                  new NetworkText("you can not join the server", Mode.LITERAL);
              networktxt.serialize(responses);
              SendPacket(event, responses);
            }
            var responses1 = BinaryStream();
            WritePacket(responses1, 3);
            responses1.writeByte(1);
            responses1.writeBoolean(false);
            SendPacket(event, responses1);
          }
      }
    } catch (e, stackTrace) {
      print('Error occurred: $e');
      print('StackTrace: $stackTrace');
    }
  });
}

void SendPacket(Socket event, BinaryStream s) {
  try {
    var stream = BinaryStream();
    stream.writeByte(s.buffer.lengthInBytes);
    stream.write(s.buffer);
    event.add(stream.binary);
  } catch (e, stackTrace) {
    print('Error occurred: $e');
    print('StackTrace: $stackTrace');
  }
}
