import 'dart:math';

import 'activation.dart';

part 'module/average_pool.dart';
part 'module/bp.dart';
part 'module/bp_util.dart';

abstract class Module<Input, Output> {
  Output forward(Input input);

  // For convenience.
  Output call(Input input) => forward(input);
}

abstract class LearnableModule<Input, Output, GroundTruth>
    extends Module<Input, Output> {
  void backward(GroundTruth groundTruth, [Output? output]);
}
