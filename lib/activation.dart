import 'dart:math';

abstract class ActivationFunction<T> {
  T activate(T x);
  T derivate(T x);
}

class Sigmoid extends ActivationFunction<double> {
  @override
  double activate(double x) => 1 / (1 + exp(-x));

  @override
  double derivate(double x) => x * (1 - x);
}
