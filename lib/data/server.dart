import 'dart:async';

class Server {
  StreamController<String> _controller = new StreamController.broadcast();
  void simulateMessage(String message) {
    _controller.add(message);
  }
  
  Stream get messages => _controller.stream;


}