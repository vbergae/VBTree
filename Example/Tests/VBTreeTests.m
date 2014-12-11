//
//  VBTreeTests.m
//  VBTree
//
//  Created by Víctor Berga on 11/12/14.
//  Copyright (c) 2014 Victor Berga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <VBTree/VBTree.h>

@interface VBTreeTests : XCTestCase

@property VBTree *tree;

@end

@implementation VBTreeTests

- (void)setUp
{
  [super setUp];
  
  self.tree = [[VBTree alloc] initWithContext:@"root"];
}

- (void)tearDown
{
  self.tree = nil;
  
  [super tearDown];
}

#pragma mark -
#pragma mark Properties

- (void)test_context
{
  id result = self.tree.context;
  XCTAssertEqualObjects(result, @"root");
}

- (void)test_root
{
  VBTree *child = [[VBTree alloc] initWithContext:@"child"];
  [self.tree appendChild:child];
  
  VBTree *root = child.root;
  XCTAssertTrue(self.tree == root);
}

- (void)test_childCount
{
  [self addChildren:3];
  
  XCTAssertTrue(self.tree.childCount == 3);
}

- (void)test_children
{
  [self addChildren:5];
  
  NSArray *result = self.tree.children;
  XCTAssertNotNil(result);
  XCTAssertTrue(result.count == 5);
}

- (void)test_parent
{
  VBTree *parent = [[VBTree alloc] initWithContext:@"parent"];
  [parent appendChild:self.tree];
  
  id result = self.tree.parent;
  XCTAssertTrue(result == parent);
}

- (void)test_firstChild
{
  NSArray *children = [self addChildren:2];
  VBTree *firstChild = self.tree.firstChild;
  
  XCTAssertTrue(children[0] == firstChild);
}

#pragma mark -
#pragma mark Modifying a Tree

- (void)test_appendChild
{
  VBTree *child = [[VBTree alloc] initWithContext:@"child"];
  [self.tree appendChild:child];
  
  XCTAssertTrue(self.tree.childCount == 1);
}

- (void)test_insertSibling
{
  VBTree *sibling = [[VBTree alloc] initWithContext:@"sibling"];
  [self.tree insertSibling:sibling];
  
  id result = self.tree.nextSibling;
  XCTAssertTrue(sibling == result);
}

- (void)test_removeAllChildren
{
  [self addChildren:5];
  XCTAssertTrue(self.tree.childCount == 5);
  
  [self.tree removeAllChildren];
  XCTAssertTrue(self.tree.childCount == 0);
}

- (void)test_prependChild
{
  [self addChildren:2];
  
  VBTree *prepended = [[VBTree alloc] initWithContext:@"prepended"];
  [self.tree prependChild:prepended];
  
  XCTAssertTrue(self.tree.children[0] == prepended);
}

- (void)test_remove
{
  VBTree *parent = [[VBTree alloc] initWithContext:@"parent"];
  [parent appendChild:self.tree];
  
  XCTAssertNotNil(self.tree.parent);
  
  [self.tree remove];
  XCTAssertTrue(parent.childCount == 0);
  XCTAssertNil(self.tree.parent);
}

#pragma mark -
#pragma mark Examining a Tree

- (void)test_childAtIndex
{
  NSArray *children = [self addChildren:3];
  
  XCTAssertTrue([self.tree childAtIndex:0] == children[0]);
  XCTAssertTrue([self.tree childAtIndex:1] == children[1]);
  XCTAssertTrue([self.tree childAtIndex:2] == children[2]);
}

#pragma mark -
#pragma mark Helpers

- (NSArray *)addChildren:(NSUInteger)childCount
{
  NSMutableArray *contexts = [[NSMutableArray alloc] initWithCapacity:childCount];
  
  for (NSUInteger i = 0; i < childCount; ++i) {
    id object = @(i);
    
    VBTree *child = [[VBTree alloc] initWithContext:object];
    [self.tree appendChild:child];
    
    [contexts addObject:child];
  }
  
  return contexts;
}

@end
