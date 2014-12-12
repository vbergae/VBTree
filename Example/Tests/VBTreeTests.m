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
    expect(tree.nextSibling).to.equal(sibling1);
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
  
  afterEach(^{
    tree = nil;
  });
});

SpecEnd
