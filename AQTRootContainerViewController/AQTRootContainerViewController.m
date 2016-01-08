// AQTRootContainerViewController.m
//
// Copyright (c) 2016 Adrien Truong
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AQTRootContainerViewController.h"

@interface AQTRootContainerTransitionContext : NSObject <UIViewControllerContextTransitioning>

@property (nonatomic, strong) UIViewController *fromViewController;
@property (nonatomic, strong) UIViewController *toViewController;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, copy) void (^completionHandler)(BOOL didComplete);

@end

@implementation AQTRootContainerTransitionContext

- (__kindof UIViewController *)viewControllerForKey:(NSString *)key
{
    if ([key isEqualToString:UITransitionContextFromViewControllerKey]) {
        return self.fromViewController;
    } else {
        return self.toViewController;
    }
}

- (UIView *)viewForKey:(NSString *)key
{
    if ([key isEqualToString:UITransitionContextFromViewKey]) {
        return self.fromViewController.view;
    } else {
        return self.toViewController.view;
    }
}

- (CGRect)initialFrameForViewController:(UIViewController *)viewController
{
    if (viewController == self.fromViewController) {
        return self.fromViewController.view.frame;
    } else {
        return CGRectZero;
    }
}

- (CGRect)finalFrameForViewController:(UIViewController *)viewController
{
    if (viewController == self.fromViewController) {
        return CGRectZero;
    } else {
        return self.fromViewController.view.frame;
    }
}

- (BOOL)isAnimated
{
    return YES;
}

- (BOOL)isInteractive
{
    return NO;
}

- (UIModalPresentationStyle)presentationStyle
{
    return UIModalPresentationFullScreen;
}

- (BOOL)transitionWasCancelled
{
    return NO;
}

- (void)completeTransition:(BOOL)didComplete
{
    if (self.completionHandler) {
        self.completionHandler(didComplete);
    }
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete {}
- (void)finishInteractiveTransition {}
- (void)cancelInteractiveTransition {}

- (CGAffineTransform)targetTransform
{
    return CGAffineTransformIdentity;
}

@end

@interface AQTRootContainerViewController ()

@property (nonatomic, assign) BOOL installedRootView;

@end

@implementation AQTRootContainerViewController

- (void)installRootViewController
{
    [self addChildViewController:self.rootViewController];
    
    UIView *rootView = self.rootViewController.view;
    [rootView setTranslatesAutoresizingMaskIntoConstraints:YES];
    rootView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    rootView.frame = self.view.bounds;
    [self.view addSubview:self.rootViewController.view];
    
    [self.rootViewController didMoveToParentViewController:self];
    self.installedRootView = YES;
}

- (void)setRootViewController:(UIViewController *)rootViewController
{
    if (self.installedRootView) {
        [self.rootViewController willMoveToParentViewController:nil];
        [self.rootViewController.view removeFromSuperview];
        [self.rootViewController removeFromParentViewController];
    }
    
    _rootViewController = rootViewController;
    _rootViewController.definesPresentationContext = YES;
    
    self.installedRootView = NO;
    
    if (self.isViewLoaded) {
        [self installRootViewController];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.rootViewController) {
        [self installRootViewController];
    }
}

- (void)setRootViewController:(UIViewController *)toViewController
                  withAnimator:(id<UIViewControllerAnimatedTransitioning>)animator
{
    UIViewController *fromViewController = self.rootViewController;
    [fromViewController willMoveToParentViewController:nil];
    
    [self addChildViewController:toViewController];
    UIView *toView = toViewController.view;
    [toView setTranslatesAutoresizingMaskIntoConstraints:YES];
    toView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    toView.frame = self.view.bounds;
    
    _rootViewController = toViewController;
    _rootViewController.definesPresentationContext = YES;
    
    AQTRootContainerTransitionContext *transitionContext = [[AQTRootContainerTransitionContext alloc] init];
    transitionContext.fromViewController = fromViewController;
    transitionContext.toViewController = toViewController;
    transitionContext.containerView = self.view;
    transitionContext.completionHandler = ^(BOOL didComplete) {
        [fromViewController.view removeFromSuperview];
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];
        
        if ([animator respondsToSelector:@selector(animationEnded:)]) {
            [animator animationEnded:didComplete];
        }
    };
    
    [animator animateTransition:transitionContext];
}

@end
