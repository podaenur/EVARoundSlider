//
//  EVAMath.h
//  objC_roundSlider
//
//  Created by Evgeniy Akhmerov on 18/11/15.
//  Copyright © 2015 Eugeny Akhmerov. All rights reserved.
//

#define ToRad(deg) 		( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)		( (180.0 * (rad)) / M_PI )

#define EVA_FLIPPED YES

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//Sourcecode from Apple example clockControl
//Calculate the direction in degrees from a center point to an arbitrary position.

static inline float AngleFromNorth(CGPoint centerPoint, CGPoint currentPoint, BOOL flipped) {
  CGFloat x = currentPoint.x - centerPoint.x;
  CGFloat y = currentPoint.y - centerPoint.y;
  if (!flipped) {
    y *= -1;
  }
  
  CGPoint v = CGPointMake(x, y);
  float vmag = sqrt(pow(v.x, 2) + pow(v.y, 2)), result = 0;
  v.x /= vmag;
  v.y /= vmag;
  double radians = atan2(v.y,v.x);
  result = ToDeg(radians);
  return (result >=0  ? result : result + 360.0);
}

static inline CGPoint CGPointInfinity() {
  return CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
};

static inline BOOL CGPointIsInfinity(CGPoint p) {
   return CGPointEqualToPoint(p, CGPointInfinity());
};

@interface EVAMath : NSObject

/**
 *  Метод вычисления длины отрезка
 *
 *  @param p1 координата первой точки
 *  @param p2 координата второй точки
 *
 *  @return растояние между точками
 */
- (CGFloat)distanceBetweenPoint:(CGPoint)p1 andPoint:(CGPoint)p2;

/**
 *  Метод для вычисления угла вектора между двумя задаными углами. Угол вычисляется по сереине между задаными углами.
 *
 *  @param sAngle      первый угол в degree
 *  @param eAngle      второй уогл в degree
 *  @param isClockwise направление вычисления от первого угла ко второму
 *
 *  @return угол между задаными углами
 */
- (CGFloat)bisectorForStartAngle:(CGFloat)sAngle endAngle:(CGFloat)eAngle clockwise:(BOOL)isClockwise;

/**
 *  Метод расчета координаты на окружности для указаного в degree угла
 *
 *  @param c        центер окружности
 *  @param r        радиус окружности
 *  @param angleInt угол в degree
 *
 *  @return 2d координата на окружности
 */
- (CGPoint)pointOnCircleWithCenter:(CGPoint)c radius:(CGFloat)r forAngle:(int)angleInt;

/**
 *  Метод вычисляет угол для заданого цвета по шкале HUE
 *
 *  @param color заданый цвет в RGBA
 *
 *  @return угол в degree
 */
- (CGFloat)getAngleForColor:(UIColor *)color;

/**
 *  Метод вычисления цвета RGBA для заданого угла в degree.
 *
 *  @param angle заданый угол в degree
 *
 *  @return цвет RGBA для заданого угла
 */
- (UIColor *)getColorForAngle:(CGFloat)angle;

/**
 *  Метот смены местави значений переданых аргументов. Thread free.
 *
 *  @param arg1 указатель на первый аргумент
 *  @param arg2 указатель на второй аргумент
 */
- (void)swapCGFloat:(inout CGFloat *)arg1 andCGFloat:(inout CGFloat *)arg2;

/**
 *  Метод для определения находится ли заданая точка на окружности между начальной и конечной
 *
 *  @param p Определяемая точка на окружности
 *  @param s Начальная точка на окружности
 *  @param e Конечная точка на окружности
 *  @param c Центр окружности
 *
 *  @return True if p between s and e. Otherwise false.
 */
- (BOOL)whetherClockwiseDirectionByPoint:(CGPoint)p betweenPoint:(CGPoint)s andPoint:(CGPoint)e atCenter:(CGPoint)c;

@end
