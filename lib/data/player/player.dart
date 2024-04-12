class Player {
  late int state = 0;
  late int playerid = -1;
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
