//
//  UIColor+customColors.m
//  learningXcode
//
//  Created by Stellios Bonadurer on 5/29/15.
//  Copyright (c) 2015 Stellios Bonadurer. All rights reserved.
//

#import "UIColor+customColors.h"

@implementation UIColor (customColors)

+ (UIColor *) circleColor
{
    return [UIColor colorWithRed:(120/255.0) green:(100/255.0) blue:(79/255.0) alpha:(1)];
}
+ (UIColor *) backgroundColor
{
    return [UIColor colorWithRed:(245/255.0) green:(215/255.0) blue:(164/255.0) alpha:(1)];
}
+ (UIColor *) player1Color
{
    return [UIColor colorWithRed:(226/255.0) green:(80/255.0) blue:(50/255.0) alpha:(1)];
}
+ (UIColor *) player2Color
{
    return [UIColor colorWithRed:(31/255.0) green:(139/255.0) blue:(131/255.0) alpha:(1)];
}
@end
