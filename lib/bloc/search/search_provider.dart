/*



import 'package:anad_magicar/bloc/search/SearchBloc.dart';
import 'package:anad_magicar/bloc/search/index.dart' as s2;
import 'package:anad_magicar/models/viewmodel/search_model.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/repository/request/request_repository.dart';

class  SearchProvider<T> {


  static final  SearchProvider _repository = new SearchProvider._internal();
  SearchBloc searchBloc;
  s2.SearchBloc searchBloc2;
  factory SearchProvider() {
   
    return _repository;
  }

  SearchProvider._internal();

  List<SearchModel> search(String searchText,SearchBloc searchBloc,s2.SearchBloc searchBloc2)
  {
    SearchModel searchModel=new SearchModel();
    if(centerRepository.exerciseProgramsForSearch!=null &&
    centerRepository.exerciseProgramsForSearch.length>0)
      {
        searchModel.programsSearch.addAll(centerRepository.exerciseProgramsForSearch.where((e)=>e.exerciseProgramDetail.description.contains(searchText) || e.exerciseProgramDetail.titleofprogram.contains(searchText)).toList());
      }

    if(centerRepository.dietProgramsForSearch!=null &&
        centerRepository.dietProgramsForSearch.length>0)
    {
      searchModel.dietsSearch.addAll(centerRepository.dietProgramsForSearch.where((e)=>e.requestProgramDietDetail.description.contains(searchText) || e.requestProgramDietDetail.titleofprogram.contains(searchText)).toList());
    }

    searchBloc.searchModel.add(searchModel);
    searchBloc2.dispatch(new s2.LoadedSearchEvent());
    return null;
  }
}


SearchProvider searchProvider=new SearchProvider();*/
