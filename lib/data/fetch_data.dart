import 'package:anad_magicar/data/base_data_source.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/viewmodel/init_data_vm.dart';
import 'package:flutter/material.dart';

abstract class FetchData<T> extends BaseDataSource<T> {
  RestDatasource restDatasource;

  FetchData({
    @required this.restDatasource,
  }) {
    if (restDatasource == null) restDatasource = RestDatasource();
    init();
  }

  Future<InitDataVM> init();

  Future<List<T>> fetchAll();
  Future<T> fetchOne();
  remove(T en);

  @override
  Future<List<T>> buildDataList() async {
    return fetchAll();
  }

  @override
  delete(T entity) {
    remove(entity);
    return null;
  }

  @override
  edit(T entity) {
    return null;
  }

  @override
  Future<T> loadData() async {
    return fetchOne();
  }
}
