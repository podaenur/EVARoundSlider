//
//  EVAGradient.m
//  objC_roundSlider
//
//  Created by Evgeniy Akhmerov on 18/11/15.
//  Copyright © 2015 Eugeny Akhmerov. All rights reserved.
//

#import "EVAGradient.h"
#import "EVAMath.h"

@interface EVAGradient ()

@property (nonatomic) CGFloat radius;
@end

@implementation EVAGradient

#pragma mark - Life cycle

- (instancetype)init {
  self = [super init];
  if (self) {
    [self setup];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if (self) {
    [self setup];
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self setup];
  }
  return self;
}

#pragma mark - Custom Accessors
#pragma mark - Actions
#pragma mark - Public

#pragma mark - Private

- (void)setup {
  self.opaque = NO;
  _radius = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / 2;
}

- (void)drawSliceStep:(NSUInteger)i {
  CGFloat a = ToRad(i + 1);
  CGFloat b = ToRad(i + 2);
  UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.center
                                                      radius:_radius
                                                  startAngle:a
                                                    endAngle:b
                                                   clockwise:YES];
  [path addLineToPoint:self.center];
  
  [[UIColor colorWithHue:((double)i / 360) saturation:1.f brightness:1.f alpha:1.f] set];
  [path closePath];
  [path fill];
  [path stroke];
}

#pragma mark o- Overrided

- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];
  
  UIGraphicsBeginImageContext(self.bounds.size);
  
  for (NSUInteger i = 0; i < 360; ++i) {
    [self drawSliceStep:i];
  }
  
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  UIImageView *bgImageView = [[UIImageView alloc] initWithImage:image];
  [self addSubview:bgImageView];
  [self sendSubviewToBack:bgImageView];
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
