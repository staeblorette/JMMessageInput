# JMContainerControllers

[![CI Status](http://img.shields.io/travis/staeblorette/JMContainerControllers.svg?style=flat)](https://travis-ci.org/staeblorette/JMContainerControllers)
[![Version](https://img.shields.io/cocoapods/v/JMContainerControllers.svg?style=flat)](http://cocoapods.org/pods/JMContainerControllers)
[![License](https://img.shields.io/cocoapods/l/JMContainerControllers.svg?style=flat)](http://cocoapods.org/pods/JMContainerControllers)
[![Platform](https://img.shields.io/cocoapods/p/JMContainerControllers.svg?style=flat)](http://cocoapods.org/pods/JMContainerControllers)

## Overview

ContainerViewControllers help you set up fast and easy ViewController hierachies.
It can be cumbersome to add viewControllers. The Interface builder is not your friend. Also setting up the viewControllers programatically is also cumbersome.
Issues are also common with sizing and re-layouting.
This project offers some useful base viewControllers which extend the apple provided
container controllers nicely:
* JMContainerViewController offers a simple base class to embed viewControllers.
* JMStackContainerViewController allows you to stack multiple child containers vertically.
* JMDocumentViewController adds a title bar above your content.

Also you can now establish viewController relationships directly with segues by using
'JMEmbedSegue' or 'JMEmbedInDocumetSegue'. There are some manual steps neccessary, however I plan on implementing a interface builder rule to do these steps automatic.

### Default Container Controller

![Alt text](/../screenshots/Screenshots/SegueSetupDefault.png?raw=true)
The default container simply adds the view to the container's subviews.

### StackContainer && Document Containeradds

![Alt text](/../screenshots/Screenshots/StackContainer.png?raw=true)
This stack container combines normal ViewControllers and ViewControllers embeded in Document Containers.

![Alt text](/../screenshots/Screenshots/SegueSetupStack.png?raw=true)
The setup of the storyboard. The viewControllers that have been embeded in Document Controllers use a
JMEmbedInDocumentSegue while the normal ViewControllers use a JMEmbedSegue.


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

JMContainerControllers is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'JMContainerControllers'
```

## Help

### Setup DocumentViewController

The document view controller container adds a header view above the contents of the child controller.
The child controller uses a navigation item to add a title and subtitle to the header view.
The header view might be modified with appearance selectors (including header size, label font, sub-label text color, hairline view color...)

### Setup StackContainerViewController

The StackContainerViewController manages its child controllers via a UIStackView. The individual size of a child view can be controlled with

```
- (CGSize)preferredContentSizeForExpectedContainerSize:(CGSize)size
```

If setting up the hierachy with a storyboard, set the view controller's class to 'JMStackContainerView' and also set the view's class to 'JMStackContainerView'. The last step has historical reasons and will be changed in future releases.

If setting up the hierachy programatically, you have to use '-setView:' before '-view' is invoked, or override the '-loadView' method and supplement the JMStackContainerView yourself. In future releases this will also be changed.

### Setup Segue

Interface builder does yet not allow you to perform segues that are executed automatically on viewDidLoad.
The default interface builder container segue between a view and a viewController however does this. This is done via SegueTemplates that can be triggered on viewDidLoad. However segue triggers are currently private API, so we only use these for Debugging perposes. When we want to use segues to establish the container relationship between different view controllers, we have to establish the trigger ourself.

Here is how it works:
* Add a 'JMEmbedSegue' or 'JMEmbedInDocumentSegue' segue between your container view controller and your child controller.
* Add a custom object of type 'JMSegueTrigger' and set the identifier property to the respective segue's identifer.
* Add the segue trigger to the outlet collection of segue triggers.

![Alt text](/../screenshots/Screenshots/Interface%20actions.png?raw=true)


## Author

Martin Stähler, martin.staehler@gmail.com

## License

JMContainerControllers is available under the MIT license. See the LICENSE file for more info.
