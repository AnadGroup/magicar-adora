import 'package:flutter/material.dart';
import 'package:anad_magicar/bloc/basic/bloc_provider.dart';
import 'package:anad_magicar/bloc/basic/global_bloc.dart';
import 'package:anad_magicar/model/message.dart';


class GlobalMessageWrapper extends StatefulWidget {
  final Widget child;

  GlobalMessageWrapper(this.child);
  @override
  _GlobalMessageWrapperState createState() => _GlobalMessageWrapperState();
}

class _GlobalMessageWrapperState extends State<GlobalMessageWrapper> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        initialData: null,
        stream: BlocProvider.of<GlobalBloc>(context).messageBloc.messageStream,
        builder: (BuildContext context, AsyncSnapshot<Message> snapshot) {
          Message msg = snapshot.data;
          if (msg != null) {
            WidgetsBinding.instance
                .addPostFrameCallback((_) => _showMessage(msg));
          }
          return Container(child: widget.child);
        });
  }

  void _showMessage(Message message) {
    Color color = Colors.grey;

    switch (message.type) {
      case "success":
        color = Colors.green;
        break;
      case "info":
        color = Colors.blue;
        break;
      case "warning":
        color = Colors.orange;
        break;
      case "error":
        color = Colors.red;
        break;
      default:
    }
    SnackBar bar = SnackBar(
        content: Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: Text(message.text),
        ),
        backgroundColor: color);

    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(bar);
  }
}