//
//  ViewController.m
//  objC_roundSlider
//
//  Created by Evgeniy Akhmerov on 18/11/15.
//  Copyright © 2015 Eugeny Akhmerov. All rights reserved.
//

#import "ViewController.h"/Users/Evgeniy
#import "EVARoundSliderView.h"

static CGFloat EVAWidth = 30.f;

@interface ViewController ()

@property (weak, nonatomic) IBOutlet EVARoundSliderView *roundSlider;
@property (weak, nonatomic) IBOutlet UIView *leftIndicator;
@property (weak, nonatomic) IBOutlet UIView *rightIndicator;
@property (weak, nonatomic) IBOutlet UIView *middleIndicator;
@property (weak, nonatomic) IBOutlet UISlider *IndicatorPositionSlider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *guidedColor;

@property (nonatomic) UIView *handle1;
@property (nonatomic) UIView *handle2;
@property (nonatomic) NSArray *colors;
@end

@interface ViewController () <EVARoundSliderDataSource, EVARoundSliderDelegate>

@end

@implementation ViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _roundSlider.dataSource = self;
  _roundSlider.delegate = self;
  _colors = @[ [UIColor redColor],
               [UIColor yellowColor],
               [UIColor greenColor],
               [UIColor blueColor] ];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [_roundSlider moveHandleAtIndex:0 toAngle:60];
  [_roundSlider moveHandleAtIndex:1 toColor:[UIColor blueColor]];
}

#pragma mark - Custom Accessors

#pragma mark - Actions

- (IBAction)sliderDidChangeValueAction:(id)sender {
  CGFloat angle = [(UISlider *)sender value] * 360;
  [_roundSlider moveIndicatorToAngle:(NSUInteger)angle];
}

- (IBAction)guidedColorChangedAction:(UISegmentedControl *)sender {
  [_roundSlider directArcByColor:_colors[sender.selectedSegmentIndex]];
}

#pragma mark - Public
#pragma mark - Private
#pragma mark - Segue
#pragma mark - Animations

#pragma mark - Protocol conformance
#pragma mark o- EVARoundSliderDataSource

//  settings
- (CGFloat)widthForSlider:(EVARoundSliderView *)slider {
  return EVAWidth;
}

- (NSUInteger)numberOfHandlesAtSlider:(EVARoundSliderView *)slider {
//  return 1;
  
  return 2;
}

- (EVASliderType)typeOfSlider:(EVARoundSliderView *)slider {
  return EVASliderTypeGradient;
}

- (UIColor *)shadowArcColorAtSlider:(EVARoundSliderView *)slider {
  return [[UIColor blackColor] colorWithAlphaComponent:0.7f];
}

//- (EVAArcDirection)arcDrawingDirectionForSlider:(EVARoundSliderView *)slider;

- (EVATouchOffset)touchRecognizeOffsetForSlider:(EVARoundSliderView *)slider {
  EVATouchOffset offset = {
    .inside = 30.f,
    .outside = 50.f
  };
  return offset;
}

- (BOOL)revokeTouchesBeyondBoundsOffsetForSlider:(EVARoundSliderView *)slider {
  return YES;
}

//  views
//- (UIView *)backgroundViewForSlider:(UIView *)slider {
//}

//- (UIView *)centerViewForSlider:(EVARoundSliderView *)slider {
//  UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 100.f, 200.f)];
//  centerView.backgroundColor = [UIColor orangeColor];
//  return centerView;
//}

- (UIView *)handleViewForSlider:(EVARoundSliderView *)slider atIndex:(NSUInteger)index {
  if (index == 0 && _handle1) {
    return _handle1;
  } else if (index == 1 && _handle2) {
    return _handle2;
  }
  
  CGRect handleFrame = CGRectMake(0.f, 0.f, EVAWidth, EVAWidth);
  UIView *handle = [[UIView alloc] initWithFrame:handleFrame];
  handle.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
  handle.layer.cornerRadius = MIN(CGRectGetWidth(handle.bounds), CGRectGetHeight(handle.bounds)) / 2;
  handle.clipsToBounds = YES;
  
  UIView *subHandle = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, EVAWidth * 0.8f, EVAWidth * 0.8f)];
  subHandle.center = handle.center;
  subHandle.backgroundColor = [UIColor whiteColor];
  subHandle.layer.cornerRadius = MIN(CGRectGetWidth(subHandle.bounds), CGRectGetHeight(subHandle.bounds)) / 2;
  subHandle.clipsToBounds = YES;
  [handle addSubview:subHandle];
  
  UILabel *handleName = [[UILabel alloc] initWithFrame:handleFrame];
  handleName.textAlignment = NSTextAlignmentCenter;
  handleName.text = [NSString stringWithFormat:@"%lu", (unsigned long)index + 1];
  [handle addSubview:handleName];
  
  if (index == 0) {
    _handle1 = handle;
    return _handle1;
  } else if (index == 1) {
    _handle2 = handle;
    return _handle2;
  }
  
  return handle;
}

- (UIView *)indicatorViewForSlider:(EVARoundSliderView *)slider {
  CGFloat radius = (EVAWidth / 2) - 5.f;
  CGRect indicatorFrame = CGRectMake(0.f, 0.f, radius * 2, radius * 2);
  UIView *indicator = [[UIView alloc] initWithFrame:indicatorFrame];
  indicator.backgroundColor = [UIColor cyanColor];
  indicator.layer.cornerRadius = MIN(CGRectGetWidth(indicator.bounds), CGRectGetHeight(indicator.bounds)) / 2;
  indicator.clipsToBounds = YES;
  
  return indicator;
}

#pragma mark o- EVARoundSliderDelegate

//  handles
- (void)slider:(EVARoundSliderView *)slider handlePosition:(CGPoint)position atIndex:(NSUInteger)index {
//  NSLog(@"handle%d at %@", index + 1, NSStringFromCGPoint(position));
}

- (void)slider:(EVARoundSliderView *)slider colorHandlePosition:(UIColor *)color atIndex:(NSUInteger)index {
  switch (index) {
    case 0: {
      _leftIndicator.backgroundColor = color;
    }
      break;
    case 1: {
      _rightIndicator.backgroundColor = color;
      _middleIndicator.backgroundColor = [slider getColorCurrentDirection];
    }
      break;
      
    default:
      break;
  }
}

- (void)slider:(EVARoundSliderView *)slider angleHandlePosition:(NSUInteger)angle atIndex:(NSUInteger)index {
//  NSLog(@"handle%d angle %d", index + 1, angle);
}

//  indicator
- (void)slider:(EVARoundSliderView *)slider indicatorPosition:(CGPoint)position {
//  NSLog(@"indicator at %@", NSStringFromCGPoint(position));
}

- (void)slider:(EVARoundSliderView *)slider indicatorColorAtPosition:(UIColor *)color {
  _IndicatorPositionSlider.backgroundColor = color;
}

- (void)slider:(EVARoundSliderView *)slider indicatorAngleAtPosition:(NSUInteger)angle {
//  NSLog(@"indicator angle: %d", angle);
}

//  moving control
- (void)sliderDraggin:(EVARoundSliderView *)slider {  
//  NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)sliderDidEndDragging:(EVARoundSliderView *)slider {
//  NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark - Notifications handlers
#pragma mark - Gestures handlers
#pragma mark - KVO
#pragma mark - NSCopying
#pragma mark - NSObject

@end
