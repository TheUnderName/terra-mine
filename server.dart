import "dart:io";
import 'dart:typed_data';
import 'dart:convert';

import 'package:binary_stream/binary_stream.dart';
import 'utils.dart';
import 'networktext.dart';
import 'player.dart';

class Server {
  late String ServerAddress;
  late int Port;
  late ServerSocket _socket;
  late Player player;
  Server(this.ServerAddress, this.Port);

  void Start() {
    player = Player();
    ServerSocket.bind(InternetAddress.anyIPv4, Port).then((socket) {
      _socket = socket;
      _socket.listen(handleData);
    });
  }

  void handleData(Socket event) {
    event.listen((Uint8List data) {
      try {
        var stream = new BinaryStream(data.buffer, 0);
        stream.readShortLE(); // for len
        var packetid = stream.readByte();
        print("packetid ${packetid}");
        switch (packetid) {
          case 1:
            {
              var strings = readTString(stream);
              print(strings);

              if (strings != "Terraria279") {
                var responses = BinaryStream();
                writePacket(responses, 2);
                var networktxt = new NetworkText(
                    "you can not join the server", Mode.LITERAL);
                networktxt.serialize(responses);
                sendPacket(event, responses);
              } else {
                if (player.state != 0) break;
                player.state = 1;
                player.playerid = player.add();
                var responses1 = BinaryStream();
                writePacket(responses1, 3);
                responses1.writeByte(1);
                responses1.writeBoolean(false);
                sendPacket(event, responses1);
              }
            }
        }
      } catch (e, stackTrace) {
        print('Error occurred: $e');
        print('StackTrace: $stackTrace');
      }
    });
    event.done.then((_) {
      handleDisconnect(event);
    });
  }

  void sendPacket(Socket event, BinaryStream s) {
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

  void handleDisconnect(Socket event) {
    if (player.playerid != -1) {
      player.free(this.player.playerid);
      print("Player deleted.");
    }
  }
}
