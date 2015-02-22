# REFrostedViewController

This is a simplified version of Romamn Efimov's REFrostedViewController. It is a great example of how to handle menu items in iOS.

## Changes from original project

- Deleted the categories `UIImage+REFrostedViewController` and `UIView+REFrostedViewController`
- Changed the coding style to match the [NYT Objective-C style guide](https://github.com/NYTimes/objective-c-style-guide)
- Replaced logic in `tableView:didSelectRowAtIndexPath:` with a custom segue. This does require some configuration to work properly, but in my opnion, it is easier to understand.
- Compiled in hard-mode
- Moved most of the view configurations to the Storyboard.

iOS 7/8 style blurred view controller that appears on top of your view controller.

<img src="https://raw.githubusercontent.com/jkereako/REFrostedViewController/master/new-demo.gif" alt="REFrostedViewController Screenshot" width="320" height="568" />

## Requirements
* Xcode 6 or higher
* Apple LLVM compiler
* iOS 6.0 or higher
* ARC

## Demo

Build and run the `REFrostedViewControllerExample` project in Xcode to see `REFrostedViewController` in action.

## Installation

All you need to do is drop `REFrostedViewController` files into your project, and add `#include "REFrostedViewController.h"` to the top of classes that will use it.

## Storyboard Example

1. Create a subclass of `REFrostedViewController`. In this example we call it `DEMORootViewController`.
2. In the Storyboard designate the root view's owner as `DEMORootViewController`.
3. Make sure to `#import "REFrostedViewController.h"` in `DEMORootViewController.h`.
4. Add more view controllers to your Storyboard, and give them identifiers "menuController" and "contentController". Note that in the new XCode the identifier is called "Storyboard ID" and can be found in the Identity inspector.
5. Add a method `awakeFromNib` to `DEMORootViewController.m` with the following code:

```objective-c

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuController"];
}

```

## Customization

You can customize the following properties of `REFrostedViewController`:

``` objective-c
@property (strong, readonly, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (assign, readwrite, nonatomic) BOOL panGestureEnabled;
@property (assign, readwrite, nonatomic) REFrostedViewControllerDirection direction;
@property (assign, readwrite, nonatomic) CGFloat backgroundFadeAmount;
@property (strong, readwrite, nonatomic) UIColor *blurTintColor; // Used only when live blur is off
@property (assign, readwrite, nonatomic) CGFloat blurRadius; // Used only when live blur is off
@property (assign, readwrite, nonatomic) CGFloat blurSaturationDeltaFactor; // Used only when live blur is off
@property (assign, readwrite, nonatomic) NSTimeInterval animationDuration;
@property (assign, readwrite, nonatomic) BOOL limitMenuViewSize;
@property (assign, readwrite, nonatomic) CGSize menuViewSize;
@property (assign, readwrite, nonatomic) BOOL liveBlur; // iOS 7 only
@property (assign, readwrite, nonatomic) REFrostedViewControllerLiveBackgroundStyle liveBlurBackgroundStyle; // iOS 7 only
```

## Credits

Inspired by a [Dribbble shot](http://dribbble.com/shots/1173945-Menu-Concept-1), author [Jackie Tran](http://dribbble.com/jackietrananh).

The blur algorithm that is used for static blur comes from WWDC 2013's session 208, "What's New in iOS User Interface Design".

## License

REFrostedViewController is available under the MIT license.

Copyright © 2013 Roman Efimov.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
