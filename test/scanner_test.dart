import 'package:smips/chunk.dart';
import 'package:smips/scanner.dart';
import 'package:test/test.dart';

void main() {
  group('Scanner Tests', () {
    test('Comment Line first', () {
      var input = '# This is a comment\nadd r0 0 1';

      var s = Scanner(input);
      s.scanInstruction();
      s.scanInstruction();

      s.chunk.take();
      expect(s.chunk.data!.length, equals(8));
      expect(s.chunk.data![0], equals(OpCode.opNop.index));
      expect(s.chunk.data![1], equals(OpCode.opAdd.index));
      expect(s.chunk.data![2], equals(OpCode.opConstant.index));
      expect(s.chunk.data![3], equals(0));
      expect(s.chunk.data![4], equals(OpCode.opConstant.index));
      expect(s.chunk.data![5], equals(0));
      expect(s.chunk.data![6], equals(OpCode.opConstant.index));
      expect(s.chunk.data![7], equals(1));
    });

    test('Hex Values', () {
      var input = r'add r0 $0 $F';

      var s = Scanner(input);
      s.scanInstruction();

      s.chunk.take();
      expect(s.chunk.data!.length, equals(7));
      expect(s.chunk.data![0], equals(OpCode.opAdd.index));
      expect(s.chunk.data![1], equals(OpCode.opConstant.index));
      expect(s.chunk.data![2], equals(0));
      expect(s.chunk.data![3], equals(OpCode.opConstant.index));
      expect(s.chunk.data![4], equals(0));
      expect(s.chunk.data![5], equals(OpCode.opConstant.index));
      expect(s.chunk.data![6], equals(15));
    });

    test('Binary Value', () {
      var input = r'add r0 %0 %1111';

      var s = Scanner(input);
      s.scanInstruction();

      s.chunk.take();
      expect(s.chunk.data!.length, equals(7));
      expect(s.chunk.data![0], equals(OpCode.opAdd.index));
      expect(s.chunk.data![1], equals(OpCode.opConstant.index));
      expect(s.chunk.data![2], equals(0));
      expect(s.chunk.data![3], equals(OpCode.opConstant.index));
      expect(s.chunk.data![4], equals(0));
      expect(s.chunk.data![5], equals(OpCode.opConstant.index));
      expect(s.chunk.data![6], equals(15));
    });

    test('Invalid Registry throws', (){
      var input = 'add r18 r0 1';

      var s = Scanner(input);
      expect(() => s.scanInstruction(), throwsArgumentError);
    });

    test('Add Instruction register value', () {
      var input = 'add r0 r0 1';
      
      var s = Scanner(input);
      s.scanInstruction();

      s.chunk.take();
      expect(s.chunk.data!.length, equals(8));
      expect(s.chunk.data![0], equals(OpCode.opAdd.index));
      expect(s.chunk.data![1], equals(OpCode.opConstant.index));
      expect(s.chunk.data![2], equals(0));
      expect(s.chunk.data![3], equals(OpCode.opRegister.index));
      expect(s.chunk.data![4], equals(OpCode.opConstant.index));
      expect(s.chunk.data![5], equals(0));
      expect(s.chunk.data![6], equals(OpCode.opConstant.index));
      expect(s.chunk.data![7], equals(1));
    });
    
    test('Add Instruction', () {
      var input = 'add r0 0 1';

      var s = Scanner(input);
      s.scanInstruction();

      s.chunk.take();
      expect(s.chunk.data!.length, equals(7));
      expect(s.chunk.data![0], equals(OpCode.opAdd.index));
      expect(s.chunk.data![1], equals(OpCode.opConstant.index));
      expect(s.chunk.data![2], equals(0));
      expect(s.chunk.data![3], equals(OpCode.opConstant.index));
      expect(s.chunk.data![4], equals(0));
      expect(s.chunk.data![5], equals(OpCode.opConstant.index));
      expect(s.chunk.data![6], equals(1));
    });

    test('Store Greater Than', () {
      var input = 'sgt r0 r0 1';
      
      var s = Scanner(input);
      s.scanInstruction();

      s.chunk.take();
      expect(s.chunk.data!.length, equals(8));
      expect(s.chunk.data![0], equals(OpCode.opStoreGt.index));
      expect(s.chunk.data![1], equals(OpCode.opConstant.index));
      expect(s.chunk.data![2], equals(0));
      expect(s.chunk.data![3], equals(OpCode.opRegister.index));
      expect(s.chunk.data![4], equals(OpCode.opConstant.index));
      expect(s.chunk.data![5], equals(0));
      expect(s.chunk.data![6], equals(OpCode.opConstant.index));
      expect(s.chunk.data![7], equals(1));
    });
  });
}