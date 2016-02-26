//
//  objC_roundSliderTests.m
//  objC_roundSliderTests
//
//  Created by Eugeny on 25/01/16.
//  Copyright (c) 2016 Eugeny Akhmerov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "EVAMath.h"

@interface objC_roundSliderTests : XCTestCase

@property EVAMath *math;
@end

@implementation objC_roundSliderTests

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
  
  _math = [[EVAMath alloc] init];
}

//- (void)tearDown {
//    // Put teardown code here. This method is called after the invocation of each test method in the class.
//    [super tearDown];
//}

//- (void)testExample {
//    // This is an example of a functional test case.
//    XCTAssert(YES, @"Pass");
//}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

//  clockwise
- (void)testAngleBetween_10_330_StartEndClockwise {
  CGFloat start = 10.f;
  CGFloat end = 330.f;
  CGFloat target = 170.f;
  BOOL clockwise = YES;
  CGFloat middle = [_math angleBetweenStartAngle:start endAngle:end clockwise:clockwise];
  XCTAssertEqual(middle, target, @"test failed");
}

- (void)testAngleBetween_10_330_EndStartClockwise {
  CGFloat start = 330.f;
  CGFloat end = 10.f;
  CGFloat target = 350.f;
  BOOL clockwise = YES;
  CGFloat middle = [_math angleBetweenStartAngle:start endAngle:end clockwise:clockwise];
  XCTAssertEqual(middle, target, @"test failed");
}

//  conterclockwise
- (void)testAngleBetween_10_330_StartEndConterClockwise {
  CGFloat start = 10.f;
  CGFloat end = 330.f;
  CGFloat target = 350.f;
  BOOL clockwise = NO;
  CGFloat middle = [_math angleBetweenStartAngle:start endAngle:end clockwise:clockwise];
  XCTAssertEqual(middle, target, @"test failed");
}

- (void)testAngleBetween_10_330_EndStartConterClockwise {
  CGFloat start = 330.f;
  CGFloat end = 10.f;
  CGFloat target = 170.f;
  BOOL clockwise = NO;
  CGFloat middle = [_math angleBetweenStartAngle:start endAngle:end clockwise:clockwise];
  XCTAssertEqual(middle, target, @"test failed");
}

//  clockwise
- (void)testAngleBetween_30_70_StartEndClockwise {
  CGFloat start = 30.f;
  CGFloat end = 70.f;
  CGFloat target = 50.f;
  BOOL clockwise = YES;
  CGFloat middle = [_math angleBetweenStartAngle:start endAngle:end clockwise:clockwise];
  XCTAssertEqual(middle, target, @"test failed");
}

- (void)testAngleBetween_30_70_EndStartClockwise {
  CGFloat start = 70.f;
  CGFloat end = 30.f;
  CGFloat target = 230.f;
  BOOL clockwise = YES;
  CGFloat middle = [_math angleBetweenStartAngle:start endAngle:end clockwise:clockwise];
  XCTAssertEqual(middle, target, @"test failed");
}

//  conterclockwise
- (void)testAngleBetween_30_70_StartEndConterClockwise {
  CGFloat start = 30.f;
  CGFloat end = 70.f;
  CGFloat target = 230.f;
  BOOL clockwise = NO;
  CGFloat middle = [_math angleBetweenStartAngle:start endAngle:end clockwise:clockwise];
  XCTAssertEqual(middle, target, @"test failed");
}

- (void)testAngleBetween_30_70_EndStartConterClockwise {
  CGFloat start = 70.f;
  CGFloat end = 30.f;
  CGFloat target = 50.f;
  BOOL clockwise = NO;
  CGFloat middle = [_math angleBetweenStartAngle:start endAngle:end clockwise:clockwise];
  XCTAssertEqual(middle, target, @"test failed");
}

- (void)testDistanceBetweenPoint {
  CGPoint f = CGPointMake(3.f, 9.f);
  CGPoint s = CGPointMake(12.f, 31.f);
  CGFloat t = 23.7697277;
  CGFloat distance = [_math distanceBetweenPoint:f andPoint:s];
  XCTAssertEqual(distance, t, @"Wrong distance");
}

- (void)testPointOnCircleWithCenter {
  CGPoint point = [_math pointOnCircleWithCenter:CGPointMake(10.f, 10.f) radius:5.f forAngle:180];
  XCTAssertTrue(CGPointEqualToPoint(point, CGPointMake(5.f, 10.f)), @"Wrong point for angle");
}

- (void)testGetAngleForColor {
  CGFloat angle = [_math getAngleForColor:[UIColor greenColor]];
  XCTAssertEqual(angle, 120.f, @"Angle is not equal to color");
}

- (void)testGetColorFromAngle {
  UIColor *color = [_math getColorForAngle:240.f];
  XCTAssertEqualObjects(color, [UIColor blueColor], @"Colors is not equals");
}

- (void)testSwipeCGFloat {
  CGFloat a = 15.3199997;
  CGFloat b = 37.4980011;
  
  CGFloat c = 37.4980011;
  CGFloat d = 15.3199997;
  
  [_math swapCGFloat:&a andCGFloat:&b];
  
  XCTAssertEqual(a, c, @"After swap arg1 is incorrect");
  XCTAssertEqual(b, d, @"After swap arg2 is incorrect");
}

@end
