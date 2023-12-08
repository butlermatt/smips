import 'chunk.dart';
import 'src/value.dart';

enum InterpreterResult {
  ok, compileError, runtimeError
}

class Vm {
  Chunk? chunk;
  List<num> registers = List<num>.filled(18, 0);
  List<num> stack = List<num>.filled(512, 0);
  int ip = 0;

  Vm();

  InterpreterResult interpret(Chunk chunk) {
    ip = 0;
    this.chunk = chunk;

    return run();
  }

  OpCode readOpcode() => OpCode.values[_readByte()];

  InterpreterResult run() {
    chunk?.take();

    while (true) {
      var inst = readOpcode();
      switch (inst) {
        // Single Operand commands
        case OpCode.opAbs:
        case OpCode.opMove:
          handleSingleOp(inst);
        // Dual Operand Commands
        case OpCode.opAdd:
        case OpCode.opSubtract:
        case OpCode.opMultiply:
        case OpCode.opDivide:
        case OpCode.opMod:
        case OpCode.opStoreEq:
        case OpCode.opStoreNotEq:
        case OpCode.opStoreGt:
        case OpCode.opStoreLt:
          handleBinaryOp(inst);
          break;
        default:
          return InterpreterResult.compileError;
      }
      if (ip == chunk!.data!.length) {
        break;
      }
    }

    return InterpreterResult.ok;
  }

  int _readByte() => chunk!.data![ip++];

  Value _readConstant() {
    var val = _readByte();
    if (chunk!.values.length < val) {
      throw IndexError.withLength(val, chunk!.values.length);
    }
    return chunk!.values[val];
  }
  Value _readRegister() {
    Value val = readValue();
    if (val is! int) {
      throw ArgumentError('Register must be integer, got: $val');
    }
    return registers[val]; 
  }

  Value readValue() {
    var inst = readOpcode();
    return switch (inst) {
      OpCode.opConstant => _readConstant(),
      OpCode.opRegister => _readRegister(),
      _ => throw StateError('Should not reach here'),
    };
  }

  void handleSingleOp(OpCode opCode) {
    var dest = readValue() as int;
    var val = readValue();

    registers[dest] = switch(opCode) {
      OpCode.opMove => val,
      OpCode.opAbs => val.abs(),
      _ => throw StateError('Should not reach here')
    };
  }

  void handleBinaryOp(OpCode opCode) {
    var dest = readValue() as int;
    var val1 = readValue();
    var val2 = readValue();

    registers[dest] = switch(opCode) {
      OpCode.opAdd => val1 + val2,
      OpCode.opSubtract => val1 - val2,
      OpCode.opMultiply => val1 * val2,
      OpCode.opDivide => val1 / val2,
      OpCode.opMod => (val1 - (val2 * (val1 / val2).floor())),
      OpCode.opStoreEq => val1 == val2 ? 1 : 0,
      OpCode.opStoreNotEq => val1 != val2 ? 1 : 0,
      OpCode.opStoreGt => val1 > val2 ? 1 : 0,
      OpCode.opStoreLt => val1 < val2 ? 1 : 0,
      _ => throw StateError("Don't get here"),
    };
  }

}