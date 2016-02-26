//
//  EVAMath.m
//  objC_roundSlider
//
//  Created by Evgeniy Akhmerov on 18/11/15.
//  Copyright © 2015 Eugeny Akhmerov. All rights reserved.
//

#import "EVAMath.h"

@implementation EVAMath

#pragma mark - Life cycle
#pragma mark - Custom Accessors
#pragma mark - Actions

#pragma mark - Public

- (CGFloat)distanceBetweenPoint:(CGPoint)p1 andPoint:(CGPoint)p2 {
  CGFloat deltaX = p2.x - p1.x;
  CGFloat deltaY = p2.y - p1.y;
  
  return sqrt(pow(deltaX, 2) + pow(deltaY, 2));
}

- (CGFloat)angleBetweenStartAngle:(CGFloat)sAngle endAngle:(CGFloat)eAngle clockwise:(BOOL)isClockwise {
  if (!isClockwise) {
    CGFloat t = eAngle;
    eAngle = sAngle;
    sAngle = t;
  }
  
  if ((eAngle < sAngle)) {
    CGFloat delta = (eAngle - ((360 - (sAngle - eAngle)) / 2));
    if (delta < 0) {
      delta += 360;
    }
    return delta;
  }
  return (eAngle - ((eAngle - sAngle) / 2));
}

- (CGPoint)pointOnCircleWithCenter:(CGPoint)c radius:(CGFloat)r forAngle:(int)angleInt {
  CGPoint result;
  
  result.y = (c.y + r * sin(ToRad(angleInt)));
  result.x = (c.x + r * cos(ToRad(-angleInt)));
  
  return result;
}

- (CGFloat)getAngleForColor:(UIColor *)color {
  CGFloat hue;
  [color getHue:&hue saturation:nil brightness:nil alpha:nil];
  return ToDeg(M_PI * 2) * hue;
}

- (UIColor *)getColorForAngle:(CGFloat)angle {
  angle = (angle == 0) ? 360 : angle;
  CGFloat hue = ToRad(angle) / (M_PI * 2);
  return [UIColor colorWithHue:hue saturation:1.f brightness:1.f alpha:1.f];
}

- (void)swapCGFloat:(inout CGFloat *)arg1 andCGFloat:(inout CGFloat *)arg2 {
  @synchronized([self class]) {
    CGFloat bufer = *arg1;
    *arg1 = *arg2;
    *arg2 = bufer;
  }
}

- (BOOL)whetherClockwiseDirectionByPoint:(CGPoint)p betweenPoint:(CGPoint)s andPoint:(CGPoint)e atCenter:(CGPoint)c {
    CGFloat startAngle   = AngleFromNorth(c, s, NO);
    CGFloat currentAngle = AngleFromNorth(c, p, NO);
    CGFloat endAngle     = AngleFromNorth(c, e, NO);
    
    return (endAngle > startAngle)  ? (currentAngle > startAngle && currentAngle < endAngle)
    : (currentAngle > startAngle || currentAngle < endAngle);
}

#pragma mark - Private
#pragma mark - Segue
#pragma mark - Animations
#pragma mark - Protocol conformance
#pragma mark - Notifications handlers
#pragma mark - Gestures handlers
#pragma mark - KVO
#pragma mark - NSCopying
#pragma mark - NSObject

@end
