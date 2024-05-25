import 'dart:math';

// class used to give random username to the users after authenticaion

class GenerateRandomUserName {
  // method to generate random username
  String generateRandomUserName() {
    final random = Random();
    final randomNumber = random.nextInt(10000);
    return 'user$randomNumber';
  }
}