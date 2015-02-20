//
//  DraggableImageView.m
//  tender
//
//  Created by Doupan Guo on 2/19/15.
//  Copyright (c) 2015 Doupan Guo. All rights reserved.
//

#import "DraggableImageView.h"

@interface DraggableImageView()

@property (nonatomic, assign) CGPoint initialCenter;
@property (nonatomic, assign) CGRect initialFrame;
@property (nonatomic, assign) CGAffineTransform initialTransform;

@end

@implementation DraggableImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)setup {
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [self addGestureRecognizer:panGesture];
}

- (void)onPan: (UIPanGestureRecognizer *)sender {
    CGPoint velocity = [sender velocityInView:sender.view];
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.initialCenter = self.center;
        self.initialTransform = self.transform;
        CGPoint point = [sender locationInView:sender.view];
        int sign = 1;
        if (point.y > self.image.size.height) {
            sign = velocity.x > 0 ? -1 : 1;
        } else {
            sign = velocity.x > 0 ? 1 : -1;
        }
            [UIView animateWithDuration:(0.4) animations:^{
                self.transform = CGAffineTransformMakeRotation(10 * M_PI / 180 * sign);
            }];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [sender translationInView:sender.view];
        self.center = CGPointMake(self.initialCenter.x + translation.x, self.initialCenter.y + translation.y);
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.4 animations:^{
            self.center = self.initialCenter;
            self.transform = CGAffineTransformIdentity;
        }];
    }
}

@end
