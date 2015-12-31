//
//  FlatButton.m
//  test
//
//  Created by Brian Olencki on 12/30/15.
//  Copyright © 2015 bolencki13. All rights reserved.
//

#import "FlatButton.h"

@implementation UIColor (CustomColors)
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
+ (UIColor *) flat:(Colors) color {
    return UIColorFromRGB(color);
}
- (UIColor*)inverseColor {
    CGFloat r,g,b,a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return [UIColor colorWithRed:1.-r green:1.-g blue:1.-b alpha:a];
}
- (UIColor *)lighterColor {
    CGFloat r, g, b, a;
    if ([self getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MIN(r + 0.1, 1.0)
                               green:MIN(g + 0.1, 1.0)
                                blue:MIN(b + 0.1, 1.0)
                               alpha:a];
    return nil;
}
- (UIColor *)darkerColor {
    CGFloat r, g, b, a;
    if ([self getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.1, 0.0)
                               green:MAX(g - 0.1, 0.0)
                                blue:MAX(b - 0.1, 0.0)
                               alpha:a];
    return nil;
}
@end

@implementation FlatButton
- (void)sizeToFit {
    [super sizeToFit];
    self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width+40, self.bounds.size.height+10);
    self.layer.cornerRadius = [FlatButton cornerRadius];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.backgroundColor = [self.backgroundColor darkerColor];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.backgroundColor = [self.backgroundColor lighterColor];
}
+ (CGFloat)cornerRadius {
    return 5.0;
}
@end
