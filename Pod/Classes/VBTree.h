//
//  VBTree.h
//  VBTree
//
//  Created by Víctor Berga on 11/12/14.
//  Copyright (c) 2014 Victor Berga. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VBTree;

/**
 Algorithms used to traverse trees
 */
typedef NS_ENUM(NSUInteger, VBTreeTraverseAlgorithm) {
  VBTreeTraverseAlgorithmInorder,
  VBTreeTraverseAlgorithmPreorder,
  VbTreeTraverseAlgorithmPostorder,
  VBTreeTraverseAlgorithmBreadthFirst
};

/**
 Traversal block for calling a function on data as we traverse through the tree.
 
 @param node Current traversed node
 @param context Extra context passed by user in the call to the traverse method
 @return BOOL YES to continue traversing, NO to stop
 */
typedef BOOL (^VBTreeTraverseBlock)(VBTree *node, id context);

/**
 You use VBTree to create tree structures that represent hierarchical organizations
 of information. 
 
 In such structures, each tree node has exactly one parent tree
 (except for the root tree, which has no parent) and can have multiple children. 
 Each VBTree object in the structure has a context associated with it; this context
 includes some program-defined data.
 */
@interface VBTree : NSObject

/**
 @name Properties
 */

/**
 Returns the root tree of the receiver
 */
@property (readonly) VBTree *root;
/**
 Returns the number of children in the receiver
 */
@property (readonly) NSUInteger childCount;
/**
 Returns childrens from the receiver
 */
@property (readonly) NSArray *children;
/**
 Returns the context of the receiver
 */
@property id context;
/**
 Returns the parent of the receiver
 */
@property (readonly) VBTree *parent;
/**
 Returns the first child of the receivre
 */
@property (readonly) VBTree *firstChild;
/**
 Returns the next sibling, adjacent to a given tree, in the parent's children list.
 */
@property (readonly) VBTree *nextSibling;

/**
 @name Creating Trees
 */

/**
 Default Initializer

 @param anObject Custom object attachted to tree
 */
- (instancetype)initWithContext:(id)ctx;

/**
 @name Modifying a Tree
 */

/**
 Adds a new child to a tree as the last in its list of children
 
 @param newChild The child tree to add to receiver. If this parameter is a tree 
 which is already a child of any other tree, the behavior is undefined.
 */
- (void)appendChild:(VBTree *)newChild;

/**
 Inserts a new sibling after a given tree.
 
 @param newSibling The sibling to add. newSibling must not have a parent.
 */
- (void)insertSibling:(VBTree *)newSibling;

/**
 Removes all the children of a tree.
 */
- (void)removeAllChildren;

/**
 Adds a new child to the specified tree as the first in its list of children.
 
 @param newChild The child tree to add to receiver. This value must not be a 
 child of another tree.
 */
- (void)prependChild:(VBTree *)newChild;

/**
 Removes the receiver from its parent.
 */
- (void)remove;

/**
 @name Examinging a Tree
 */

/**
 Returns the child of a tree at the specified index.
 
 @param index The index of the child to obtain. The value must be less than the
 number of children in tree.
 
 @return The child tree at index
 */
- (VBTree *)childAtIndex:(NSUInteger)index;

/**
 @name Perform an Operation on Tree Elements
 */

/**
 Calls a function once for each immediate child of a tree.
 
 @param applier The callback function to call once for each child in tree. The 
                function must be able to apply to all the values in the tree.
 @param context Value that is passed to the applier function, but is otherwise unused   
                by this function.
 */

- (void)applyBlockToChildren:(void(^)(VBTree *child, id context))block
                     context:(id)context;

/**
 @name Traversing the Tree
 */

/**
 Traverses the tree and generates an array using the given search algorithm
 
 @param algorithm Traversal algorithm: inorder, postorder, preorder, bfs
 @return An array with all children
 */
- (NSArray *)arrayWithAlgorithm:(VBTreeTraverseAlgorithm)algorithm;

/**
 Traverse the tree in sorted order while executing block on every element
 
 @param algorithm Traversal algorithm: inorder, postorder, preorder, bfs
 @param contextData User defined object that will be passed to block to help do 
                    things like aggregate calculations.
 @param block Traversal block to be called on data as we traverse 
 @return YES if traversed through entire tree, NO if cut short by traversal block
 */
- (BOOL)traverseWithAlgorithm:(VBTreeTraverseAlgorithm)algorithm
                      context:(id)contextData
                 blockForEach:(VBTreeTraverseBlock)block;

@end
