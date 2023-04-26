part of '../dataset.dart';

class YaleDataset extends SplitableDataset<List<double>, int> {
  static const int subjectCount = 15;
  static const int samplesPerSubject = 11;

  final List<DatasetItem<List<double>, int>> items = List.empty(growable: true);

  YaleDataset(String directoryPath) {
    for (var subject = 1; subject <= subjectCount; subject++) {
      for (var sample = 1; sample <= samplesPerSubject; sample++) {
        final subjectIndex = subject < 10 ? "0$subject" : "$subject";
        final path = "$directoryPath/subject${subjectIndex}_$sample.bmp";
        items.add(DatasetItem(
            Bitmap.onlyReadPixels(path, dropPaddingPixels: 2), subject - 1));
      }
    }
  }

  @override
  Iterator<DatasetItem<List<double>, int>> get iterator => items.iterator;

  @override
  SplitedTrainTestSet<List<double>, int> split(int trainSetSize) {
    final trainSet = TrivialDataset<List<double>, int>();
    final testSet = TrivialDataset<List<double>, int>();
    for (var subject = 0; subject < subjectCount; subject++) {
      for (var sample = 0; sample < samplesPerSubject; sample++) {
        final index = subject * samplesPerSubject + sample;
        final item = items[index];
        if (sample < trainSetSize) {
          trainSet.add(item);
        } else {
          testSet.add(item);
        }
      }
    }
    return SplitedTrainTestSet(trainSet, testSet);
  }
}

class AveragePooledYaleDataset extends YaleDataset {
  AveragePooledYaleDataset(super.directoryPath) {
    final averagePool = AveragePoolingLayer(4, 80);
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      items[i] = DatasetItem(averagePool(item.input), item.groundTruth);
    }
  }
}
