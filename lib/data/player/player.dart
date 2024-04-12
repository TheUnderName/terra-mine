import "../../io/color.dart";

class Player {
  late int state = 0;
  late int playerid = -1;
  //***stats***/
  late int skinVarient;
  late int skinHair;
  late String Name;
  late int hairDye;
  late int hideVisuals;
  late int hideVisuals2;
  late int hideMisc;
  late GameColor hairColor;
  late GameColor skinColor;
  late GameColor eyeColor;
  late GameColor ShirtColor;
  late GameColor underShirtColor;
  late GameColor pantsColor;
  late GameColor shoeColor;
  late GameColor difficultyFlags;
  late GameColor torchFlags;

  Player();

  List<bool> playerlist = List.filled(256, false);

  int add() {
    for (int i = 0; i < playerlist.length; i++) {
      if (playerlist[i]) {
        continue;
      }
      playerlist[i] = true;
      return i;
    }
    return -1;
  }

  void free(int playerid) {
    if (playerid > 255) throw ArgumentError;
    playerlist[playerid] = false;
  }
}
