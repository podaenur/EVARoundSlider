//
//  EVASliderArcView.h
//  objC_roundSlider
//
//  Created by Evgeniy Akhmerov on 18/11/15.
//  Copyright © 2015 Eugeny Akhmerov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVASliderArcView : UIView

@property (nonatomic, readonly, getter = isClockwise) BOOL clockwise;

- (instancetype)initWithFrame:(CGRect)frame width:(CGFloat)w arcColor:(UIColor *)c;
- (void)setClockwise:(BOOL)clockwise;
- (void)drawArcRadius:(CGFloat)r startPoint:(CGPoint)sPoint endPoint:(CGPoint)ePoint clockwise:(BOOL)cw;
@end
