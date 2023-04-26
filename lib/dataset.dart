import 'dart:collection';

import 'package:back_propagation/bitmap.dart';
import 'package:back_propagation/module.dart';

part 'dataset/splitable_dataset.dart';
part 'dataset/yale_dataset.dart';

class DatasetItem<Input, GroundTruth> {
  final Input input;
  final GroundTruth groundTruth;

  const DatasetItem(this.input, this.groundTruth);
}

abstract class Dataset<Input, GroundTruth>
    with IterableMixin<DatasetItem<Input, GroundTruth>>
    implements Iterable<DatasetItem<Input, GroundTruth>> {}
