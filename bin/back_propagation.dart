import 'package:back_propagation/dataset.dart';
import 'package:back_propagation/module.dart';

const hiddenNeurons = 256;
const epoch = 100;

void main(List<String> args) {
  final stopwatch = Stopwatch();
  final model = BackPropagation(500, hiddenNeurons, 15);
  final dataset = AveragePooledYaleDataset("YALE");
  final splitedDataset = dataset.split(5);

  // Training.
  print("Start training...");
  stopwatch.start();
  for (var e = 0; e < epoch; e++) {
    var correctItems = 0;
    for (final item in splitedDataset.trainSet) {
      final output = model(item.input);
      final groundTruth = item.groundTruth;
      if (output == groundTruth) {
        correctItems++;
      }
      model.backward(groundTruth);
    }
    final accuracy = correctItems / splitedDataset.trainSet.length;
    print("Epoch $e, accuracy $accuracy");
  }
  stopwatch.stop();
  print("Finished model training "
      "in ${stopwatch.elapsed.inMilliseconds / 1000}s\n");

  // Testing.
  print("Start testing model...");
  var correctCases = 0;
  stopwatch.reset();
  stopwatch.start();
  for (final item in splitedDataset.testSet) {
    final output = model(item.input);
    if (output == item.groundTruth) {
      correctCases++;
    }
  }
  stopwatch.stop();
  final accuracy = correctCases / splitedDataset.testSet.length;
  print("Finished testing model in ${stopwatch.elapsed.inMilliseconds / 1000}s,"
      " with accuracy $accuracy");
}
