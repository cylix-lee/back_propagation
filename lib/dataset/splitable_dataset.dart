part of '../dataset.dart';

class TrivialDataset<Input, GroundTruth> extends Dataset<Input, GroundTruth> {
  final List<DatasetItem<Input, GroundTruth>> items =
      List.empty(growable: true);

  void add(DatasetItem<Input, GroundTruth> item) => items.add(item);

  @override
  Iterator<DatasetItem<Input, GroundTruth>> get iterator => items.iterator;
}

class SplitedTrainTestSet<Input, GroundTruth> {
  final Dataset<Input, GroundTruth> trainSet;
  final Dataset<Input, GroundTruth> testSet;

  const SplitedTrainTestSet(this.trainSet, this.testSet);
}

abstract class SplitableDataset<Input, GroundTruth>
    extends Dataset<Input, GroundTruth> {
  SplitedTrainTestSet<Input, GroundTruth> split(int trainSetSize);
}
