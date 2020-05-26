# Dart installation
Taken from [dart.dev/get-dart](https://dart.dev/get-dart), assuming a Ubuntu installation

Add googles apt repository for Dart
```bash
sudo apt-get update
sudo apt-get install apt-transport-https
sudo sh -c 'wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -'
sudo sh -c 'wget -qO- https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list'
```

Install Dart SDK
```bash
sudo apt-get update
sudo apt-get install dart
```

Add to path in some way
```bash
echo 'export PATH="$PATH:/usr/lib/dart/bin"' >> ~/.bashrc
```

The SDK will be installed in `/usr/lib/dart`, and comes with both the `dart` and `dart2native` tools in `/usr/lib/dart/bin`

# Running dart code
Dart has two ways of running code in the command line, the Dart VM `dart` and the Dart compiler `dart2native`. 

`dart` has one command line flag of interest, `--old_gen_heap_size`, which can be used to limit the VM memory (in megabytes). Example usage:
```
dart --old_gen_heap_size=1024 ./different_accepted.dart
```

However for competetive programming the dart compiler `dart2native` should probably be used, as it produces a fast native binary. By default the produced binary will be called `${filename}.exe`, as the compiler can also produce `.aot` files to load into the VM. (this name can be changed by specifying a name with `-o`)
```
dart2native ./different_accepted.dart -o different
```
From here the same tools used to execute and limit a C/C++ binary should work the same. `dart2native` does not provide any optimization flags or similar that would be of use.

# Errors and crashes

When compilation errors are found they are printed in detail, and should be safe to share with the user. Example from `different_compile_error.dart`  
(the last two line could possibly be removed to avoid confusion, the wording is a bit weird and is the same on all compilation errors)
```dart
different_compile_error.dart:9:33: Error: Expected ';' after this.
      line = stdin.readLineSync() //missing ';'
                                ^
different_compile_error.dart:7:40: Error: A value of type 'String' can´t be assigned to a variable of type 'int'.
      int difference = int.parse(words["a_string"]) - int.parse(words[1]); //type error, string instead of int
                                       ^


Failed to generate native files:
Generating AOT kernel dill failed!
```

Runtime errors *can* print the data that created the error and could therefore leak test data, and should not be shared with the user. Example from `different_runtime_error.dart`

```dart
Unhandled exception:
FormatException: Invalid radix-10 number (at character 1)
1 secret input
^

#0      int._throwFormatException (dart:core-patch/integers_patch.dart:133:5)
#1      int._parseRadix (dart:core-patch/integers_patch.dart:144:16)
#2      int._parse (dart:core-patch/integers_patch.dart:102:12)
#3      int.parse (dart:core-patch/integers_patch.dart:65:12)
#4      main (file:///home/martin/Dropbox/Programing/Dart/different_runtime_error.dart:7:50)
#5      _startIsolate.<anonymous closure> (dart:isolate-patch/isolate_patch.dart:301:19)
#6      _RawReceivePortImpl._handleMessage (dart:isolate-patch/isolate_patch.dart:168:12)
```

Running out of memory is also reported as a runtime error, `different_memory_limit.dart`:

```dart
Exhausted heap space, trying to allocate 2600260016 bytes.
Unhandled exception:
Out of Memory
#0      String._allocate (dart:core-patch/string_patch.dart:1227:78)
#1      String.* (dart:core-patch/string_patch.dart:1058:44)
#2      main (file:///home/martin/Dropbox/Programing/Dart/different_memory_limit.dart:6:20)
#3      _startIsolate.<anonymous closure> (dart:isolate-patch/isolate_patch.dart:301:19)
#4      _RawReceivePortImpl._handleMessage (dart:isolate-patch/isolate_patch.dart:168:12)
```

# Input and output
IO is provided by the dart:io library, and the standard io functions do not have any issues similar to Javas.
### Input
Read a single line synchronously
```dart
stdin.readLineSync();
```
As stdin is a buffered `Stream`, it can be consumed in many ways including asynchronously
### Output
Output can be done either
```dart
print("string");
```
or
```dart
stdout.write("string");
```
Both options are blocking.
There is a non blocking variant
```dart
stdout.nonBlocking.write("string");
```
However in my tests `print` was way faster than `stdout`, and `stdout.nonBlocking` was extreamly slow. (0.83s, 2.36s and 17.33s respectivly to print 1 000 000 lines) 

`print` should be used.