# JMMessageInput

[![CI Status](http://img.shields.io/travis/staeblorette/JMMessageInput.svg?style=flat)](https://travis-ci.org/staeblorette/JMMessageInput)
[![Version](https://img.shields.io/cocoapods/v/JMMessageInput.svg?style=flat)](http://cocoapods.org/pods/JMMessageInput)
[![License](https://img.shields.io/cocoapods/l/JMMessageInput.svg?style=flat)](http://cocoapods.org/pods/JMMessageInput)
[![Platform](https://img.shields.io/cocoapods/p/JMMessageInput.svg?style=flat)](http://cocoapods.org/pods/JMMessageInput)

Adds a messanger like input. You have all seen how this works.

![Alt text](/../screenshots/Screenshots/ExpandingInputBar.png?raw=true "Input bar resizes on long inputs")
![Alt text](/../screenshots/Screenshots/ExpandedKeyboardIPhoneX.png?raw=true "Bar can be configured in storyboard")
![Alt text](/../screenshots/Screenshots/CollapsedKeyboardIPhone8.png?raw=true)


## Features

* Input bar moves along keyboard
* Dynamic resizing of the input bar when text extends over a line
* Controll of resizing behaviour with delegates
* Supports Dynamic Type
* Manual keyboard dismissal with gesture
* Aligning input controlls to baseline
* Respects Safe Area guides
* Full control of visuals with storyboard or programatically

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

JMMessageInput is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'JMMessageInput'
```

The framework has a dependency on 'JMContainerControllers'

## Storyboard use

The ViewController will manage the layout of the bar. However due to problems of frameworks and IBDesignable, you have to attach trailing, leading and bottom contraint yourself, to avoid interface builder errors. Please make sure, however, to check the 'Remove at Buildtime' option. Same is for intrinsic content size. 

## Author

staeblorette, martin.staehler@gmail.com

## License

JMMessageInput is available under the MIT license. See the LICENSE file for more info.
