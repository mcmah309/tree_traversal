

import '../tree_traversal.dart';

abstract interface class Childed<T extends Childed<T>> {
  Iterable<T> get children;
}

mixin Traversable<T extends Childed<T>> on Childed<T> {
  final TreeTraversal<Childed<T>> _treeTraversal = TreeTraversal((e) => e.children);

  Iterable<T> levelOrderIterable() {
    return _treeTraversal.levelOrderIterable(this).cast<T>();
  }

  Iterable<T> postOrderIterable() {
    return _treeTraversal.postOrderIterable(this).cast<T>();
  }

  Iterable<T> preOrderIterable() {
    return _treeTraversal.preOrderIterable(this).cast<T>();
  }

}

class TestNode extends Childed<TestNode> with Traversable<TestNode> {
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