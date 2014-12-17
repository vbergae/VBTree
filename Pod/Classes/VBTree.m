//
//  VBTree.m
//  VBTree
//
//  Created by Víctor Berga on 11/12/14.
//  Copyright (c) 2014 Victor Berga. All rights reserved.
//

#import "VBTree.h"

static VBTree * CFTreeToVBTree(CFTreeRef tree);
static void TreeApplierFunction(const void *value, void *context);
static NSString * const kFunctionContextBlockKey    = @"block";
static NSString * const kFunctionContextContextKey  = @"context";

@interface VBTree()

@property CFTreeRef tree;

@end

@implementation VBTree

#pragma mark -
#pragma mark Properties

- (VBTree *)root
{
  CFTreeRef rootTree = CFTreeFindRoot(self.tree);
  
  return CFTreeToVBTree(rootTree);
}

- (NSUInteger)childCount
{
  return CFTreeGetChildCount(self.tree);
}

- (NSArray *)children
{
  NSUInteger count = self.childCount;
  CFTreeRef *childrenTrees = calloc(count, sizeof(CFTreeRef));
  CFTreeGetChildren(self.tree, childrenTrees);
  
  NSMutableArray *children = [[NSMutableArray alloc] initWithCapacity:count];
  for (NSUInteger i = 0; i < count; ++i) {
    CFTreeRef tree = childrenTrees[i];
    VBTree *object = CFTreeToVBTree(tree);
    
    [children addObject:object];
  }
  
  return children;
}

- (VBTree *)parent
{
  CFTreeRef parentTree = CFTreeGetParent(self.tree);
  
  return CFTreeToVBTree(parentTree);
}

- (VBTree *)firstChild
{
  CFTreeRef childTree = CFTreeGetFirstChild(self.tree);
  
  return CFTreeToVBTree(childTree);
}

- (VBTree *)nextSibling
{
  CFTreeRef sibling = CFTreeGetNextSibling(self.tree);
  return CFTreeToVBTree(sibling);
}

#pragma mark -
#pragma mark Initialization

- (instancetype)initWithContext:(id)objectContext
{
  NSParameterAssert(objectContext);
  
  self = [super init];
  if (self) {
    self.context = objectContext;
    
    CFTreeContext ctx;
    ctx.version = 0;
    ctx.info    = (void *)CFBridgingRetain(self);
    ctx.retain  = NULL;
    ctx.release = NULL;
    
    self.tree = CFTreeCreate(NULL, &ctx);
  }
  
  return self;
}

#pragma mark -
#pragma mark Modifying a Tree

- (void)appendChild:(VBTree *)newChild
{
  CFTreeAppendChild(self.tree, newChild.tree);
}

- (void)insertSibling:(VBTree *)newSibling
{
  CFTreeInsertSibling(self.tree, newSibling.tree);
}

- (void)removeAllChildren
{
  CFTreeRemoveAllChildren(self.tree);
}

- (void)prependChild:(VBTree *)newChild
{
  CFTreePrependChild(self.tree, newChild.tree);
}

- (void)remove
{
  CFTreeRemove(self.tree);
}

#pragma mark -
#pragma mark Examining a Tree

- (VBTree *)childAtIndex:(NSUInteger)index
{
  CFTreeRef childTree = CFTreeGetChildAtIndex(self.tree, index);
  
  return CFTreeToVBTree(childTree);
}

#pragma mark -
#pragma mark Performing an Operation on Tree Elements

- (void)applyBlockToChildren:(void (^)(VBTree *, id))block context:(id)context
{
  NSDictionary *functionContext = @{kFunctionContextBlockKey: block,
                                    kFunctionContextContextKey: context};
  
  CFTreeApplyFunctionToChildren(self.tree,
                                &TreeApplierFunction,
                                (__bridge void *)(functionContext));
}

#pragma mark -
#pragma mark Traversing the tree

- (NSArray *)arrayWithAlgorithm:(VBTreeTraverseAlgorithm)algorithm
{
  __block NSMutableArray *result = [[NSMutableArray alloc] init];
  [self traverseWithAlgorithm:algorithm
                      context:nil
                 blockForEach:^BOOL(VBTree *node, id context)
  {
    [result addObject:node];
    return YES;
  }];
  
  return result;
}

- (BOOL)traverseWithAlgorithm:(VBTreeTraverseAlgorithm)algorithm
                      context:(id)contextData
                 blockForEach:(VBTreeTraverseBlock)block
{
  switch (algorithm) {
    case VBTreeTraverseAlgorithmBreadthFirst:
      return [self traverseBFSWithContext:contextData blockForEach:block];
      break;
      
    default:
      return NO;
      break;
  }
}

#pragma mark -
#pragma mark Debug

- (NSString *)description
{
  return self.debugDescription;
}

- (NSString *)debugDescription
{
  return [NSString stringWithFormat:@"VBTree: %@",
          [(id<NSObject>)self.context debugDescription]];
}

#pragma mark - 
#pragma mark Private methods

- (BOOL)traverseBFSWithContext:(id)context
                  blockForEach:(VBTreeTraverseBlock)block
{
  BOOL treeCompleted                = YES;
  NSMutableOrderedSet *visitedNodes = [[NSMutableOrderedSet alloc] init];
  NSMutableOrderedSet *queue        = [[NSMutableOrderedSet alloc] init];
  
  [visitedNodes addObject:self];
  [queue addObject:self];
  
  while(queue.count > 0) {
    VBTree *node = queue.firstObject;
    
    BOOL continueTraversing = YES;
    if (block) {
      continueTraversing = block(node, context);
    }
    
    if (!continueTraversing) {
      treeCompleted = NO;
      break;
    }
    
    NSMutableOrderedSet *newNodes = [NSMutableOrderedSet orderedSetWithArray:
                                     node.children];
    [newNodes minusOrderedSet:visitedNodes];
    [visitedNodes unionOrderedSet:newNodes];
    
    [queue addObjectsFromArray:newNodes.array];
    [queue removeObjectAtIndex:0];
  }
  
  return treeCompleted;
}

@end

VBTree * CFTreeToVBTree(CFTreeRef tree)
{
  if (tree == NULL)
    return nil;
  
  CFTreeContext ctx;
  CFTreeGetContext(tree, &ctx);
  
  return (__bridge VBTree *)ctx.info;
}

static void TreeApplierFunction(const void *value, void *context) {
  void(^block)(VBTree *, id) = [(__bridge NSDictionary *)context
                                valueForKey:kFunctionContextBlockKey];
  id blockContext = [(__bridge NSDictionary *)context
                     valueForKey:kFunctionContextContextKey];
  
  if (block) {
    CFTreeRef treeRef = (CFTreeRef)value;
    VBTree *tree = CFTreeToVBTree(treeRef);
    block(tree, blockContext);
  }
}
