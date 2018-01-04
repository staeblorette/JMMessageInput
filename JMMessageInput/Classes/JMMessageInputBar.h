//
//  JMMessageInputBar.h
//  MessagingUI
//
//  Created by Martin S. on 28.12.17.
//  Copyright © 2017 Juma. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// Currently Input bar has only one style, but might be extended in the future.
// What "style" in this context means is also up for debate. 
typedef NS_ENUM(NSInteger, JMMessageInputBarStyle) {
	JMMessageInputBarStyleDefault,
	JMMessageInputBarStyleSendAlways,
};

@class JMMessageInputBar;
@protocol JMMessageInputBarDelegate <NSObject>

@optional
// Return a smaller size if you want to enable scrolling
- (CGSize)inputBar:(JMMessageInputBar *)bar replacmentSizeForSize:(CGSize)size oldSize:(CGSize)oldSize;

- (void)inputBar:(JMMessageInputBar *)bar didResizeToSize:(CGSize)size oldSize:(CGSize)oldSize;

@end

IB_DESIGNABLE

/**
A bar to enter your message. If you opt for storyboard, please make sure to connect all outlets in the .m file.
 If you decide for programmatic use of this class, you can modify the contents by accessing the relevant buttons,
 insert new views in the horizontal stack view and modify the textView.

 If the default intrinsic size does not suite your needs, you can either add height constraints or change the relevant
 metrics in the .m file.
 */
@interface JMMessageInputBar : UIView

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithStyle:(JMMessageInputBarStyle)style NS_DESIGNATED_INITIALIZER;

@property (assign, nonatomic, readonly) JMMessageInputBarStyle style;

// If you want to customize the input bar by simply adding additional views, you should add them to the stack view so they will be positioned appropriately. Beware that if you use Interface builder the stack view wont be used. In that case use the default view.
@property (strong, readonly, nonatomic, nullable) UIStackView *horizontalStackView;

// default is nil. Button will be created if necessary. Can be attached in Interface builder
@property (strong, readonly, nonatomic, nullable) UIButton *rightAccessoryButton;

 // default is nil. Button will be created if necessary. Can be attached in Interface builder
@property (strong, readonly, nonatomic, nullable) UIButton *leftAccessoryButton;

// default is nil. Button will be created if necessary. Can be attached in Interface builder
@property (strong, readonly, nonatomic, nullable) UIButton *sendButton;

@property (strong, readonly, nonatomic) UITextView *textView;

// Use the delegate to control resizing of the cell
@property (weak, nonatomic) id<JMMessageInputBarDelegate> delegate;

@end

// The bar broadcast relevant messages like many other UIKit objects
extern NSNotificationName const JMMessageInputBarDidResizeNotification;

extern NSString *const JMMessageInputBarSizeUserInfoKey; // CGSizeValue

NS_ASSUME_NONNULL_END
