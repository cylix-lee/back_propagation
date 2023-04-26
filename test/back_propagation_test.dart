import 'package:back_propagation/bitmap.dart';
import 'package:back_propagation/dataset.dart';
import 'package:test/test.dart';

void main() {
  test('Read YALE bitmaps', () {
    final bitmap = Bitmap("YALE\\subject01_1.bmp", dropPaddingPixels: 2);
    assert(bitmap.normalizedPixels.length == 8000);
  });

  test('Read bitmap for only pixels', () {
    final pixels =
        Bitmap.onlyReadPixels("YALE/subject01_1.bmp", dropPaddingPixels: 2);
    assert(pixels.length == 8000);
  });

  test('Split YALE dataset', () {
    final dataset = YaleDataset("YALE");
    final splitedDataset = dataset.split(5);
    var index = 0;
    for (var item in splitedDataset.trainSet) {
      assert(item.groundTruth == index ~/ 5 + 1);
      index++;
    }
  });
}
