//
//  VBTreeTests.m
//  VBTree
//
//  Created by Víctor Berga on 11/12/14.
//  Copyright (c) 2014 Victor Berga. All rights reserved.
//

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>

#import <VBTree/VBTree.h>

SpecBegin(VBTree)

describe(@"VBTree", ^{
  __block VBTree *tree;
  
  beforeEach(^{
    tree = [[VBTree alloc] initWithContext:@"testable"];
  });
  
  it(@"can be created", ^{
    expect(tree).notTo.beNil();
  });
  
  it(@"has a context", ^{
    expect(tree.context).to.equal(@"testable");
  });
  
  it(@"can have a root", ^{
    VBTree *root = [[VBTree alloc] initWithContext:@"root"];
    VBTree *child = [[VBTree alloc] initWithContext:@"child"];
    
    [child appendChild:tree];
    [root appendChild:child];
    
    expect(tree.root).to.equal(root);
  });
  
  it(@"can have a parent", ^{
    VBTree *parent = [[VBTree alloc] initWithContext:@"parent"];
    [parent appendChild:tree];
    
    expect(tree.parent).notTo.beNil();
    expect(tree.parent).to.equal(parent);
  });
  
  it(@"can append children", ^{
    VBTree *child1 = [[VBTree alloc] initWithContext:@"child1"];
    VBTree *child2 = [[VBTree alloc] initWithContext:@"child2"];
    
    [tree appendChild:child1];
    [tree appendChild:child2];
    
    expect(tree.childCount).to.equal(2);
    expect(tree.children).to.contain(child1);
    expect(tree.children).to.contain(child2);
  });
  
  it(@"can return first child", ^{
    VBTree *child1 = [[VBTree alloc] initWithContext:@"child1"];
    VBTree *child2 = [[VBTree alloc] initWithContext:@"child2"];
    
    [tree appendChild:child1];
    [tree appendChild:child2];
    
    expect(tree.firstChild).to.equal(child1);
  });
  
  it(@"can insert siblings", ^{
    VBTree *parent   = [[VBTree alloc] initWithContext:@"parent"];
    VBTree *sibling1 = [[VBTree alloc] initWithContext:@"sib1"];
    VBTree *sibling2 = [[VBTree alloc] initWithContext:@"sib2"];
    
    [parent appendChild:tree];
    [tree insertSibling:sibling1];
    [tree insertSibling:sibling2];
    
    expect(parent.childCount).to.equal(3);
    expect(tree.nextSibling).to.equal(sibling2);
    expect(sibling2.nextSibling).to.equal(sibling1);
  });
  
  it(@"can prepend a child", ^{
    VBTree *prep1 = [[VBTree alloc] initWithContext:@"prepended1"];
    [tree prependChild:prep1];
    expect(tree.firstChild).to.equal(prep1);
    
    VBTree *prep2 = [[VBTree alloc] initWithContext:@"prepended2"];
    [tree prependChild:prep2];
    expect(tree.firstChild).to.equal(prep2);
  });
  
  it(@"can remove all children", ^{
    VBTree *child1 = [[VBTree alloc] initWithContext:@"child1"];
    VBTree *child2 = [[VBTree alloc] initWithContext:@"child2"];
    
    [tree appendChild:child1];
    [tree appendChild:child2];
    
    expect(tree.childCount).to.equal(2);
    [tree removeAllChildren];
    expect(tree.childCount).to.equal(0);
  });
  
  it(@"can be removed from his parent tree", ^{
    VBTree *parent = [[VBTree alloc] initWithContext:@"parent"];
    [parent appendChild:tree];
    
    expect(tree.parent).to.equal(parent);
    [tree remove];
    expect(parent.childCount).to.equal(0);
    expect(tree.parent).to.beNil();
  });
  
  it(@"can find children by his index", ^{
    VBTree *child1 = [[VBTree alloc] initWithContext:@"child1"];
    VBTree *child2 = [[VBTree alloc] initWithContext:@"child2"];
    VBTree *child3 = [[VBTree alloc] initWithContext:@"child3"];
    
    [tree appendChild:child1];
    [tree appendChild:child2];
    [tree appendChild:child3];
    
    expect([tree childAtIndex:0]).to.equal(child1);
    expect([tree childAtIndex:1]).to.equal(child2);
    expect([tree childAtIndex:2]).to.equal(child3);
  });
  
  it(@"can apply block to children", ^{
    VBTree *child1 = [[VBTree alloc] initWithContext:@"child1"];
    VBTree *child2 = [[VBTree alloc] initWithContext:@"child2"];
    
    [tree appendChild:child1];
    [tree appendChild:child2];
    
    [tree applyBlockToChildren:^(VBTree *child, id context) {
      expect(child).toNot.beNil();
      expect(context).toNot.beNil();
      expect(context).to.beKindOf([NSString class]);
      expect(context).to.equal(@"Block");
      
      NSString *nodeContext = [(NSString *)child.context
                               stringByAppendingString:context];
      child.context = nodeContext;
    } context:@"Block"];
    
    expect(child1.context).to.equal(@"child1Block");
    expect(child2.context).to.equal(@"child2Block");
  });
  
  it(@"can create an array of children with Breadth-first search", ^{
    VBTree *a     = [[VBTree alloc] initWithContext:@"a"];
    VBTree *a1    = [[VBTree alloc] initWithContext:@"a1"];
    VBTree *a11   = [[VBTree alloc] initWithContext:@"a11"];
    VBTree *a111  = [[VBTree alloc] initWithContext:@"a111"];
    VBTree *a2    = [[VBTree alloc] initWithContext:@"a2"];
    VBTree *b     = [[VBTree alloc] initWithContext:@"b"];
    
    [tree appendChild:a];
    [a appendChild:a1];
    [a1 appendChild:a11];
    [a11 appendChild:a111];
    [a appendChild:a2];
    [tree appendChild:b];
    
    NSArray *expected = @[tree, a, b, a1, a2, a11, a111];
    NSArray *result = [tree arrayWithAlgorithm:VBTreeTraverseAlgorithmBreadthFirst];
    
    expect(result).to.equal(expected);
  });
  
  afterEach(^{
    tree = nil;
  });
});

SpecEnd

