

import 'package:tree_traversal/tree_traversal.dart';

class TestNode extends Childed<TestNode> with TreeTraversable<TestNode> {
  TestNode? parent;
  @override
  final List<TestNode> children = [];
  final String value;

  TestNode(this.value);
}

void main(){
  final x = TestNode("a");
  x.children.add(TestNode("b"));
  for(final y in x.levelOrderIterable()){
    print(y);
  }
}