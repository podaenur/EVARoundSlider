//
//  EVARoundSliderView.h
//  objC_roundSlider
//
//  Created by Evgeniy Akhmerov on 18/11/15.
//  Copyright © 2015 Eugeny Akhmerov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EVARoundSliderDataSource, EVARoundSliderDelegate;

struct EVATouchOffset {
  CGFloat inside;
  CGFloat outside;
}; typedef struct EVATouchOffset EVATouchOffset;

typedef NS_ENUM(NSUInteger, EVASliderType) {
  EVASliderTypePlain = 0,
  EVASliderTypeGradient
};

typedef NS_ENUM(NSUInteger, EVAArcDirection) {
  EVAArcDirectionClockwise = 0,
  EVAArcDirectionConterclockwise,
  EVAArcDirectionCalculated
};

@interface EVARoundSliderView : UIControl

@property (nonatomic, weak) id<EVARoundSliderDataSource> dataSource;
@property (nonatomic, weak) id<EVARoundSliderDelegate> delegate;

//  set data
- (void)moveHandleAtIndex:(NSUInteger)index toAngle:(NSUInteger)angle;
- (void)moveHandleAtIndex:(NSUInteger)index toColor:(UIColor *)color;
- (void)moveIndicatorToAngle:(NSUInteger)angle;
- (void)moveIndicatorToColor:(UIColor *)color;
- (void)directArcByAngle:(NSUInteger)angle;
- (void)directArcByColor:(UIColor *)color;
//  get data
- (CGFloat)distanceBetweenHandlesClockwiseCalculating:(BOOL)isClockwise;
- (CGFloat)angleBetweenHandlesClockwiseCalculating:(BOOL)isClockwise;
- (UIColor *)getColorCurrentDirection;
@end


@protocol EVARoundSliderDataSource <NSObject>

@required
//  settings
- (CGFloat)widthForSlider:(EVARoundSliderView *)slider;
- (NSUInteger)numberOfHandlesAtSlider:(EVARoundSliderView *)slider;
//  views
- (UIView *)handleViewForSlider:(EVARoundSliderView *)slider atIndex:(NSUInteger)index;

@optional
- (EVASliderType)typeOfSlider:(EVARoundSliderView *)slider; //  EVASliderTypePlain by default
//- (BOOL)//  indicator ?
//  invokes if handles > 1
- (UIColor *)shadowArcColorAtSlider:(EVARoundSliderView *)slider; //  clear color by default;
//  invokes if handles > 1
- (EVAArcDirection)arcDrawingDirectionForSlider:(EVARoundSliderView *)slider; //  EVAArcDirectionClockwise is default
- (EVATouchOffset)touchRecognizeOffsetForSlider:(EVARoundSliderView *)slider; //  CGFLOAT_MAX by default for both
- (BOOL)revokeTouchesBeyondBoundsOffsetForSlider:(EVARoundSliderView *)slider;  //  NO by default
//  views
- (UIView *)backgroundViewForSlider:(UIView *)slider;
- (UIView *)centerViewForSlider:(EVARoundSliderView *)slider;
- (UIView *)indicatorViewForSlider:(EVARoundSliderView *)slider;
@end

@protocol EVARoundSliderDelegate <NSObject>

@optional
//  handles
- (void)slider:(EVARoundSliderView *)slider handlePosition:(CGPoint)position atIndex:(NSUInteger)index;
- (void)slider:(EVARoundSliderView *)slider colorHandlePosition:(UIColor *)color atIndex:(NSUInteger)index;
- (void)slider:(EVARoundSliderView *)slider angleHandlePosition:(NSUInteger)angle atIndex:(NSUInteger)index;
//  indicator
- (void)slider:(EVARoundSliderView *)slider indicatorPosition:(CGPoint)position;
- (void)slider:(EVARoundSliderView *)slider indicatorColorAtPosition:(UIColor *)color;
- (void)slider:(EVARoundSliderView *)slider indicatorAngleAtPosition:(NSUInteger)angle;
//  moving control
- (void)sliderDraggin:(EVARoundSliderView *)slider;
- (void)sliderDidEndDragging:(EVARoundSliderView *)slider;
@end