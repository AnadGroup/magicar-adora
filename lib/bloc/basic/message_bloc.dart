import 'dart:async';
import 'package:anad_magicar/bloc/basic/bloc_provider.dart';
import 'package:anad_magicar/model/message.dart';
import 'package:rxdart/rxdart.dart';

class MessageBloc implements BlocBase {

  static bool status;
  static int counter;
  /// Sinks
  Sink<Message> get addition => messageAdditionController.sink;
  final messageAdditionController = StreamController<Message>();

  Sink<Message> get count => messageCountController.sink;
  final messageCountController = StreamController<Message>();


  /// Streams
  Stream<Message> get messageStream => _message.stream;
  final _message = BehaviorSubject<Message>();

  MessageBloc() {
    messageAdditionController.stream.listen(handleMessageAdd);
    messageCountController.stream.listen(handleMessageAddCount);

  }

  ///
  /// Logic for message added .
  ///
  void handleMessageAdd(Message msg) {
    _message.add(msg);
    return;
  }


  void handleMessageAddCount(Message msg) {
    counter++;
    if(status)
      status=false;
    else
      status=true;

    _message.add(msg);
    return;
  }

  @override
  void dispose() {
    messageAdditionController.close();
    messageCountController.close();
  }
}
