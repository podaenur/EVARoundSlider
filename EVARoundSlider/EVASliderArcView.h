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

/**
 *  Метод инициализации
 *
 *  @param frame рамка view
 *  @param w     ширина арки
 *  @param c     цвет арки
 *
 *  @return объект класса
 */
- (instancetype)initWithFrame:(CGRect)frame width:(CGFloat)w arcColor:(UIColor *)c;
/**
 *  Метод для смены направления арки слайдера
 *
 *  @param clockwise направление прорисовки арки слайдера
 */
- (void)setClockwise:(BOOL)clockwise;
/**
 *  Метод определения начальной, конечной точек арки слайдера и направления прорисовки.
 *
 *  @param r      радиус арки слайдера
 *  @param sPoint начальная координата на окружности
 *  @param ePoint конечная координата на окружности
 *  @param cw     направление прорисовки
 */
- (void)drawArcRadius:(CGFloat)r startPoint:(CGPoint)sPoint endPoint:(CGPoint)ePoint clockwise:(BOOL)cw;
@end
