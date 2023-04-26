import 'dart:io';
import 'dart:typed_data';

class BitmapFileHeader {
  static const structSize = 14;

  final List<int> magicNumber;
  final int fileSize;
  final int offbits;

  BitmapFileHeader.fromBytes(ByteData bytes)
      : magicNumber = [bytes.getUint8(0), bytes.getUint8(1)],
        fileSize = bytes.getUint32(2, Endian.little),
        offbits = bytes.getUint32(10, Endian.little);

  BitmapFileHeader.fromFile(RandomAccessFile file)
      : this.fromBytes(file.readSync(structSize).buffer.asByteData());
}

class BitmapInformationHeader {
  static const structSize = 40;

  final int informationHeaderSize;
  final int width;
  final int height;
  final int planes;
  final int bitCount;
  final int compression;
  final int imageSize;
  final int horizontalPixelsPerMeter;
  final int verticalPixelsPerMeter;
  final int colorUsed;
  final int colorImportant;

  BitmapInformationHeader.fromBytes(ByteData bytes)
      : informationHeaderSize = bytes.getUint32(0, Endian.little),
        width = bytes.getUint32(4, Endian.little),
        height = bytes.getUint32(8, Endian.little),
        planes = bytes.getUint16(12, Endian.little),
        bitCount = bytes.getUint16(14, Endian.little),
        compression = bytes.getUint32(16, Endian.little),
        imageSize = bytes.getUint32(20, Endian.little),
        horizontalPixelsPerMeter = bytes.getUint32(24, Endian.little),
        verticalPixelsPerMeter = bytes.getUint32(28, Endian.little),
        colorUsed = bytes.getUint32(32, Endian.little),
        colorImportant = bytes.getUint32(36, Endian.little);

  BitmapInformationHeader.fromFile(RandomAccessFile file)
      : this.fromBytes(file.readSync(structSize).buffer.asByteData());
}

class Bitmap {
  static List<double> onlyReadPixels(String path, {int dropPaddingPixels = 0}) {
    final file = File(path).openSync();
    final fileHeader = BitmapFileHeader.fromFile(file);
    final _ = BitmapInformationHeader.fromFile(file);
    final colorMapSize = fileHeader.offbits -
        BitmapFileHeader.structSize -
        BitmapInformationHeader.structSize;

    if (colorMapSize != 0) {
      file.readSync(colorMapSize).toList();
    }

    // Read image data.
    final imageSize = fileHeader.fileSize - fileHeader.offbits;
    final pixels = file.readSync(imageSize - dropPaddingPixels);
    return pixels.map((e) => e / 255).toList();
  }

  final BitmapFileHeader fileHeader;
  final BitmapInformationHeader informationHeader;
  late final List<int>? colorMap;
  late final List<double> normalizedPixels;

  /// Loads a bitmap image from [RandomAccessFile].
  ///
  /// This constructor is not often used, by users. Please consider using a
  /// simplier constructor `Bitmap(String path)`
  Bitmap.fromFile(RandomAccessFile file, {int dropPaddingPixels = 0})
      : fileHeader = BitmapFileHeader.fromFile(file),
        informationHeader = BitmapInformationHeader.fromFile(file) {
    // Read color map data if any.
    final colorMapSize = fileHeader.offbits -
        BitmapFileHeader.structSize -
        BitmapInformationHeader.structSize;
    if (colorMapSize != 0) {
      colorMap = file.readSync(colorMapSize).toList();
    } else {
      colorMap = null;
    }

    // Read image data.
    final imageSize = fileHeader.fileSize - fileHeader.offbits;
    final pixels = file.readSync(imageSize - dropPaddingPixels);
    normalizedPixels = pixels.map((e) => e / 255).toList();
  }

  Bitmap(String path, {int dropPaddingPixels = 0})
      : this.fromFile(File(path).openSync(),
            dropPaddingPixels: dropPaddingPixels);
}
