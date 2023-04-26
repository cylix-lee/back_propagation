part of '../module.dart';

class BackPropagation extends LearnableModule<List<double>, int, int> {
  final int inputSize;
  final int hiddenSize;
  final int outputSize;
  final double learningRate;
  final ActivationFunction<double> activationFunction;

  final List<double> _input;
  final List<double> _hidden;
  final List<double> _output;
  final List<List<double>> _inputHiddenWeights;
  final List<List<double>> _hiddenOutputWeights;
  final List<double> _hiddenBiases;
  final List<double> _outputBiases;

  BackPropagation(this.inputSize, this.hiddenSize, this.outputSize,
      {this.learningRate = 0.1, ActivationFunction<double>? activationFunction})
      : activationFunction = activationFunction ?? Sigmoid(),
        _input = List.filled(inputSize, 0),
        _hidden = List.filled(hiddenSize, 0),
        _output = List.filled(outputSize, 0),
        _inputHiddenWeights = _randomWeights(inputSize, hiddenSize),
        _hiddenOutputWeights = _randomWeights(hiddenSize, outputSize),
        _hiddenBiases = _randomBiases(hiddenSize),
        _outputBiases = _randomBiases(outputSize);

  @override
  int forward(List<double> input) {
    assert(input.length == inputSize);

    // Input -> Activated Hidden
    for (var j = 0; j < hiddenSize; j++) {
      _hidden[j] = 0;
      for (var i = 0; i < inputSize; i++) {
        _input[i] = input[i];
        _hidden[j] += input[i] * _inputHiddenWeights[i][j];
      }
      _hidden[j] = activationFunction.activate(_hidden[j] + _hiddenBiases[j]);
    }

    // Activated Hidden -> Activated Output
    for (var k = 0; k < outputSize; k++) {
      _output[k] = 0;
      for (var j = 0; j < hiddenSize; j++) {
        _output[k] += _hidden[j] * _hiddenOutputWeights[j][k];
      }
      _output[k] = activationFunction.activate(_output[k] + _outputBiases[k]);
    }
    return argmax(_output);
  }

  @override
  void backward(int groundTruth, [int? output]) {
    if (output != null) {
      assert(output == argmax(_output));
    }
    final hiddenOutputError = List.filled(outputSize, 0.0);
    for (var k = 0; k < outputSize; k++) {
      final difference = k == groundTruth ? 1 - _output[k] : -_output[k];
      hiddenOutputError[k] =
          difference * activationFunction.derivate(_output[k]);
    }

    final inputHiddenError = List.filled(hiddenSize, 0.0);
    for (var j = 0; j < hiddenSize; j++) {
      for (var k = 0; k < outputSize; k++) {
        inputHiddenError[j] +=
            hiddenOutputError[k] * _hiddenOutputWeights[j][k];
      }
      inputHiddenError[j] *= activationFunction.derivate(_hidden[j]);
    }

    // Adjust parameters and thresholds.
    for (var k = 0; k < outputSize; k++) {
      _outputBiases[k] += learningRate * hiddenOutputError[k];
      for (var j = 0; j < hiddenSize; j++) {
        _hiddenOutputWeights[j][k] +=
            learningRate * hiddenOutputError[k] * _hidden[j];
      }
    }
    for (var j = 0; j < hiddenSize; j++) {
      _hiddenBiases[j] += learningRate * inputHiddenError[j];
      for (var i = 0; i < inputSize; i++) {
        _inputHiddenWeights[i][j] +=
            learningRate * inputHiddenError[j] * _input[i];
      }
    }
  }
}
