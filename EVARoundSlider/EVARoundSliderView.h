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

@property (nonatomic, readonly) CGFloat radius;
@property (nonatomic, readonly) CGFloat sliderWidth;
@property (nonatomic, readonly) EVASliderType sliderType;
@property (nonatomic, readonly) NSUInteger numberOfHandles;

#pragma mark Set data
/**
 *  Метод для перемещения ручки слайдера в заданый угол
 *
 *  @param index индекс перемещаемой ручки
 *  @param angle угол в degree
 */
- (void)moveHandleAtIndex:(NSUInteger)index toAngle:(NSUInteger)angle;
/**
 *  Метод для перемещения ручки слайдера в заданый цвет. Метод доступен только в режиме EVASliderTypeGradient
 *
 *  @param index индекс ручки
 *  @param color цвет, куда должна быть перемещена ручка
 */
- (void)moveHandleAtIndex:(NSUInteger)index toColor:(UIColor *)color;
/**
 *  Метод перемещения индикатора в заданый угол. Метод работает, если реализован метод indicatorViewForSlider:
 *
 *  @param angle угол в degree
 */
- (void)moveIndicatorToAngle:(NSUInteger)angle;
/**
 *  Метод перемещения индикатора в заданый цвет. Метод работает, если реализован метод indicatorViewForSlider:
 *
 *  @param color цвет, куда должен быть перемещен индикатор
 */
- (void)moveIndicatorToColor:(UIColor *)color;
/**
 *  Метод направления прорисовкой арки слайдера. Через заданый угол между ручками слайдера будет проходить активная арка. Теневая будет в противоположной части. Метод не работает для слайдера с одной ручкой.
 *
 *  @param angle угол в degree
 */
- (void)directArcByAngle:(NSUInteger)angle;
/**
 *  Метод направления прорисовкой арки слайдера. Через заданый цвет между ручками слайдера будет проходить активная арка. Теневая будет в противоположной части. Метод не работает для слайдера с одной ручкой. Метод доступен только в режиме EVASliderTypeGradient
 *
 *  @param color  цвет, через который проходит активная часть слайдера
 */
- (void)directArcByColor:(UIColor *)color;

#pragma mark Get data
/**
 *  Метод возвращает расстояние между первой и второй ручкой. Метод не работает для слайдера с одной ручкой.
 *
 *  @param isClockwise направление расчета расстояния
 *
 *  @return расстояние между ручками
 */
- (CGFloat)distanceBetweenHandlesClockwiseCalculating:(BOOL)isClockwise;
/**
 *  Метод возвращает угол между первой и второй ручкой. Метод не работает для слайдера с одной ручкой.
 *
 *  @param isClockwise направление расчета расстояния
 *
 *  @return угол в degree
 */
- (CGFloat)angleBetweenHandlesClockwiseCalculating:(BOOL)isClockwise;
/**
 *  Метод возвращает цвет, через который проходит активная часть слайдера. Цвет будет определен по середине между первой и второй ручкой. Метод не работает для слайдера с одной ручкой.
 *
 *  @return цвет между ручками
 */
- (UIColor *)getColorCurrentDirection;

@end

#pragma mark -
@protocol EVARoundSliderDataSource <NSObject>

#pragma mark Settings
/**
 *  Метод определения ширины арки слайдера.
 *
 *  @param slider указатель на инстанс слайдера
 *
 *  @return ширина арки слайдера
 */
- (CGFloat)widthForSlider:(EVARoundSliderView *)slider;
/**
 *  Метод для определения количества ручек на слайдере. Допустимо: одна или две.
 *
 *  @param slider указатель на инстанс слайдера
 *
 *  @return количество ручек, используемое на слайдере
 */
- (NSUInteger)numberOfHandlesAtSlider:(EVARoundSliderView *)slider;

#pragma mark Views
/**
 *  Метод для определения view ручки слайдера.
 *
 *  @param slider указатель на инстанс слайдера
 *  @param index  индекс ручки
 *
 *  @return кастомизированая view ручки
 */
- (UIView *)handleViewForSlider:(EVARoundSliderView *)slider atIndex:(NSUInteger)index;

@optional
/**
 *  Метод определения типа слайдера. EVASliderTypePlain by default
 *
 *  @param slider указатель на инстанс слайдера
 *
 *  @return тип слайдера
 */
- (EVASliderType)typeOfSlider:(EVARoundSliderView *)slider;
/**
 *  В методе определяется цвет для пассивной части арки слайдера. Clear color by default. Метод работает для слайдера с двумя ручками.
 *
 *  @param slider указатель на инстанс слайдера
 *
 *  @return цвет для пассивной арки слайдера
 */
- (UIColor *)shadowArcColorAtSlider:(EVARoundSliderView *)slider;
/**
 *  Метод определения в каком направлении будет вырисовываться арка слайдера. Используйте EVAArcDirectionCalculated если необходимо переключать направление касанием. Метод работает для слайдера с двумя ручками. EVAArcDirectionClockwise is default
 *
 *  @param slider указатель на инстанс слайдера
 *
 *  @return тип направления арки слайдера
 */
- (EVAArcDirection)arcDrawingDirectionForSlider:(EVARoundSliderView *)slider;
/**
 *  Метод для определения допуском отклонений жеста от движения по слайдеру. CGFLOAT_MAX by default for both
 *
 *  @param slider указатель на инстанс слайдера
 *
 *  @return структура, определяющая внешний и внутренний допуск
 */
- (EVATouchOffset)touchRecognizeOffsetForSlider:(EVARoundSliderView *)slider;
/**
 *  В этом методе определяется будет ли отменено слежение за жестом пользователя, если была покинута зона EVATouchOffset. NO by default
 *
 *  @param slider указатель на инстанс слайдера
 *
 *  @return YES if need to revoke gestures. Otherwise NO.
 */
- (BOOL)revokeTouchesBeyondBoundsOffsetForSlider:(EVARoundSliderView *)slider;

#pragma mark Views
/**
 *  В этом методе можно определить кастомизированную view для фона слайдера. При реализации метода и типе слайдера EVASliderTypeGradient стандартный градиент будет заменен этой view. Как пример: использовать картинку градиента для лучшего перфоманса.
 *
 *  @param slider указатель на инстанс слайдера
 *
 *  @return кастомизированная view для фона
 */
- (UIView *)backgroundViewForSlider:(EVARoundSliderView *)slider;
/**
 *  В этом методе можно определить кастомизированную view, которая будет размещена в середине слайдера. View будет обрезана по окружности (radius - width) слайдера.
 *
 *  @param slider указатель на инстанс слайдера
 *
 *  @return кастомизированная view для центра
 */
- (UIView *)centerViewForSlider:(EVARoundSliderView *)slider;
/**
 *  В этом методе можно определить кастомизированную view для индикатора. Если метод не реализован, на слайдере индикатор показан не будет.
 *
 *  @param slider указатель на инстанс слайдера
 *
 *  @return кастомизированная view для индикатора
 */
- (UIView *)indicatorViewForSlider:(EVARoundSliderView *)slider;
@end

#pragma mark -
@protocol EVARoundSliderDelegate <NSObject>

@optional

#pragma mark Handles
/**
 *  Метод вызывается, когда любая из ручек слайдера меняет свою позицию.
 *
 *  @param slider   указатель на инстанс слайдера
 *  @param position текущая координата ручки
 *  @param index    индекс ручки
 */
- (void)slider:(EVARoundSliderView *)slider handlePosition:(CGPoint)position atIndex:(NSUInteger)index;
/**
 *  Метод вызывается, когда любая из ручек слайдера меняет свою позицию.
 *
 *  @param slider указатель на инстанс слайдера
 *  @param color  текущий цвет для ручки
 *  @param index  индекс ручки
 */
- (void)slider:(EVARoundSliderView *)slider colorHandlePosition:(UIColor *)color atIndex:(NSUInteger)index;
/**
 *  Метод вызывается, когда любая из ручек слайдера меняет свою позицию. Метод доступен только в режиме EVASliderTypeGradient
 *
 *  @param slider указатель на инстанс слайдера
 *  @param angle  текущий угол для ручки в degree
 *  @param index  индекс ручки
 */
- (void)slider:(EVARoundSliderView *)slider angleHandlePosition:(NSUInteger)angle atIndex:(NSUInteger)index;

#pragma mark Indicator
/**
 *  Метод вызывается, когда индикатор меняет позицию.
 *
 *  @param slider   указатель на инстанс слайдера
 *  @param position координата текущей позиции индикатора
 */
- (void)slider:(EVARoundSliderView *)slider indicatorPosition:(CGPoint)position;
/**
 *  Метод вызывается, когда индикатор меняет позицию. Метод доступен только в режиме EVASliderTypeGradient
 *
 *  @param slider указатель на инстанс слайдера
 *  @param color  текущий цвет для позиции индикатора
 */
- (void)slider:(EVARoundSliderView *)slider indicatorColorAtPosition:(UIColor *)color;
/**
 *  Метод вызывается, когда индикатор меняет позицию.
 *
 *  @param slider указатель на инстанс слайдера
 *  @param angle  текущий угол для позиции индикатора в degree
 */
- (void)slider:(EVARoundSliderView *)slider indicatorAngleAtPosition:(NSUInteger)angle;

#pragma mark Moving control
/**
 *  Метод вызывается, когда пользователь двигает любую из ручек слайдера.
 *
 *  @param slider указатель на инстанс слайдера
 */
- (void)sliderDraggin:(EVARoundSliderView *)slider;
/**
 *  Метод вызывается, когда пользователь отпустил любую из ручек слайдера после движения или движение было отменено системой (входящий вызов, смс иное).
 *
 *  @param slider указатель на инстанс слайдера
 */
- (void)sliderDidEndDragging:(EVARoundSliderView *)slider;
@end