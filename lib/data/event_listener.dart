
import 'dart:async';



abstract class EventListener<T> {

   onStartListen(T e);
   onStartResume(T e);
   onStartError(T e);
   onStartPause(T e);

  T e;
  StreamController _controller ;

  void simulateEvent(T event) {
    _controller.add(event);
  }

  void init()
  {
   _controller =  StreamController<T>(
        onListen: onStartListen(e),
        onResume: onStartResume(e),
        onPause: onStartPause(e)
    );
  }

  Stream get events => _controller.stream;
  StreamSubscription subscription;
}