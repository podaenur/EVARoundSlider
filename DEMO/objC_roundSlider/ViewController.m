//
//  ViewController.m
//  objC_roundSlider
//
//  Created by Evgeniy Akhmerov on 18/11/15.
//  Copyright © 2015 Eugeny Akhmerov. All rights reserved.
//

//#define SETTING 1
//#define SETTING 2
#define SETTING 3

#import "ViewController.h"
#import "EVARoundSliderView.h"

static CGFloat EVAWidth = 35.f;

@interface ViewController ()

@property (weak, nonatomic) IBOutlet EVARoundSliderView *roundSlider;
@property (weak, nonatomic) IBOutlet UIView *leftIndicator;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (weak, nonatomic) IBOutlet UIView *rightIndicator;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@property (weak, nonatomic) IBOutlet UIView *middleIndicator;
@property (weak, nonatomic) IBOutlet UILabel *middleLabel;

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
  
  [_IndicatorPositionSlider setThumbImage:[UIImage new] forState:UIControlStateNormal];
  _IndicatorPositionSlider.thumbTintColor = [UIColor whiteColor];
  
  _roundSlider.dataSource = self;
  _roundSlider.delegate = self;
  _colors = @[ [UIColor redColor],
               [UIColor yellowColor],
               [UIColor greenColor],
               [UIColor blueColor] ];
  
#if SETTING == 1
  _leftLabel.hidden = NO;
  _middleLabel.hidden = NO;
  _rightLabel.hidden = NO;
#else
  _leftLabel.hidden = YES;
  _middleLabel.hidden = YES;
  _rightLabel.hidden = YES;
#endif
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
#if SETTING == 1
  return 2;
#elif SETTING == 2
  return 1;
#else
  return 2;
#endif
}

- (EVASliderType)typeOfSlider:(EVARoundSliderView *)slider {
#if SETTING == 1
  return EVASliderTypePlain;
#elif SETTING == 2
  return EVASliderTypeGradient;
#else
  return EVASliderTypeGradient;
#endif
}

- (UIColor *)shadowArcColorAtSlider:(EVARoundSliderView *)slider {
#if SETTING == 1
  return [[UIColor blackColor] colorWithAlphaComponent:0.4f];
#elif SETTING == 2
  return [UIColor whiteColor];
#else
  return [[UIColor whiteColor] colorWithAlphaComponent:0.6f];
#endif
}

- (EVAArcDirection)arcDrawingDirectionForSlider:(EVARoundSliderView *)slider {
#if SETTING == 1
  return EVAArcDirectionClockwise;
#else
  return EVAArcDirectionCalculated;
#endif
}

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

- (UIView *)centerViewForSlider:(EVARoundSliderView *)slider {
#if SETTING == 1
  UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 300.f, 300.f)];
  centerView.backgroundColor = [UIColor blackColor];
  return centerView;
#elif SETTING == 2
  UILabel *centerView = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 150.f, 100.f)];
  centerView.text = @"Any view may be here";
  centerView.textColor = [UIColor blackColor];
  centerView.textAlignment = NSTextAlignmentCenter;
  centerView.font = [UIFont fontWithName:@"HelveticaNeue" size:15.f];
  return centerView;
#else
  return nil;
#endif
}

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
#if SETTING == 1
  switch (index) {
    case 0:
      _leftLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)angle];
      break;
    case 1:
      _middleLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[slider angleBetweenHandlesClockwiseCalculating:YES]];
      _rightLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)angle];
      break;
      
    default:
      break;
  }
#elif SETTING == 2
  
#else
  
#endif
}

//  indicator
- (void)slider:(EVARoundSliderView *)slider indicatorPosition:(CGPoint)position {
//  NSLog(@"indicator at %@", NSStringFromCGPoint(position));
}

- (void)slider:(EVARoundSliderView *)slider indicatorColorAtPosition:(UIColor *)color {
//  _IndicatorPositionSlider.backgroundColor = color;
  _IndicatorPositionSlider.thumbTintColor = color;
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
