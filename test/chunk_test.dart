import 'dart:math';

import 'package:smips/chunk.dart';
import 'package:test/test.dart';

void main() {
  group('Chunk Tests', () {
    test('Add constant', () {
      Chunk c = Chunk();

      int pos = c.addConstant(3);
      c..writeCode(OpCode.opConstant, 0)
        ..write(pos);

      expect(c.values[0], equals(0));
      expect(c.values[1], equals(1));
      expect(c.values[3], equals(3));
      expect(c.values.length, equals(18));

      pos = c.addConstant(3.3);
      c..writeCode(OpCode.opConstant, 0)
        ..write(pos);
      
      expect(c.values.length, equals(19));
      expect(c.values[18], equals(3.3));
    });

    test('Line Numbers', () {
      Chunk c = Chunk();

      c..writeCode(OpCode.opAdd, 0)
        ..write(0)
        ..writeCode(OpCode.opConstant, 0)
        ..write(1)
        ..writeCode(OpCode.opConstant, 0)
        ..write(1);
      c..writeCode(OpCode.opSubtract, 1)
        ..write(1)
        ..writeCode(OpCode.opConstant, 1)
        ..write(1)
        ..writeCode(OpCode.opRegister, 1)
        ..write(0);

      expect(c.lines[0], 0);
      expect(c.lines[1], 6);
    });
  });
}