import 'package:test/expect.dart';
import 'package:tree_traversal/tree_traversal.dart';

void main(){
  final rootNode = TestNode('A');
  final nodeB = TestNode('B');
  final nodeC = TestNode('C');
  final nodeD = TestNode('D');
  final nodeE = TestNode('E');
  final nodeF = TestNode('F');
  final nodeG = TestNode('G');
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
}

class TestNode {
  TestNode? parent;
  final List<TestNode> children = [];
  final String value;

  TestNode(this.value);
}