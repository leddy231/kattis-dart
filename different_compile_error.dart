import 'dart:io';

main() {
    String line = stdin.readLineSync();
    while(line != null) {
      List<String> words = line.split(" ");
      int difference = int.parse(words["a_string"]) - int.parse(words[1]); //type error, string instead of int
      print(difference.abs());
      line = stdin.readLineSync() //missing ';'
    }
}