import 'dart:io';

main() {
    String line = stdin.readLineSync();
    while(line != null) {
      List<String> words = line.split(" ");
      int difference = int.parse(words[0]) - int.parse(words[1]);
      print(difference.abs());
      line = stdin.readLineSync();
    }
}