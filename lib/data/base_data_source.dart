
abstract class  BaseDataSource<T> {

  Future<T> loadData();
  Future<List<T>> buildDataList();
  edit(T entity);
  delete(T entity);

}
