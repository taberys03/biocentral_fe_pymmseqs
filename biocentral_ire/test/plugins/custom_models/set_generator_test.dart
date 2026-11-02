import 'package:biocentral/plugins/custom_models/model/set_generator.dart';
import 'package:biocentral/sdk/model/split_set.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final ids = List.generate(100, (i) => 'P$i');
  final generator = SetGenerator(splitRatio: SplitRatio.defaultForMode(SplitSetGenerationMode.generateNew));

  group('SetGenerator.randomFull', () {
    test('produces exact set sizes', () {
      final counts = SetGenerator.countSets(generator.randomFull(ids, seed: 1));
      expect(counts[SplitSet.train], 80);
      expect(counts[SplitSet.val], 10);
      expect(counts[SplitSet.test], 10);
    });

    test('is reproducible for the same seed', () {
      expect(generator.randomFull(ids, seed: 7), equals(generator.randomFull(ids, seed: 7)));
    });

    test('assigns a test sequence even for tiny datasets', () {
      final counts = SetGenerator.countSets(generator.randomFull(['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'], seed: 3));
      expect(counts[SplitSet.test], 1);
    });
  });

  group('SetGenerator.countSets', () {
    test('counts all sets including members', () {
      final counts = SetGenerator.countSets({'a': SplitSet.train, 'b': SplitSet.member, 'c': SplitSet.member});
      expect(counts, {SplitSet.train: 1, SplitSet.val: 0, SplitSet.test: 0, SplitSet.member: 2});
    });
  });

  group('SplitRatio.recommendFor', () {
    test('uses size tiers', () {
      expect(SplitRatio.recommendFor(1000, minTest: 20).full.$3, closeTo(0.10, 1e-9));
      expect(SplitRatio.recommendFor(10000, minTest: 20).full.$3, closeTo(0.075, 1e-9));
      expect(SplitRatio.recommendFor(100000, minTest: 20).full.$3, closeTo(0.05, 1e-9));
    });

    test('raises the test share to reach the minimum test size', () {
      final (train, val, test) = SplitRatio.recommendFor(100, minTest: 20).full;
      expect(test, closeTo(0.20, 1e-9));
      expect(train + val + test, closeTo(1.0, 1e-9));
    });

    test('caps the test share at 30%', () {
      expect(SplitRatio.recommendFor(30, minTest: 20).full.$3, closeTo(0.30, 1e-9));
    });
  });
}
