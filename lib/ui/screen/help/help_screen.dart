import 'package:anad_magicar/translation_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:share/share.dart';

class HelpScreen extends StatelessWidget {
  String pathPDF = "";
  HelpScreen({this.pathPDF});

  _onShare(BuildContext context) async {
    // A builder is used to retrieve the context immediately
    // surrounding the RaisedButton.
    //
    // The context's `findRenderObject` returns the first
    // RenderObject in its descendent tree when it's not
    // a RenderObjectWidget. The RaisedButton's RenderObject
    // has its position and size after it's built.
    final RenderBox box = context.findRenderObject();

    if (pathPDF.isNotEmpty) {
      await Share.shareFiles(<String>[pathPDF],
          text: Translations.current.shareHelpText(),
          subject: Translations.current.shareHelpSubject(),
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    } else {
      await Share.share(Translations.current.shareHelpText(),
          subject: Translations.current.shareHelpSubject(),
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          title: Text(Translations.current.document()),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () async {
                await _onShare(context);
              },
            ),
          ],
        ),
        primary: true,
        path: pathPDF);
  }
}
