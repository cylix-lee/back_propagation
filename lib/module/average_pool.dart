part of '../module.dart';

class AveragePoolingLayer extends Module<List<double>, List<double>> {
  final int kernelSize;
  final int inputLineWidth;

  AveragePoolingLayer(this.kernelSize, this.inputLineWidth);

  @override
  List<double> forward(List<double> input) {
    assert(input.length % inputLineWidth == 0);

    final width = inputLineWidth;
    final height = input.length ~/ width;
    assert(width % kernelSize == 0);
    assert(height % kernelSize == 0);

    final neoWidth = width ~/ kernelSize;
    final neoHeight = height ~/ kernelSize;
    final output = List.filled(neoWidth * neoHeight, 0.0);
    for (var i = 0; i < neoHeight; i++) {
      for (var j = 0; j < neoWidth; j++) {
        final startX = i * kernelSize;
        final startY = j * kernelSize;
        var sum = 0.0;
        for (var x = startX; x < startX + kernelSize; x++) {
          for (var y = startY; y < startY + kernelSize; y++) {
            sum += input[x * width + y];
          }
        }
        output[i * (width ~/ kernelSize) + j] = sum;
      }
    }
    return output;
  }
}
