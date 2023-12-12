import 'dart:typed_data';

import 'src/value.dart';

enum OpCode {
  opNop,
  // Single Operand
  opAbs,
  opCeil,
  opFloor,
  opMove,
  // Dual Operand
  opAdd,
  opAnd,
  opDivide,
  opSubtract,
  opMax,
  opMin,
  opMultiply,
  opMod,
  opOr,
  opStoreGt,
  opStoreLt,
  opStoreEq,
  opStoreNotEq,
  // Aliases
  opSetAlias, // opCode AliasSlot Value(Register | Constant)
  opGetAlias, // opCode AliasSlot
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
  opDevice,
  opRegister,
}

typedef Position = (int line, int char);

class Chunk {
  final BytesBuilder _builder = BytesBuilder();
  final List<Value> values = <Value>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17];
  final List<int> lines = List<int>.filled(128, -1);
  final List<String> aliases = <String>[];

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

  int addAlias(String alias) {
    var ind = aliases.indexOf(alias);
    if (ind == -1) {
      ind = aliases.length;
      aliases.add(alias);
    }

    return ind;
  }

  void take() {
    data = _builder.takeBytes();
  }
}