//
// REFrostedContainerViewController.m
// REFrostedViewController
//
// Copyright (c) 2013 Roman Efimov (https://github.com/romaonthego)
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
//

#import "REFrostedContainerViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "REFrostedViewController.h"
#import "RECommonFunctions.h"

@interface REFrostedContainerViewController ()

@property (nonatomic, readwrite) UIImageView *backgroundImageView;
@property (nonatomic, readwrite) NSMutableArray *backgroundViews;
@property (nonatomic, readwrite) UIView *containerView;
@property (nonatomic, readwrite) CGPoint containerOrigin;

@end

@interface REFrostedViewController ()

@property (nonatomic, readwrite, getter=isVisible) BOOL visible;
@property (nonatomic, readwrite) CGSize calculatedMenuViewSize;

@end

@implementation REFrostedContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.backgroundViews = [NSMutableArray arrayWithCapacity:4];

    for (NSUInteger i = 0; i < 4; ++ i) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectNull];
        backgroundView.backgroundColor = [UIColor blackColor];
        backgroundView.alpha = 0.0f;
        [self.view addSubview:backgroundView];
        [self.backgroundViews addObject:backgroundView];

        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(tapGestureRecognized:)];
        [backgroundView addGestureRecognizer:tapRecognizer];
    }

    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                                  250,
                                                                  self.view.frame.size.height)];
    self.containerView.clipsToBounds = YES;
    [self.view addSubview:self.containerView];

    REFrostedViewController *strongFrostedViewController = self.frostedViewController;
    if (strongFrostedViewController.liveBlur) {
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.view.bounds];
        toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        toolbar.barStyle = (UIBarStyle)strongFrostedViewController.liveBlurBackgroundStyle;
        [self.containerView addSubview:toolbar];
    }

    else {
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [self.containerView addSubview:self.backgroundImageView];
    }

    if (strongFrostedViewController.menuViewController) {
        [self addChildViewController:strongFrostedViewController.menuViewController];
        strongFrostedViewController.menuViewController.view.frame = self.containerView.bounds;
        [self.containerView addSubview:strongFrostedViewController.menuViewController.view];
        [strongFrostedViewController.menuViewController didMoveToParentViewController:self];
    }

    [self.view addGestureRecognizer:strongFrostedViewController.panGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    REFrostedViewController *strongFrostedViewController = self.frostedViewController;
    if(!strongFrostedViewController.isVisible) {
        self.backgroundImageView.image = self.screenshotImage;
        self.backgroundImageView.frame = self.view.bounds;
        strongFrostedViewController.menuViewController.view.frame = self.containerView.bounds;

        switch (strongFrostedViewController.direction) {
            case REFrostedViewControllerDirectionLeft:
                [self setContainerFrame:CGRectMake(- strongFrostedViewController.calculatedMenuViewSize.width, 0, strongFrostedViewController.calculatedMenuViewSize.width, strongFrostedViewController.calculatedMenuViewSize.height)];
                break;

            case REFrostedViewControllerDirectionRight:
                [self setContainerFrame:CGRectMake(self.view.frame.size.width, 0, strongFrostedViewController.calculatedMenuViewSize.width, strongFrostedViewController.calculatedMenuViewSize.height)];
                break;

            case REFrostedViewControllerDirectionTop:
                [self setContainerFrame:CGRectMake(0, -strongFrostedViewController.calculatedMenuViewSize.height, strongFrostedViewController.calculatedMenuViewSize.width, strongFrostedViewController.calculatedMenuViewSize.height)];
                break;

            case REFrostedViewControllerDirectionBottom:
                [self setContainerFrame:CGRectMake(0, self.view.frame.size.height, strongFrostedViewController.calculatedMenuViewSize.width, strongFrostedViewController.calculatedMenuViewSize.height)];
                break;
        }

        if (self.isAnimateApperance) {
            [self show];
        }
    }
}

- (void)setContainerFrame:(CGRect)frame {
    UIView *leftBackgroundView = self.backgroundViews[0];
    UIView *topBackgroundView = self.backgroundViews[1];
    UIView *bottomBackgroundView = self.backgroundViews[2];
    UIView *rightBackgroundView = self.backgroundViews[3];

    self.containerView.frame = frame;

    leftBackgroundView.frame = CGRectMake(0, 0, frame.origin.x,
                                          self.view.frame.size.height);
    rightBackgroundView.frame = CGRectMake(frame.size.width + frame.origin.x,
                                           0,
                                           self.view.frame.size.width - frame.size.width - frame.origin.x,
                                           self.view.frame.size.height);

    topBackgroundView.frame = CGRectMake(frame.origin.x, 0, frame.size.width, frame.origin.y);
    bottomBackgroundView.frame = CGRectMake(frame.origin.x,
                                            frame.size.height + frame.origin.y,
                                            frame.size.width,
                                            self.view.frame.size.height);


    self.backgroundImageView.frame = CGRectMake(- frame.origin.x,
                                                - frame.origin.y,
                                                self.view.bounds.size.width,
                                                self.view.bounds.size.height);
}

- (void)setBackgroundViewsAlpha:(CGFloat)alpha {
    for (UIView *view in self.backgroundViews) {
        view.alpha = alpha;
    }
}

- (void)resizeToSize:(CGSize)size {
    REFrostedViewController *strongFrostedViewController = self.frostedViewController;

    switch (strongFrostedViewController.direction) {
        case REFrostedViewControllerDirectionLeft: {
            [UIView animateWithDuration:strongFrostedViewController.animationDuration animations:^{
                [self setContainerFrame:CGRectMake(0, 0, size.width, size.height)];
                [self setBackgroundViewsAlpha:strongFrostedViewController.backgroundFadeAmount];
            } completion:nil];
        }
            break;

        case REFrostedViewControllerDirectionRight: {
            [UIView animateWithDuration:strongFrostedViewController.animationDuration animations:^{
                [self setContainerFrame:CGRectMake(self.view.frame.size.width - size.width, 0, size.width, size.height)];
                [self setBackgroundViewsAlpha:strongFrostedViewController.backgroundFadeAmount];
            } completion:nil];
        }
            break;

        case REFrostedViewControllerDirectionTop: {
            [UIView animateWithDuration:strongFrostedViewController.animationDuration animations:^{
                [self setContainerFrame:CGRectMake(0, 0, size.width, size.height)];
                [self setBackgroundViewsAlpha:strongFrostedViewController.backgroundFadeAmount];
            } completion:nil];
        }
            break;

        case REFrostedViewControllerDirectionBottom: {
            [UIView animateWithDuration:strongFrostedViewController.animationDuration animations:^{
                [self setContainerFrame:CGRectMake(0, self.view.frame.size.height - size.height, size.width, size.height)];
                [self setBackgroundViewsAlpha:strongFrostedViewController.backgroundFadeAmount];
            } completion:nil];
        }
            break;
    }
}

- (void)show {
    REFrostedViewController *viewController = self.frostedViewController;
    id<REFrostedViewControllerDelegate> delegate = viewController.delegate;

    void (^completionHandler)(BOOL finished) = ^(BOOL __unused finished) {
        if ([delegate conformsToProtocol:@protocol(REFrostedViewControllerDelegate)] && [delegate respondsToSelector:@selector(frostedViewController:didShowMenuViewController:)]) {
            [delegate frostedViewController:viewController
                  didShowMenuViewController:viewController.menuViewController];
        }
    };

    switch (viewController.direction) {
        case REFrostedViewControllerDirectionLeft: {
            [UIView animateWithDuration:viewController.animationDuration
                             animations:^(void) {
                                 [self setContainerFrame:CGRectMake(0, 0,
                                                                    viewController.calculatedMenuViewSize.width,
                                                                    viewController.calculatedMenuViewSize.height)];
                                 [self setBackgroundViewsAlpha:viewController.backgroundFadeAmount];
                             }
                             completion:completionHandler];
        }
            break;

        case REFrostedViewControllerDirectionRight: {
            [UIView animateWithDuration:viewController.animationDuration
                             animations:^(void) {
                                 [self setContainerFrame:CGRectMake(self.view.frame.size.width - viewController.calculatedMenuViewSize.width,
                                                                    0,
                                                                    viewController.calculatedMenuViewSize.width,
                                                                    viewController.calculatedMenuViewSize.height)];
                                 [self setBackgroundViewsAlpha:viewController.backgroundFadeAmount];
                             }
                             completion:completionHandler];
        }
            break;

        case REFrostedViewControllerDirectionTop: {
            [UIView animateWithDuration:viewController.animationDuration
                             animations:^(void) {
                                 [self setContainerFrame:CGRectMake(0, 0,
                                                                    viewController.calculatedMenuViewSize.width,
                                                                    viewController.calculatedMenuViewSize.height)];
                                 [self setBackgroundViewsAlpha:viewController.backgroundFadeAmount];
                             }
                             completion:completionHandler];
        }
            break;

        case REFrostedViewControllerDirectionBottom: {
            [UIView animateWithDuration:viewController.animationDuration
                             animations:^(void) {
                                 [self setContainerFrame:CGRectMake(0,
                                                                    self.view.frame.size.height - viewController.calculatedMenuViewSize.height,
                                                                    viewController.calculatedMenuViewSize.width,
                                                                    viewController.calculatedMenuViewSize.height)];
                                 [self setBackgroundViewsAlpha:viewController.backgroundFadeAmount];
                             }
                             completion:completionHandler];
        }
            break;
    }
}


- (void)hide {
    [self hideWithCompletionHandler:nil];
}

- (void)hideWithCompletionHandler:(void(^)(void))completionHandler {
    REFrostedViewController *strongFrostedViewController = self.frostedViewController;
    id<REFrostedViewControllerDelegate> strongDelegate = strongFrostedViewController.delegate;

    void (^completionHandlerBlock)(void) = ^(void){
        if ([strongDelegate conformsToProtocol:@protocol(REFrostedViewControllerDelegate)] && [strongDelegate respondsToSelector:@selector(frostedViewController:didHideMenuViewController:)]) {
            [strongDelegate frostedViewController:strongFrostedViewController didHideMenuViewController:strongFrostedViewController.menuViewController];
        }

        if (completionHandler) {
            completionHandler();
        }
    };

    if ([strongDelegate conformsToProtocol:@protocol(REFrostedViewControllerDelegate)] && [strongDelegate respondsToSelector:@selector(frostedViewController:willHideMenuViewController:)]) {
        [strongDelegate frostedViewController:strongFrostedViewController willHideMenuViewController:strongFrostedViewController.menuViewController];
    }

    if (strongFrostedViewController.direction == REFrostedViewControllerDirectionLeft) {
        [UIView animateWithDuration:strongFrostedViewController.animationDuration
                         animations:^(void) {
                             [self setContainerFrame:CGRectMake(- strongFrostedViewController.calculatedMenuViewSize.width, 0, strongFrostedViewController.calculatedMenuViewSize.width, strongFrostedViewController.calculatedMenuViewSize.height)];
                             [self setBackgroundViewsAlpha:0];
                         } completion:^(BOOL __unused finished) {
                             strongFrostedViewController.visible = NO;
                             [strongFrostedViewController re_hideController:self];
                             completionHandlerBlock();
                         }];
    }

    if (strongFrostedViewController.direction == REFrostedViewControllerDirectionRight) {
        [UIView animateWithDuration:strongFrostedViewController.animationDuration
                         animations:^(void) {
                             [self setContainerFrame:CGRectMake(self.view.frame.size.width, 0, strongFrostedViewController.calculatedMenuViewSize.width, strongFrostedViewController.calculatedMenuViewSize.height)];
                             [self setBackgroundViewsAlpha:0];
                         }
                         completion:^(BOOL __unused finished) {
                             strongFrostedViewController.visible = NO;
                             [strongFrostedViewController re_hideController:self];
                             completionHandlerBlock();
                         }];
    }

    if (strongFrostedViewController.direction == REFrostedViewControllerDirectionTop) {
        [UIView animateWithDuration:strongFrostedViewController.animationDuration
                         animations:^(void) {
                             [self setContainerFrame:CGRectMake(0, -strongFrostedViewController.calculatedMenuViewSize.height, strongFrostedViewController.calculatedMenuViewSize.width, strongFrostedViewController.calculatedMenuViewSize.height)];
                             [self setBackgroundViewsAlpha:0];
                         }
                         completion:^(BOOL __unused finished) {
                             strongFrostedViewController.visible = NO;
                             [strongFrostedViewController re_hideController:self];
                             completionHandlerBlock();
                         }];
    }

    if (strongFrostedViewController.direction == REFrostedViewControllerDirectionBottom) {
        [UIView animateWithDuration:strongFrostedViewController.animationDuration
                         animations:^(void) {
                             [self setContainerFrame:CGRectMake(0, self.view.frame.size.height, strongFrostedViewController.calculatedMenuViewSize.width, strongFrostedViewController.calculatedMenuViewSize.height)];
                             [self setBackgroundViewsAlpha:0];
                         }
                         completion:^(BOOL __unused finished) {
                             strongFrostedViewController.visible = NO;
                             [strongFrostedViewController re_hideController:self];
                             completionHandlerBlock();
                         }];
    }
}

- (void)refreshBackgroundImage {
    self.backgroundImageView.image = self.screenshotImage;
}

#pragma mark -
#pragma mark Gesture recognizer
- (void)tapGestureRecognized:(UITapGestureRecognizer * __unused)recognizer {
    [self hide];
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer {
    REFrostedViewController *viewController = self.frostedViewController;
    id<REFrostedViewControllerDelegate> delegate = viewController.delegate;
    if ([delegate conformsToProtocol:@protocol(REFrostedViewControllerDelegate)] && [delegate respondsToSelector:@selector(frostedViewController:didRecognizePanGesture:)])
        [delegate frostedViewController:viewController didRecognizePanGesture:recognizer];

    if (!viewController.panGestureEnabled) {
        return;
    }

    CGPoint point = [recognizer translationInView:self.view];

    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.containerOrigin = self.containerView.frame.origin;
            break;

        case UIGestureRecognizerStateChanged:{
            CGRect frame = self.containerView.frame;

            switch (viewController.direction) {
                case REFrostedViewControllerDirectionLeft:
                    frame.origin.x = self.containerOrigin.x + point.x;
                    if (frame.origin.x > 0) {
                        frame.origin.x = 0;

                        if (!viewController.limitMenuViewSize) {
                            frame.size.width = viewController.calculatedMenuViewSize.width + self.containerOrigin.x + point.x;
                            if (frame.size.width > self.view.frame.size.width)
                                frame.size.width = self.view.frame.size.width;
                        }
                    }

                    break;

                case REFrostedViewControllerDirectionRight:
                    frame.origin.x = self.containerOrigin.x + point.x;
                    if (frame.origin.x < self.view.frame.size.width - viewController.calculatedMenuViewSize.width) {
                        frame.origin.x = self.view.frame.size.width - viewController.calculatedMenuViewSize.width;

                        if (!viewController.limitMenuViewSize) {
                            frame.origin.x = self.containerOrigin.x + point.x;
                            if (frame.origin.x < 0) {
                                frame.origin.x = 0;
                            }

                            frame.size.width = self.view.frame.size.width - frame.origin.x;
                        }
                    }
                    break;

                case REFrostedViewControllerDirectionTop:
                    frame.origin.y = self.containerOrigin.y + point.y;
                    if (frame.origin.y > 0) {
                        frame.origin.y = 0;

                        if (!viewController.limitMenuViewSize) {
                            frame.size.height = viewController.calculatedMenuViewSize.height + self.containerOrigin.y + point.y;
                            if (frame.size.height > self.view.frame.size.height)
                                frame.size.height = self.view.frame.size.height;
                        }
                    }
                    break;

                case REFrostedViewControllerDirectionBottom:
                    frame.origin.y = self.containerOrigin.y + point.y;
                    if (frame.origin.y < self.view.frame.size.height - viewController.calculatedMenuViewSize.height) {
                        frame.origin.y = self.view.frame.size.height - viewController.calculatedMenuViewSize.height;

                        if (!viewController.limitMenuViewSize) {
                            frame.origin.y = self.containerOrigin.y + point.y;

                            if (frame.origin.y < 0) {
                                frame.origin.y = 0;
                            }

                            frame.size.height = self.view.frame.size.height - frame.origin.y;
                        }
                    }
                    break;
            }

            [self setContainerFrame:frame];

        }
            break;

        case UIGestureRecognizerStateEnded:
            switch (viewController.direction) {
                case REFrostedViewControllerDirectionLeft:
                    if ([recognizer velocityInView:self.view].x < 0) {
                        [self hide];
                    }

                    else {
                        [self show];
                    }

                    break;

                case REFrostedViewControllerDirectionRight:
                    if ([recognizer velocityInView:self.view].x < 0) {
                        [self show];
                    }

                    else {
                        [self hide];
                    }

                    break;

                case REFrostedViewControllerDirectionTop:
                    if ([recognizer velocityInView:self.view].y < 0) {
                        [self hide];
                    }

                    else {
                        [self show];
                    }

                    break;

                case REFrostedViewControllerDirectionBottom:
                    if ([recognizer velocityInView:self.view].y < 0) {
                        [self show];
                    }

                    else {
                        [self hide];
                    }

                    break;
            }
            break;
        case UIGestureRecognizerStatePossible:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            break;
    }
}

- (void)fixLayoutWithDuration:(NSTimeInterval __unused)duration {
    REFrostedViewController *strongFrostedViewController = self.frostedViewController;

    switch (strongFrostedViewController.direction) {
        case REFrostedViewControllerDirectionLeft:
            [self setContainerFrame:CGRectMake(0, 0, strongFrostedViewController.calculatedMenuViewSize.width, strongFrostedViewController.calculatedMenuViewSize.height)];
            [self setBackgroundViewsAlpha:strongFrostedViewController.backgroundFadeAmount];
            break;

        case REFrostedViewControllerDirectionRight:
            [self setContainerFrame:CGRectMake(self.view.frame.size.width - strongFrostedViewController.calculatedMenuViewSize.width, 0, strongFrostedViewController.calculatedMenuViewSize.width, strongFrostedViewController.calculatedMenuViewSize.height)];
            [self setBackgroundViewsAlpha:strongFrostedViewController.backgroundFadeAmount];
            break;

        case REFrostedViewControllerDirectionTop:
            [self setContainerFrame:CGRectMake(0, 0, strongFrostedViewController.calculatedMenuViewSize.width, strongFrostedViewController.calculatedMenuViewSize.height)];
            [self setBackgroundViewsAlpha:strongFrostedViewController.backgroundFadeAmount];
            break;

        case REFrostedViewControllerDirectionBottom:
            [self setContainerFrame:CGRectMake(0, self.view.frame.size.height - strongFrostedViewController.calculatedMenuViewSize.height, strongFrostedViewController.calculatedMenuViewSize.width, strongFrostedViewController.calculatedMenuViewSize.height)];
            [self setBackgroundViewsAlpha:strongFrostedViewController.backgroundFadeAmount];
            break;
    }
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self fixLayoutWithDuration:duration];
}
#pragma clang diagnostic pop
@end
