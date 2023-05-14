// import 'package:flutter/cupertino.dart';
//
// class CounterState {
//   int _value = 0;
//
//   void inc() => _value++;
//
//   void dec() => _value--;
//
//   int get value => _value;
//
//   bool diff(CounterState old){
//     return old._value != _value;
//   }
// }
//
// class CounterProvider extends InheritedWidget {
//   final CounterState chicolopes = CounterState();
//
//   CounterProvider({super.key, required super.child});
//
//   static CounterProvider? of(BuildContext context){
//     //permite pegar uma instancia disponivel na arvore de componentes
//     return context.dependOnInheritedWidgetOfExactType<CounterProvider>();
//   }
//
//   @override
//   bool updateShouldNotify(covariant CounterProvider oldWidget) {
//     print('mudou');
//     return oldWidget.chicolopes.diff(chicolopes);
//   }
// }
