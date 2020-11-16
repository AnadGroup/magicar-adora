
class WrapValueProvider<T>{

  T _value;

   get changedValue => _value;
   set newValue(T v)=> this._value=v;
}