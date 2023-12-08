import 'dart:typed_data';

import 'src/value.dart';

enum OpCode {
  // Single Operand
  opAbs,
  opMove,
  // Dual Operand
  opAdd,
  opSubtract,
  opMultiply,
  opDivide,
  opMod,
  opStoreGt,
  opStoreLt,
  opStoreEq,
  opStoreNotEq,
  // Misc Opcodes
  opConstant,
  opRegister,
}

typedef Position = (int line, int char);

class Chunk {
  BytesBuilder _builder = BytesBuilder();
  List<Value> values = List<Value>.empty(growable: true);
  List<Position> positions = List<Position>.empty(growable: true);
  List<int> lines = List<int>.filled(128, 0);

  Uint8List? data;
 
  Chunk() {
    values.add(0);
    values.add(1);
  }

  void write(int byte) {
    _builder.addByte(byte);
  }

  void writeCode(OpCode code, Position pos) {
    _builder.addByte(code.index);
    positions.add(pos);
  }

  int addConstant(Value value, Position pos) {
    values.add(value);
    positions.add(pos);
    return values.length - 1;
  }

  void take() {
    data = _builder.takeBytes();
  }
}