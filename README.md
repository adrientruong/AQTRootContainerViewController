# AQTRootContainerViewController
A container view controller to animate swapping root view controllers

## How to Install
Add the following to your Podfile
```
pod 'AQTRootContainerViewController'
```

## Usage
```objective-c
  //initialization
  UIViewController *rootViewController = [[UIViewController alloc] init];
  AQTRootContainerViewController *rootContainerViewController = [[AQTRootContainerViewController alloc] init];
  rootContainerViewController.rootViewController = rootViewController;
  
  //when you want to swap root view controllers with animation
  UIViewController *newRootViewController = [[UIViewController alloc] init];
  id<UIViewControllerAnimatedTransitioning> animator = ...;
  [rootContainerViewController setRootViewController:newRootViewController withAnimator:animator];
```
  
