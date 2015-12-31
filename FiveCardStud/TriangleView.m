//
//  TriangleView.m
//  FiveCardStud
//
//  Created by Brian Olencki on 12/30/15.
//  Copyright © 2015 bolencki13. All rights reserved.
//

#import "TriangleView.h"

@implementation TriangleView
- (id)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        UIBezierPath *path = [UIBezierPath new];
        [path moveToPoint:(CGPoint){frame.size.width, 0}];
        [path addLineToPoint:(CGPoint){frame.size.width, frame.size.height}];
        [path addLineToPoint:(CGPoint){0, frame.size.height}];
        [path addLineToPoint:(CGPoint){frame.size.width, 0}];
        
        // Create a CAShapeLayer with this triangular path
        // Same size as the original imageView
        CAShapeLayer *mask = [CAShapeLayer new];
        mask.frame = self.bounds;
        mask.path = path.CGPath;
        
        // Mask the imageView's layer with this shape
        self.layer.mask = mask;
    }
    return self;
}
@end
