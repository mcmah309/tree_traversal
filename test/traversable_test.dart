

import 'package:test/test.dart';
import 'package:tree_traversal/tree_traversal.dart';

class TreeTraversableTestNode<T> extends Childed<TreeTraversableTestNode<T>> with TreeTraversable<TreeTraversableTestNode<T>> {
  @override
  final List<TreeTraversableTestNode<T>> children = [];
  final T value;

  TreeTraversableTestNode(this.value);
}

class ParentedTreeTraversableTestNode<T> extends Parented<ParentedTreeTraversableTestNode<T>> with ParentedTreeTraversable<ParentedTreeTraversableTestNode<T>> {
  @override
  ParentedTreeTraversableTestNode<T>? parent;
  @override
  final List<ParentedTreeTraversableTestNode<T>> children = [];
  final T value;

  ParentedTreeTraversableTestNode(this.value);
  
  @override
  operator [](int index) {
    return children[index];
  }
  
  @override
  int indexOf(ParentedTreeTraversableTestNode<T> child) {
    return children.indexOf(child);
  }
}

void main() {
  group("TreeTraversable", () {
    late TreeTraversableTestNode<String> rootNode;
    late TreeTraversableTestNode<String> nodeB;
    late TreeTraversableTestNode<String> nodeC;
    late TreeTraversableTestNode<String> nodeD;
    late TreeTraversableTestNode<String> nodeE;
    late TreeTraversableTestNode<String> nodeF;
    late TreeTraversableTestNode<String> nodeG;

    setUp(() {
      // Set up a sample tree structure for testing
      rootNode = TreeTraversableTestNode<String>('A');
      nodeB = TreeTraversableTestNode<String>('B');
      nodeC = TreeTraversableTestNode<String>('C');
      nodeD = TreeTraversableTestNode<String>('D');
      nodeE = TreeTraversableTestNode<String>('E');
      nodeF = TreeTraversableTestNode<String>('F');
      nodeG = TreeTraversableTestNode<String>('G');

      rootNode.children.add(nodeB);
      rootNode.children.add(nodeC);
      nodeB.children.add(nodeD);
      nodeB.children.add(nodeE);
      nodeC.children.add(nodeF);
      nodeC.children.add(nodeG);
    });

    test("TreeTraversable", () {

      // Pre-order traversal
      List<String> values = [];
      rootNode.preOrderIterable().forEach((node) => values.add(node.value));
      expect(values, equals(["A", "B", "D", "E", "C", "F", "G"]));

      // Post-order traversal
      values = [];
      rootNode.postOrderIterable().forEach((node) => values.add(node.value));
      expect(values, equals(["D", "E", "B", "F", "G", "C", "A"]));

      // Level-order traversal
      values = [];
      rootNode.levelOrderIterable().forEach((node) => values.add(node.value));
      expect(values, equals(["A", "B", "C", "D", "E", "F", "G"]));
    });
  });

    group("ParentedTreeTraversal", () {
    late ParentedTreeTraversableTestNode<String> rootNode;
    late ParentedTreeTraversableTestNode<String> nodeB;
    late ParentedTreeTraversableTestNode<String> nodeC;
    late ParentedTreeTraversableTestNode<String> nodeD;
    late ParentedTreeTraversableTestNode<String> nodeE;
    late ParentedTreeTraversableTestNode<String> nodeF;
    late ParentedTreeTraversableTestNode<String> nodeG;

    setUp(() {
      // Set up a sample tree structure for testing
      rootNode = ParentedTreeTraversableTestNode<String>('A');
      nodeB = ParentedTreeTraversableTestNode<String>('B');
      nodeC = ParentedTreeTraversableTestNode<String>('C');
      nodeD = ParentedTreeTraversableTestNode<String>('D');
      nodeE = ParentedTreeTraversableTestNode<String>('E');
      nodeF = ParentedTreeTraversableTestNode<String>('F');
      nodeG = ParentedTreeTraversableTestNode<String>('G');

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

    test("ParentedTreeTraversal", () {
      // Pre-order traversal
      List<String> values = [];
      rootNode.preOrderIterable().forEach((node) => values.add(node.value));
      expect(values, equals(["A", "B", "D", "E", "C", "F", "G"]));

      // Post-order traversal
      values = [];
      rootNode.postOrderIterable().forEach((node) => values.add(node.value));
      expect(values, equals(["D", "E", "B", "F", "G", "C", "A"]));

      // Level-order traversal
      values = [];
      rootNode.levelOrderIterable().forEach((node) => values.add(node.value));
      expect(values, equals(["A", "B", "C", "D", "E", "F", "G"]));

      // Reverse traversal
      values = [];
      nodeG.reverseOrderIterable().forEach((node) => values.add(node.value));
      expect(values, equals(["G", "F", "C", "B", "A"]));

      // Post-order continuation traversal 1
      values = [];
      nodeC.postOrderContinuationIterable().forEach((node) => values.add(node.value));
      expect(values, equals(["F", "G", "C", "A"]));

      // Post-order continuation traversal 2
      values = [];
      nodeB.postOrderContinuationIterable().forEach((node) => values.add(node.value));
      expect(values, equals(["D", "E", "B", "F", "G", "C", "A"]));

      // Post-order continuation traversal 3
      values = [];
      nodeE.postOrderContinuationIterable().forEach((node) => values.add(node.value));
      expect(values, equals(["E", "B", "F", "G", "C", "A"]));

      // Pre-order continuation traversal 1
      values = [];
      nodeC.preOrderContinuationIterable().forEach((node) => values.add(node.value));
      expect(values, equals(["C", "F", "G"]));

      // Pre-order continuation traversal 2
      values = [];
      nodeB.preOrderContinuationIterable().forEach((node) => values.add(node.value));
      expect(values, equals(["B", "D", "E", "C", "F", "G"]));

      // Pre-order continuation traversal 3
      values = [];
      nodeE.preOrderContinuationIterable().forEach((node) => values.add(node.value));
      expect(values, equals(["E", "C", "F", "G"]));
    });
  });


}