//
//  VBTree.m
//  VBTree
//
//  Created by Víctor Berga on 11/12/14.
//  Copyright (c) 2014 Victor Berga. All rights reserved.
//

#import "VBTree.h"

@interface VBTree()

@property CFTreeRef tree;
@property (readwrite) id context;

- (VBTree *)CFTreeToVBTree:(CFTreeRef)tree;

@end

@implementation VBTree

#pragma mark -
#pragma mark Properties

- (VBTree *)root
{
  CFTreeRef rootTree = CFTreeFindRoot(self.tree);
  
  return [self CFTreeToVBTree:rootTree];
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
    VBTree *object = [self CFTreeToVBTree:tree];
    
    [children addObject:object];
  }
  
  return children;
}

- (VBTree *)parent
{
  CFTreeRef parentTree = CFTreeGetParent(self.tree);
  
  return [self CFTreeToVBTree:parentTree];
}

- (VBTree *)firstChild
{
  CFTreeRef childTree = CFTreeGetFirstChild(self.tree);
  
  return [self CFTreeToVBTree:childTree];
}

- (VBTree *)nextSibling
{
  CFTreeRef sibling = CFTreeGetNextSibling(self.tree);
  return [self CFTreeToVBTree:sibling];
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
  
  return [self CFTreeToVBTree:childTree];
}

#pragma mark -
#pragma mark Private methods

- (VBTree *)CFTreeToVBTree:(CFTreeRef)tree
{
  if (tree == NULL)
    return nil;
  
  CFTreeContext ctx;
  CFTreeGetContext(tree, &ctx);
  
  return (__bridge VBTree *)ctx.info;
}

@end
