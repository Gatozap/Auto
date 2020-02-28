import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class ExpandableController extends BlocBase {
  BehaviorSubject<bool> controllerExpandable = new BehaviorSubject<bool>();
  Stream<bool> get outExpandable => controllerExpandable.stream;
  Sink<bool> get inExpandable => controllerExpandable.sink;
  ExpandableController({bool startExpanded}) {
    inExpandable.add(startExpanded);
  }

  @override
  void dispose() {
    controllerExpandable.close();
    // TODO: implement dispose
  }
}
