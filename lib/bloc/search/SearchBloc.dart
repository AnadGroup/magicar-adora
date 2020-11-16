/*
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:anad_magicar/bloc/basic/bloc_provider.dart';
import 'package:anad_magicar/bloc/search/search_provider.dart';
import 'package:anad_magicar/models/viewmodel/exercise_program.dart';
import 'package:anad_magicar/models/viewmodel/request_program_diet.dart';
import 'package:anad_magicar/models/viewmodel/search_model.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc implements BlocBase {
  static const String TAG = "SearchBloc";
   SearchProvider _searchProvider;// = new SearchProvider();
  String query='';

  /// Sinks
  Sink<String> get addition => itemAdditionController.sink;
  final itemAdditionController = StreamController<String>();

  Sink<SearchModel> get searchModel => getSearchController.sink;
  final getSearchController = StreamController<SearchModel>();

  Sink<ExerciseProgram> get program => getProgramController.sink;
  final getProgramController = StreamController<ExerciseProgram>();

  Sink<List<ExerciseProgram>> get programs => getProgramsController.sink;
  final getProgramsController = StreamController<List<ExerciseProgram>>();

  Sink<RequestProgramDiet> get diet => getDietController.sink;
  final getDietController = StreamController<RequestProgramDiet>();

  Sink<List<RequestProgramDiet>> get dites => getDietsController.sink;
  final getDietsController = StreamController<List<RequestProgramDiet>>();


  /// Streams
  Stream<String> get queryStream => _search.stream;
  Stream<SearchModel> get searchModelStream => _searchModel.stream;

  Stream<List<ExerciseProgram>> get programsStream => _searchPrograms.stream;
  Stream<ExerciseProgram> get programStream => _searchProgram.stream;
  Stream<List<RequestProgramDiet>> get dietsStream => _searchDiets.stream;
  Stream<RequestProgramDiet> get dietStream => _searchDiet.stream;

  final _search = BehaviorSubject<String>();
  final _searchModel=BehaviorSubject<SearchModel>();
  final _searchPrograms = BehaviorSubject<List<ExerciseProgram>>();
  final _searchProgram = BehaviorSubject<ExerciseProgram>();
  final _searchDiets = BehaviorSubject<List<RequestProgramDiet>>();
  final _searchDiet = BehaviorSubject<RequestProgramDiet>();

  SearchBloc() {
    _searchProvider=new SearchProvider();
    itemAdditionController.stream.listen(handleSearch);
    getSearchController.stream.listen(handleSearchModel);
    //getProgramsController.stream.listen(handleSearchPrograms);
    //getProgramController.stream.listen(handleSearchPrpgram);
  }

  ///
  /// Logic for search query
  ///
  void handleSearch(String query) {
    //Logger(TAG).info("Add product to the shopping cart");
    this._searchProvider.search(query,this,null);
    return;
  }
  void handleSearchModel(SearchModel searchModel) {
    //Logger(TAG).info("Search Products Loaded");
    _searchModel.add(searchModel);
    return;
  }

  void handleSearchPrograms() {
    //Logger(TAG).info("Search Products Loaded");
     //products.addAll(products);
    //_searchProducts.add(products);
    return;
  }


  void handleSearchProgram() {
    Logger(TAG).info("Search Products Loaded");
    //_searchProduct.add(product);
    return;
  }

  ///
  /// Clears the shopping cart
  ///
  void clearQuery() {
    query='';
  }




  @override
  void dispose() {
    itemAdditionController.close();
    getSearchController.close();
    getProgramController.close();
    getDietController.close();
    getDietsController.close();
    getProgramsController.close();
  }
}*/
