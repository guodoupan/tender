//
//  CardsViewController.m
//  tender
//
//  Created by Doupan Guo on 2/19/15.
//  Copyright (c) 2015 Doupan Guo. All rights reserved.
//

#import "CardsViewController.h"
#import "ProfileViewController.h"

@interface CardsViewController () <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, assign) BOOL isPresenting;

@end

@implementation CardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap:)];
    [self.imageView addGestureRecognizer:tapRecognizer];
}

- (void)onTap: (UITapGestureRecognizer *)sender {
    ProfileViewController *vc = [[ProfileViewController alloc]init];
    [vc setImage:self.imageView.image];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate = self;
    
    UIImageView *tmpImage = [[UIImageView alloc] initWithImage:self.imageView.image];
    tmpImage.frame = self.imageView.frame;
    tmpImage.center = self.imageView.center;
    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:tmpImage];
    
    [UIView animateWithDuration:0.4 animations:^{
        tmpImage.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [tmpImage removeFromSuperview];
        [self presentViewController:vc animated:NO completion:nil];
    }];
    
   // [self presentViewController:vc animated:YES completion:nil];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.isPresenting = YES;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.isPresenting = NO;
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.4;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    if (self.isPresenting) {
        NSLog(@"I'm presenting");
        toViewController.view.frame = fromViewController.view.frame;
        [containerView addSubview:toViewController.view];
        toViewController.view.alpha = 0;
        [UIView animateWithDuration:0.4 animations:^{
            toViewController.view.alpha = 1;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else {
        NSLog(@"I'm dismissing");
        
        [UIView animateWithDuration:0.4 animations:^{
            fromViewController.view.alpha = 0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
            [fromViewController.view removeFromSuperview];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
