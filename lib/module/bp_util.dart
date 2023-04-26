part of '../module.dart';

List<List<double>> _randomWeights(int a, int b) {
  final randomizer = Random.secure();

  // Here's the trap: if you use `List.filled(a, List.filled(b, 0.0))`, then
  // all the lists actually reference to the same object.
  final weights = List.generate(a, (_) => List.filled(b, 0.0));
  for (var i = 0; i < a; i++) {
    for (var j = 0; j < b; j++) {
      weights[i][j] = randomizer.nextDouble() / 1000;
    }
  }
  return weights;
}

List<double> _randomBiases(int n) {
  final randomizer = Random.secure();
  final biases = List.filled(n, 0.0);
  for (var i = 0; i < n; i++) {
    biases[i] = randomizer.nextDouble() / 1000;
  }
  return biases;
}

int argmax(List<double> output) {
  var maxValue = output[0];
  var maxIndex = 0;
  for (var i = 1; i < output.length; i++) {
    final candidate = output[i];
    if (candidate > maxValue) {
      maxValue = candidate;
      maxIndex = i;
    }
  }
  return maxIndex;
}
