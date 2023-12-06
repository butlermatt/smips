import 'package:test/test.dart';

import 'package:smips/chunk.dart';
import 'package:smips/vm.dart';

void main() {
  group('OpCode Tests', () {
    test('Move', () {
      /*
       * move r0 1.2 # Constant
       * move r1 r0  # Register
       */
      Chunk c = Chunk();
      int pos = c.addConstant(1.2, (0, 3));
      c..writeCode(OpCode.opMove, (0, 0))
        ..write(0)
        ..writeCode(OpCode.opConstant, (0, 3))
        ..write(pos);
      c..writeCode(OpCode.opMove, (1, 0))
        ..write(1)
        ..writeCode(OpCode.opRegister, (1, 3))
        ..write(0);

      var vm = Vm();
      vm.interpret(c);

      expect(vm.registers[0], equals(1.2));
      expect(vm.registers[1], equals(1.2));
      expect(vm.registers[2], equals(0));
    });
    test('Add operation', () {
      Chunk c = Chunk();
      /*
       * move r0 1
       * move r1 2
       * add r0 r0 r1
       */

      int pos = c.addConstant(1, (0, 3));
      c..writeCode(OpCode.opMove, (0, 0))
        ..write(0)
        ..writeCode(OpCode.opConstant, (0, 3))
        ..write(pos);
      pos = c.addConstant(2, (1, 3));
      c..writeCode(OpCode.opMove, (1, 0))
        ..write(1)
        ..writeCode(OpCode.opConstant, (1, 3))
        ..write(pos);
      c..writeCode(OpCode.opAdd, (2, 0))
        ..write(0)
        ..writeCode(OpCode.opRegister, (2, 1))
        ..write(0)
        ..writeCode(OpCode.opRegister, (2, 2))
        ..write(1);

      var vm = Vm();
      vm.interpret(c);
      expect(vm.registers[1], equals(2));
      expect(vm.registers[0], equals(3));
    });

    test('Subtract Operation', () {
      /*
      * sub r0 2 1
      */

      var c = Chunk();
      var pos = c.addConstant(2, (0, 2));
      c..writeCode(OpCode.opSubtract, (0, 0))
        ..write(0)
        ..writeCode(OpCode.opConstant, (0, 2))
        ..write(pos);
      pos = c.addConstant(1, (0, 4));
      c..writeCode(OpCode.opConstant, (0, 4))
        ..write(pos);

      var vm = Vm();
      vm.interpret(c);
      expect(vm.registers[0], equals(1));
    });
    test('Multiply Operation', () {
      /*
      * mul r0 8 4
      */

      var c = Chunk();
      var pos = c.addConstant(8, (0, 2));
      c..writeCode(OpCode.opMultiply, (0, 0))
        ..write(0)
        ..writeCode(OpCode.opConstant, (0, 2))
        ..write(pos);
      pos = c.addConstant(4, (0, 4));
      c..writeCode(OpCode.opConstant, (0, 4))
        ..write(pos);

      var vm = Vm();
      vm.interpret(c);
      expect(vm.registers[0], equals(32));
    });

    test('Divide Operation', () {
      /*
      * div r0 8 4
      */

      var c = Chunk();
      var pos = c.addConstant(8, (0, 2));
      c..writeCode(OpCode.opDivide, (0, 0))
        ..write(0)
        ..writeCode(OpCode.opConstant, (0, 2))
        ..write(pos);
      pos = c.addConstant(4, (0, 4));
      c..writeCode(OpCode.opConstant, (0, 4))
        ..write(pos);

      var vm = Vm();
      vm.interpret(c);
      expect(vm.registers[0], equals(2));
    });

    test('Mod Operation', () {
      /*
      * mod r0 19 12
      * mod r1 19 -12
      */

      var c = Chunk();
      var pos1 = c.addConstant(19, (0, 2));
      c..writeCode(OpCode.opMod, (0, 0))
        ..write(0)
        ..writeCode(OpCode.opConstant, (0, 2))
        ..write(pos1);
      var pos = c.addConstant(12, (0, 3));
      c..writeCode(OpCode.opConstant, (0, 3))
        ..write(pos);
      pos = c.addConstant(-12, (1, 3));
      c..writeCode(OpCode.opMod, (1, 0))
        ..write(1)
        ..writeCode(OpCode.opConstant, (1, 2))
        ..write(pos1)
        ..writeCode(OpCode.opConstant, (1, 3))
        ..write(pos);

      var vm = Vm();
      vm.interpret(c);

      expect(vm.registers[0], equals(7));
      expect(vm.registers[1], equals(-5));
    });
    test('Store Equals', () {
      /*
      * seq r0 8 4
      * seq r1 r0 0
      */

      var c = Chunk();
      var pos = c.addConstant(8, (0, 2));
      c..writeCode(OpCode.opStoreEq, (0, 0))
        ..write(0)
        ..writeCode(OpCode.opConstant, (0, 2))
        ..write(pos);
      pos = c.addConstant(4, (0, 4));
      c..writeCode(OpCode.opConstant, (0, 4))
        ..write(pos);
      pos = c.addConstant(0, (1, 4));
      c..writeCode(OpCode.opStoreEq, (1, 0))
        ..write(1)
        ..writeCode(OpCode.opRegister, (1, 3))
        ..write(0)
        ..writeCode(OpCode.opConstant, (1, 4))
        ..write(pos);

      var vm = Vm();
      vm.interpret(c);
      expect(vm.registers[0], equals(0));
      expect(vm.registers[1], equals(1));
    });
    test('Store Not Equals', () {
      /*
      * sne r0 8 4
      * sne r1 r0 0
      */

      var c = Chunk();
      var pos = c.addConstant(8, (0, 2));
      c..writeCode(OpCode.opStoreNotEq, (0, 0))
        ..write(0)
        ..writeCode(OpCode.opConstant, (0, 2))
        ..write(pos);
      pos = c.addConstant(4, (0, 4));
      c..writeCode(OpCode.opConstant, (0, 4))
        ..write(pos);
      pos = c.addConstant(0, (1, 4));
      c..writeCode(OpCode.opStoreNotEq, (1, 0))
        ..write(1)
        ..writeCode(OpCode.opRegister, (1, 3))
        ..write(0)
        ..writeCode(OpCode.opConstant, (1, 4))
        ..write(pos);

      var vm = Vm();
      vm.interpret(c);
      expect(vm.registers[0], equals(0));
      expect(vm.registers[1], equals(1));
    });
    test('Store Not Equals Zero', () {
      /*
      * snez r0 8
      * snez r1 r0
      */

      var c = Chunk();
      var pos = c.addConstant(8, (0, 2));
      c..writeCode(OpCode.opStoreNotEq, (0, 0))
        ..write(0)
        ..writeCode(OpCode.opConstant, (0, 2))
        ..write(pos);
      c..writeCode(OpCode.opConstant, (0, 2))
        ..write(0);
      pos = c.addConstant(0, (1, 4));
      c..writeCode(OpCode.opStoreNotEq, (1, 0))
        ..write(1)
        ..writeCode(OpCode.opRegister, (1, 3))
        ..write(0)
        ..writeCode(OpCode.opConstant, (1, 4))
        ..write(0);

      var vm = Vm();
      vm.interpret(c);
      expect(vm.registers[0], equals(1));
      expect(vm.registers[1], equals(1));
    });
  });
}
