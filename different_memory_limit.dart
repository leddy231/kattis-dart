import 'dart:io';

main() {
    String line = "some kinda very long input";
    while(line != null) {
      line += line * 10000;
    }
}