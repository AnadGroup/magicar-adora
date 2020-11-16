/*

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:anad_magicar/bloc/search/search_bloc.dart';
import 'package:anad_magicar/bloc/search/index.dart';
import 'package:anad_magicar/bloc/search/search_result_screen.dart';
import 'package:anad_magicar/components/loading_indicator.dart';
import 'package:anad_magicar/components/search_form.dart';
import 'package:anad_magicar/data/rxbus.dart';
import 'package:anad_magicar/models/Search_event.dart';
import 'package:anad_magicar/translation_strings.dart';

class SearchScreen extends StatefulWidget {
   SearchScreen({
    Key key,
    @required SearchBloc searchBloc,
    this.searchText,
  })  : _searchBloc = searchBloc,
        super(key: key);

  final SearchBloc _searchBloc;
  String searchText='';

  @override
  SearchScreenState createState() {
    return new SearchScreenState(_searchBloc);
  }
}

class SearchScreenState extends State<SearchScreen> with TickerProviderStateMixin{
  final SearchBloc _searchBloc;
  SearchBloc _bloc;

  SearchScreenState(this._searchBloc);


_showModalBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(context: context,
        builder: (BuildContext context) {
          return
            new Container(
              height: 350.0,
              color: Colors.transparent,
            child: new Container(
              decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(10.0),
          topRight: const Radius.circular(10.0))),
            child:
            new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new ListTile(leading: new Icon(Icons.close),
                  title: new Text('جستجوی محصولات'),
                  onTap: () => null,
                ),
                //new SearchForm(searchBloc: this._searchBloc),
                //new DoSearch()
              ],
            ),
            ),
            );

        });
  }

  _showSearch(SearchBloc searchBloc)
  {
    return
            new Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
            child: new Container(
              decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(10.0),
          topRight: const Radius.circular(10.0))),
            child:
            new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new ListTile(leading: new Icon(Icons.close),
                  title: new Text(Translations.current.search()),
                  onTap: () => Navigator.pushReplacementNamed(context, '/home'),
                ),
                new SearchForm(searchBloc: searchBloc),
                //new DoSearch()
              ],
            ),
            ),
            );

  }
  @override
  void initState() {
    super.initState();
    //this._searchBloc.dispatch(LoadSearchEvent());


    BlocProvider.of<SearchBloc>(context).dispatch(new InitSearchEvent());

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _bloc=BlocProvider.of<SearchBloc>(context);
    return BlocBuilder<SearchBloc, SearchState>(
        bloc: BlocProvider.of<SearchBloc>(context),
        builder: (
          BuildContext context,
          SearchState currentState,) {
          if (currentState is UnSearchState) {
            return _showSearch(_bloc); //_showModalBottomSheet(Scaffold.of(context).context);
          }
          if(currentState is InSearchState)
          {
            return LoadingIndicator();
          }
          if (currentState is ErrorSearchState) {
            return new Container(
              child: new Center(
              child: new Text(currentState.errorMessage ?? 'Error' ),
            ));
          }
          if(currentState is DoneSearchState)
          {
            //RxBus.post(bew ChangeEvent(message: SoapOpersConstants.SEARCH)).    
            return new SearchResultScreen();
          }
          return new Container(
              child: new Center(
            child: new Text(Translations.current.enterSearchText()),
          ));
        });
  }
}

*/
