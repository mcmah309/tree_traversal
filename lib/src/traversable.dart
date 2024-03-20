import '../tree_traversal.dart';

/// A class that has children.
abstract class Childed<T extends Childed<T>> {
  /// Gets the children of this.
  Iterable<T> get children;
}

/// Tree traversal methods for a class that has children.
mixin TreeTraversable<T extends Childed<T>> on Childed<T> {
  final TreeTraversal<Childed<T>> _treeTraversal = TreeTraversal(getChildren: (e) => e.children);

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

//************************************************************************//

/// A class that has a parent and children.
abstract class Parented<T extends Parented<T>> implements Childed<T> {
  /// Gets the parent of this.
  T? get parent;
  /// Gets the index of a child of this.
  int indexOf(T child);
  /// Gets the child at the given index.
  operator [](int index);
}

/// Tree traversal methods for a class class that has a parent and children.
mixin ParentedTreeTraversable<T extends Parented<T>> on Parented<T> {
  @override
  final ParentedTreeTraversal<Parented<T>> _treeTraversal = ParentedTreeTraversal(
      getChildren: (e) => e.children,
      getParent: (e) => e.parent,
      getChildAtIndex: (e, i) => e[i],
      getChildsIndex: (parent, child) => parent.indexOf(child as T));

  Iterable<T> levelOrderIterable() {
    return _treeTraversal.levelOrderIterable(this).cast<T>();
  }

  Iterable<T> postOrderIterable() {
    return _treeTraversal.postOrderIterable(this).cast<T>();
  }

  Iterable<T> preOrderIterable() {
    return _treeTraversal.preOrderIterable(this).cast<T>();
  }

  Iterable<T> reverseOrderIterable() {
    return _treeTraversal.reverseOrderIterable(this).cast<T>();
  }

  Iterable<T> postOrderContinuationIterable(){
    return _treeTraversal.postOrderContinuationIterable(this).cast<T>();
  }

  Iterable<T> preOrderContinuationIterable(){
    return _treeTraversal.preOrderContinuationIterable(this).cast<T>();
  }
}