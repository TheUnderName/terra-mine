import 'dart:io';
import 'server.dart';

void main() {
  var s = new Server("127.0.0.1", 7777);
  s.Start();
}
