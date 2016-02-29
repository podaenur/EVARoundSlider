//
//  EVARoundSliderView.m
//  objC_roundSlider
//
//  Created by Evgeniy Akhmerov on 18/11/15.
//  Copyright © 2015 Eugeny Akhmerov. All rights reserved.
//

#import "EVARoundSliderView.h"
#import "EVAMath.h"
#import "EVAGradient.h"
#import "EVASliderArcView.h"

IB_DESIGNABLE

@interface EVARoundSliderView ()

//  static
@property (nonatomic, getter = isSetuped) BOOL setupComplite;
@property (nonatomic) EVAMath *math;
@property (nonatomic) CGFloat radius;
@property (nonatomic) CGPoint centerPoint;
@property (nonatomic) CGFloat sliderWidth;
@property (nonatomic) EVASliderType sliderType;
@property (nonatomic) NSUInteger numberOfHandles;
@property (nonatomic) NSMutableDictionary *handles;
@property (nonatomic) UIView *indicator;

//  if handles > 1
@property (nonatomic) EVASliderArcView *arc;
@property (nonatomic) UIColor *shadowArcColor;
@property (nonatomic) EVAArcDirection direction;
@property (nonatomic) EVATouchOffset offset;
@property (nonatomic, getter = isNeedToRevoke) BOOL revoke;

//  dynamic
@property (nonatomic, weak) UIView *nearesHandle;
@property (nonatomic, getter = isDragging) BOOL dragging;
@end

@implementation EVARoundSliderView

#pragma mark - Life cycle
#pragma mark - Custom Accessors
#pragma mark - Actions
#pragma mark - Public

- (void)moveHandleAtIndex:(NSUInteger)index toAngle:(NSUInteger)angle {
  NSAssert(index <= _handles.count, @"Index out of range");
  NSAssert(((angle >= 0) && (angle <= 360)), @"Angle beyon bounds");
  
  UIView *h = _handles[@(index)];
  [self moveView:h toAngle:(int)angle];
  
  [self drawArc];
}

- (void)moveHandleAtIndex:(NSUInteger)index toColor:(UIColor *)color {
  NSAssert(index <= _handles.count, @"Index out of range");
  NSAssert(color, @"Color cannot be nil value");
  
  CGFloat h;
  CGFloat s;
  CGFloat b;
  CGFloat a;
  
  [color getHue:&h saturation:&s brightness:&b alpha:&a];
  
  [self moveHandleAtIndex:index toAngle:(h * 360)];
}

- (void)moveIndicatorToAngle:(NSUInteger)angle {
  NSAssert(((angle >= 0) && (angle <= 360)), @"Angle beyon bounds");
  
  [self moveView:_indicator toAngle:angle];
  [self informDelegateAboutIndicator];
}

- (void)moveIndicatorToColor:(UIColor *)color {
  NSAssert(color, @"Color cannot be nil value");
  
  CGFloat h;
  CGFloat s;
  CGFloat b;
  CGFloat a;
  
  [color getHue:&h saturation:&s brightness:&b alpha:&a];
  
  [self moveView:_indicator toAngle:(h * 360)];
}

- (void)directArcByAngle:(NSUInteger)angle {
  NSAssert((_handles.count > 1), @"Method only for two handles");
  NSAssert(((angle >= 0) && (angle <= 360)), @"Angle beyon bounds");
  
  if (_direction != EVAArcDirectionCalculated) {
    return;
  }
  
  CGPoint p = [_math pointOnCircleWithCenter:_centerPoint radius:[self calculatedRadius] forAngle:(int)angle];
  BOOL flag = [_math whetherClockwiseDirectionByPoint:p
                                         betweenPoint:[(UIView *)_handles[@(0)] center]
                                             andPoint:[(UIView *)_handles[@(1)] center]
                                             atCenter:_centerPoint];
  [_arc setClockwise:flag];
  [self informDelegateAboutHandles];
}

- (void)directArcByColor:(UIColor *)color {
  NSAssert((_handles.count > 1), @"Method only for two handles");
  NSAssert(color, @"Color cannot be nil value");
  
  CGFloat a = [_math getAngleForColor:(color) ? color : [UIColor redColor]];
  [self directArcByAngle:(NSUInteger)a];
}

//  get data
- (CGFloat)distanceBetweenHandlesClockwiseCalculating:(BOOL)isClockwise {
  NSAssert((_handles.count > 1), @"Method only for two handles");
  
  CGFloat dA = [self angleBetweenHandlesClockwiseCalculating:isClockwise];
  return (2 * M_PI * _radius * _radius) * (dA / 360);
}

- (CGFloat)angleBetweenHandlesClockwiseCalculating:(BOOL)isClockwise {
  NSAssert((_handles.count > 1), @"Method only for two handles");
  
  CGFloat fAngle = [self handleAngleByIndex:0];
  CGFloat lAngle = [self handleAngleByIndex:1];
  
  return [_math bisectorForStartAngle:fAngle endAngle:lAngle clockwise:isClockwise];
}

- (UIColor *)getColorCurrentDirection {
  if (_handles.count < 2) {
    return nil;
  }
  
  CGFloat fAngle = [self handleAngleByIndex:0];
  CGFloat lAngle = [self handleAngleByIndex:1];
  
  CGFloat a = [_math bisectorForStartAngle:fAngle endAngle:lAngle clockwise:!_arc.isClockwise];
  return [_math getColorForAngle:a];
}

#pragma mark - Private
#pragma mark o- Custom

- (void)setup {
  self.setupComplite = YES;
  
  //  common
  _math = [[EVAMath alloc] init];
  _handles = [[NSMutableDictionary alloc] init];
  _radius = (MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / 2);
  _centerPoint = CGPointMake([self radiusVector].dx, [self radiusVector].dy);
  self.clipsToBounds = YES;
  
  //  datasource
  _sliderWidth = [self.dataSource widthForSlider:self];
  _numberOfHandles = [self.dataSource numberOfHandlesAtSlider:self];
  NSAssert((_numberOfHandles <= 2), @"Slider didn't support greater than two handles");
  
  //  type
  if ([self.dataSource respondsToSelector:@selector(typeOfSlider:)]) {
    _sliderType = [self.dataSource typeOfSlider:self];
  }
  
  //  indicator
  if ([self.dataSource respondsToSelector:@selector(indicatorViewForSlider:)]) {
    _indicator = [self.dataSource indicatorViewForSlider:self];
    _indicator.center = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
    [self addSubview:_indicator];
  }
  
  //  handles
  if (_numberOfHandles > 1) {
    _shadowArcColor = [self.dataSource respondsToSelector:@selector(shadowArcColorAtSlider:)] ? [self.dataSource shadowArcColorAtSlider:self] : [UIColor clearColor];
    _direction = [self.dataSource respondsToSelector:@selector(arcDrawingDirectionForSlider:)] ? [self.dataSource arcDrawingDirectionForSlider:self] : EVAArcDirectionClockwise;
  }
  
  for (unsigned i = 0; i < _numberOfHandles; i++) {
    UIView *handle = [self.dataSource handleViewForSlider:self atIndex:i];
    handle.center = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
    [_handles setObject:handle forKey:@(i)];
    [self addSubview:handle];
  }
  
  //  offset
  if ([self.dataSource respondsToSelector:@selector(touchRecognizeOffsetForSlider:)]) {
    _offset = [self.dataSource touchRecognizeOffsetForSlider:self];
  } else {
    _offset.inside = CGFLOAT_MAX;
    _offset.outside = CGFLOAT_MAX;
  }
  
  _revoke = [self.dataSource respondsToSelector:@selector(revokeTouchesBeyondBoundsOffsetForSlider:)] ? [self.dataSource revokeTouchesBeyondBoundsOffsetForSlider:self] : NO;
  
  //  arc
  if (_handles.count > 1) {
    CGRect rect = CGRectMake(0.f, 0.f, _radius * 2, _radius * 2);
    _arc = [[EVASliderArcView alloc] initWithFrame:rect width:_sliderWidth arcColor:_shadowArcColor];
    _arc.center = _centerPoint;
    [self addSubview:_arc];
    [self sendSubviewToBack:_arc];
  }
  
  //  background view
  UIView *bg = nil;
  if ([self.dataSource respondsToSelector:@selector(backgroundViewForSlider:)]) {
    bg = [self.dataSource backgroundViewForSlider:self];
  } else if (_sliderType == EVASliderTypeGradient) {
    bg = [[EVAGradient alloc] initWithFrame:self.bounds];
  }
  if (bg) {
    bg.center = CGPointMake([self radiusVector].dx, [self radiusVector].dy);
    [self addSubview:bg];
    [self sendSubviewToBack:bg];
  }
  
  //  center view
  if ([self.dataSource respondsToSelector:@selector(centerViewForSlider:)]) {
    CGFloat s = (_radius - _sliderWidth) * 2;
    CGRect frame = CGRectMake(0.f, 0.f, s, s);
    UIView *centerCanvas = [[UIView alloc] initWithFrame:frame];
    centerCanvas.center  =_centerPoint;
    centerCanvas.backgroundColor = self.superview.backgroundColor;
    centerCanvas.layer.cornerRadius = s / 2;
    centerCanvas.clipsToBounds = YES;
    [self addSubview:centerCanvas];
    
    UIView *cv = [self.dataSource centerViewForSlider:self];
    cv.center = CGPointMake(CGRectGetMidX(centerCanvas.bounds), CGRectGetMidY(centerCanvas.bounds));
    [centerCanvas addSubview:cv];
  }
  
  //  gestures
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
  [_arc addGestureRecognizer:tap];
}

- (CGVector)radiusVector {
  return CGVectorMake((CGRectGetWidth(self.bounds) / 2),
                      (CGRectGetHeight(self.bounds) / 2));
}

- (NSUInteger)indexOfNearesPointForTouch:(UITouch *)touch {
  CGPoint location = [touch locationInView:self];
  NSMutableDictionary *distanses = [[NSMutableDictionary alloc] initWithCapacity:_handles.count];
  
  for (unsigned i = 0; i < _handles.allValues.count; i++) {
    UIView *h = _handles[@(i)];
    CGFloat d = [_math distanceBetweenPoint:location andPoint:h.center];
    [distanses setObject:@(d) forKey:@(i)];
  }
  
  NSArray *sortedKeys = [distanses keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
    double arg1 = [obj1 doubleValue];
    double arg2 = [obj2 doubleValue];
    
    if (arg1 > arg2) {
      return NSOrderedDescending;
    } else if (arg1 < arg2) {
      return NSOrderedAscending;
    }
    return NSOrderedSame;
  }];
  
  return (sortedKeys.count > 0) ? [sortedKeys.firstObject integerValue] : NSNotFound;
}

- (CGFloat)calculatedRadius {
  return _radius - _sliderWidth / 2;
}

- (void)moveView:(UIView *)v toAngle:(int)a {
  CGFloat r = [self calculatedRadius];
  dispatch_async(dispatch_get_main_queue(), ^{
    v.center = [_math pointOnCircleWithCenter:_centerPoint radius:r forAngle:a];
  });
  
  if ([v isEqual:_indicator]) {
    [self informDelegateAboutIndicator];
  } else {
    [self informDelegateAboutHandles];
  }
}

- (void)drawArc {
  if (_arc) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [_arc drawArcRadius:[self calculatedRadius]
               startPoint:[(UIView *)_handles[@(0)] center]
                 endPoint:[(UIView *)_handles[@(1)] center]
                clockwise:(_direction == EVAArcDirectionConterclockwise) ? NO : YES];
    });
  }
}

- (void)endDraggingInform {
  _dragging = NO;
  
  if ([self.delegate respondsToSelector:@selector(sliderDidEndDragging:)]) {
    [self.delegate sliderDidEndDragging:self];
  }
}

- (void)informDelegateAboutHandles {
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
  dispatch_async(queue, ^{
    BOOL flag1 = [self.delegate respondsToSelector:@selector(slider:handlePosition:atIndex:)];
    BOOL flag2 = [self.delegate respondsToSelector:@selector(slider:colorHandlePosition:atIndex:)];
    BOOL flag3 = [self.delegate respondsToSelector:@selector(slider:angleHandlePosition:atIndex:)];
    
    for (unsigned i = 0; i < _handles.count; i++) {
      UIView *h = _handles[@(i)];
      CGFloat a = AngleFromNorth(_centerPoint, h.center, EVA_FLIPPED);
      UIColor *c = [_math getColorForAngle:a];
      
      if (flag1) {
        dispatch_async(dispatch_get_main_queue(), ^{
          [self.delegate slider:self handlePosition:h.center atIndex:i];
        });
      }
      
      if (flag2 && _sliderType == EVASliderTypeGradient) {
        dispatch_async(dispatch_get_main_queue(), ^{
          [self.delegate slider:self colorHandlePosition:c atIndex:i];
        });
      }
      
      if (flag3) {
        dispatch_async(dispatch_get_main_queue(), ^{
          [self.delegate slider:self angleHandlePosition:a atIndex:i];
        });
      }
    }
  });
}

- (void)informDelegateAboutIndicator {
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
  dispatch_async(queue, ^{
    if (_indicator) {
      BOOL flag1 = [self.delegate respondsToSelector:@selector(slider:indicatorPosition:)];
      BOOL flag2 = [self.delegate respondsToSelector:@selector(slider:indicatorColorAtPosition:)];
      BOOL flag3 = [self.delegate respondsToSelector:@selector(slider:indicatorAngleAtPosition:)];
      
      CGFloat a = AngleFromNorth(_centerPoint, _indicator.center, EVA_FLIPPED);
      UIColor *c = [_math getColorForAngle:a];
      
      if (flag1) {
        dispatch_async(dispatch_get_main_queue(), ^{
          [self.delegate slider:self indicatorPosition:_indicator.center];
        });
      }
      
      if (flag2 && _sliderType == EVASliderTypeGradient) {
        dispatch_async(dispatch_get_main_queue(), ^{
          [self.delegate slider:self indicatorColorAtPosition:c];
        });
      }
      
      if (flag3) {
        dispatch_async(dispatch_get_main_queue(), ^{
          [self.delegate slider:self indicatorAngleAtPosition:(NSUInteger)a];
        });
      }
    }
  });
}

- (CGFloat)handleAngleByIndex:(NSUInteger)index {
  return AngleFromNorth(_centerPoint, [(UIView *)_handles[@(index)] center], EVA_FLIPPED);
}

#pragma mark o- Overrided

- (void)drawRect:(CGRect)rect {
#if TARGET_INTERFACE_BUILDER
  UILabel *placeholder = [[UILabel alloc] initWithFrame:self.bounds];
  placeholder.textColor = [UIColor grayColor];
  placeholder.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4f];
  placeholder.textAlignment = NSTextAlignmentCenter;
  placeholder.text = NSStringFromClass(self.class);
  self.layer.cornerRadius = 5.f;
  self.layer.borderWidth = 1.f;
  self.layer.borderColor = [UIColor whiteColor].CGColor;
  self.clipsToBounds = YES;
  [self addSubview:placeholder];
#else
  [super drawRect:rect];
  
  if (!self.isSetuped) {
    [self setup];
  }
#endif
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesBegan:touches withEvent:event];
  
  _dragging = YES;
  
  UITouch *touch = [touches anyObject];
  
  NSUInteger nearestHandleIndex = [self indexOfNearesPointForTouch:touch];
  _nearesHandle = (nearestHandleIndex != NSNotFound) ? _handles[@(nearestHandleIndex)] : nil;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesMoved:touches withEvent:event];
  
  if (!self.isDragging) {
    return;
  }
  
  if ([self.delegate respondsToSelector:@selector(sliderDraggin:)]) {
    [self.delegate sliderDraggin:self];
  }
  
  UITouch *touch = [touches anyObject];
  CGPoint location = [touch locationInView:self];
  
  CGFloat d = [_math distanceBetweenPoint:_centerPoint andPoint:location];
  
  CGFloat inOff = _radius - _sliderWidth - _offset.inside;
  CGFloat outOff = _radius + _offset.outside;
  
  if (d < inOff || d > outOff) {
    if (self.isNeedToRevoke) {
      _dragging = NO;
      return;
    }
  }
  
  dispatch_async(dispatch_get_main_queue(), ^{
    int a = AngleFromNorth(_centerPoint, location, EVA_FLIPPED);
    [self moveView:_nearesHandle toAngle:a];
    
    [self drawArc];
  });
  
  [self informDelegateAboutHandles];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [super touchesEnded:touches withEvent:event];
  
  [self endDraggingInform];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [super touchesCancelled:touches withEvent:event];
  
  [self endDraggingInform];
}

#pragma mark - Segue
#pragma mark - Animations
#pragma mark - Protocol conformance
#pragma mark - Notifications handlers

#pragma mark - Gestures handlers

- (void)handleSingleTap:(UITapGestureRecognizer *)gesture {
  if (_handles.count < 2) {
    return;
  }
  
  if (_direction != EVAArcDirectionCalculated) {
    return;
  }
  
  CGPoint point = [gesture locationInView:_arc];
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    if (!self.isDragging) {
      UIView *h1 = _handles[@(0)];
      UIView *h2 = _handles[@(1)];
      
      BOOL c = [_math whetherClockwiseDirectionByPoint:point
                                          betweenPoint:h1.center
                                              andPoint:h2.center
                                              atCenter:_centerPoint];
      [_arc setClockwise:c];
      [self informDelegateAboutHandles];
    }
  });
}

#pragma mark - KVO
#pragma mark - NSCopying
#pragma mark - NSObject

@end
