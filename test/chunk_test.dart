import 'package:smips/chunk.dart';
import 'package:test/test.dart';

void main() {
  group('Chunk Tests', () {
    test('Add constant', () {
      Chunk c = Chunk();

      int pos = c.addConstant(3, (0, 3));
      c..writeCode(OpCode.opConstant, (0, 3))
        ..write(pos);

      expect(c.values[0], equals(0));
      expect(c.values[1], equals(1));
      expect(c.values[2], equals(3));
    });
  });
}