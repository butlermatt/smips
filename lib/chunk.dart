import 'dart:typed_data';

import 'src/value.dart';

enum OpCode {
  opNop,
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
  // Stack Handling
  opPeek,
  opPop,
  opPush,
  // Movement
  opBranch,
  opJump,
  // Misc Opcodes
  opRand,
  opConstant,
  opRegister,
}

typedef Position = (int line, int char);

class Chunk {
  final BytesBuilder _builder = BytesBuilder();
  final List<Value> values = <Value>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17];
  final List<int> lines = List<int>.filled(128, -1);

  Uint8List? data;
 
  Chunk();

  void write(int byte) {
    _builder.addByte(byte);
  }

  void writeCode(OpCode code, int line) {
    if (lines[line] < 0) {
      lines[line] = _builder.length;
    }
    _builder.addByte(code.index);
  }

  int addConstant(Value value) {
    if (value is int)  {
      if (value >= 0 && value <= 17) {
        return value;
      }
    }

    var ind = values.indexOf(value);
    if (ind == -1) {
      values.add(value);
      ind = values.length - 1;
    }

    return ind;
  }

  void take() {
    data = _builder.takeBytes();
  }
}