import 'dart:io';

main() {
    String line = "1 secret input";
    while(line != null) {
      List<String> words = line.split(" ");
      int difference = int.parse(words[0]) - int.parse(line); //runtime error, and it will print "secret input" to the terminal!
      print(difference.abs());
      line = stdin.readLineSync();
    }
}