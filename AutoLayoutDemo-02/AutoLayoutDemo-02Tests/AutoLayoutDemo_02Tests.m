//
//  AutoLayoutDemo_02Tests.m
//  AutoLayoutDemo-02Tests
//
//  Created by cenkh on 15/4/4.
//  Copyright (c) 2015年 cenkh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface AutoLayoutDemo_02Tests : XCTestCase

@end

@implementation AutoLayoutDemo_02Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
