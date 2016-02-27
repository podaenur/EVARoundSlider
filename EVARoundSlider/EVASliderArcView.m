//
//  EVASliderArcView.m
//  objC_roundSlider
//
//  Created by Evgeniy Akhmerov on 18/11/15.
//  Copyright © 2015 Eugeny Akhmerov. All rights reserved.
//

#import "EVASliderArcView.h"
#import "EVAMath.h"

static CGFloat const EVASliderArcViewCompensator = 1.f;

@interface EVASliderArcView ()

//  static
@property (nonatomic) UIColor *arcColor;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat radius;
@property (nonatomic) CGPoint centerPoint;

//  dynamic
@property (nonatomic, readwrite, getter = isClockwise) BOOL clockwise;
@property (nonatomic) BOOL canDraw;
@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;
@end

@implementation EVASliderArcView

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame width:(CGFloat)w arcColor:(UIColor *)c {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor clearColor];
    _width = w;
    _arcColor = (c != nil) ? c : [UIColor clearColor];
    _startPoint = CGPointInfinity();
    _endPoint = CGPointInfinity();
    _centerPoint = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);
  }
  return self;
}

#pragma mark - Custom Accessors

- (void)setClockwise:(BOOL)clockwise {
  _clockwise = clockwise;
  [self setNeedsDisplay];
}

#pragma mark - Actions
#pragma mark - Public

- (void)drawArcRadius:(CGFloat)r startPoint:(CGPoint)sPoint endPoint:(CGPoint)ePoint clockwise:(BOOL)cw {
  if (!CGPointIsInfinity(sPoint) && !CGPointIsInfinity(ePoint)) {
    _canDraw = YES;
    _radius = r;
    _clockwise = cw;
    _startPoint = sPoint;
    _endPoint = ePoint;
    
    [self setNeedsDisplay];
  } else {
    _canDraw = NO;
  }
}

#pragma mark - Private

- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];
  
  if (_canDraw) {
    [self drawArc];
  }
}

- (void)drawArc {
  CGFloat compensator = EVASliderArcViewCompensator * ((self.isClockwise) ? -1 : 1);
  
  CGFloat startAngle = AngleFromNorth(self.center, _startPoint, EVA_FLIPPED) - compensator;
  CGFloat endAngle = AngleFromNorth(self.center, _endPoint, EVA_FLIPPED) + compensator;
  
  UIBezierPath *arcPath = [UIBezierPath bezierPathWithArcCenter:_centerPoint
                                                         radius:_radius// + (2 * EVASliderArcViewCompensator) - _width / 2
                                                     startAngle:ToRad(startAngle)
                                                       endAngle:ToRad(endAngle)
                                                      clockwise:self.isClockwise];
  arcPath.lineWidth = _width;// - EVASliderArcViewCompensator;
  arcPath.lineCapStyle = kCGLineCapRound;
  [self.arcColor set];
  
  [arcPath performSelectorOnMainThread:@selector(stroke) withObject:nil waitUntilDone:YES];
}

#pragma mark - Segue
#pragma mark - Animations
#pragma mark - Protocol conformance
#pragma mark - Notifications handlers
#pragma mark - Gestures handlers
#pragma mark - KVO
#pragma mark - NSCopying
#pragma mark - NSObject

@end
