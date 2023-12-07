import 'package:test/test.dart';
import 'package:tree_traversal/tree_traversal.dart';

class TestNode {
  TestNode? parent;
  final List<TestNode> children = [];
  final String value;

  TestNode(this.value);

  int getChildsIndex(TestNode child) {
    return children.indexWhere((node) => node == child);
  }
}

void main() {
  group("Tree Traversal", () {
    late TestNode rootNode;
    late TestNode nodeB;
    late TestNode nodeC;
    late TestNode nodeD;
    late TestNode nodeE;
    late TestNode nodeF;
    late TestNode nodeG;

    setUp(() {
      // Set up a sample tree structure for testing
      rootNode = TestNode('A');
      nodeB = TestNode('B');
      nodeC = TestNode('C');
      nodeD = TestNode('D');
      nodeE = TestNode('E');
      nodeF = TestNode('F');
      nodeG = TestNode('G');

      rootNode.children.add(nodeB);
      rootNode.children.add(nodeC);
      nodeB.parent = rootNode;
      nodeC.parent = rootNode;
      nodeB.children.add(nodeD);
      nodeB.children.add(nodeE);
      nodeD.parent = nodeB;
      nodeE.parent = nodeB;
      nodeC.children.add(nodeF);
      nodeC.children.add(nodeG);
      nodeF.parent = nodeC;
      nodeG.parent = nodeC;
    });

    test("TreeTraversal", () {
      final treeTraversal = TreeTraversal<TestNode>((node) => node.children);

      // Pre-order traversal
      List<String> values = [];
      treeTraversal.preOrderIterable(rootNode).forEach((node) => values.add(node.value));
      expect(values, equals(["A", "B", "D", "E", "C", "F", "G"]));

      // Post-order traversal
      values = [];
      treeTraversal.postOrderIterable(rootNode).forEach((node) => values.add(node.value));
      expect(values, equals(["D", "E", "B", "F", "G", "C", "A"]));

      // Level-order traversal
      values = [];
      treeTraversal.levelOrderIterable(rootNode).forEach((node) => values.add(node.value));
      expect(values, equals(["A", "B", "C", "D", "E", "F", "G"]));
    });

    test("ParentedTreeTraversal", () {
      final treeTraversal = ParentedTreeTraversal<TestNode>((node) => node.children, (node) => node.parent,
          (node, i) => node.children[i], (parent, child) => parent.getChildsIndex(child));

      // Pre-order traversal
      List<String> values = [];
      treeTraversal.preOrderIterable(rootNode).forEach((node) => values.add(node.value));
      expect(values, equals(["A", "B", "D", "E", "C", "F", "G"]));

      // Post-order traversal
      values = [];
      treeTraversal.postOrderIterable(rootNode).forEach((node) => values.add(node.value));
      expect(values, equals(["D", "E", "B", "F", "G", "C", "A"]));

      // Level-order traversal
      values = [];
      treeTraversal.levelOrderIterable(rootNode).forEach((node) => values.add(node.value));
      expect(values, equals(["A", "B", "C", "D", "E", "F", "G"]));

      // Reverse traversal
      values = [];
      treeTraversal.reverseOrderIterable(nodeG).forEach((node) => values.add(node.value));
      expect(values, equals(["G", "F", "C", "B", "A"]));

      // Post-order continuation traversal 1
      values = [];
      treeTraversal.postOrderContinuationIterable(nodeC).forEach((node) => values.add(node.value));
      expect(values, equals(["F", "G", "C", "A"]));

      // Post-order continuation traversal 2
      values = [];
      treeTraversal.postOrderContinuationIterable(nodeB).forEach((node) => values.add(node.value));
      expect(values, equals(["D", "E", "B", "F", "G", "C", "A"]));

      // Post-order continuation traversal 3
      values = [];
      treeTraversal.postOrderContinuationIterable(nodeE).forEach((node) => values.add(node.value));
      expect(values, equals(["E", "B", "F", "G", "C", "A"]));

      // Pre-order continuation traversal 1
      values = [];
      treeTraversal.preOrderContinuationIterable(nodeC).forEach((node) => values.add(node.value));
      expect(values, equals(["C", "F", "G"]));

      // Pre-order continuation traversal 2
      values = [];
      treeTraversal.preOrderContinuationIterable(nodeB).forEach((node) => values.add(node.value));
      expect(values, equals(["B", "D", "E", "C", "F", "G"]));

      // Pre-order continuation traversal 3
      values = [];
      treeTraversal.preOrderContinuationIterable(nodeE).forEach((node) => values.add(node.value));
      expect(values, equals(["E", "C", "F", "G"]));
    });
  });
}
