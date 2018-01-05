//
//  JMCommentInputController.h
//  MessagingUI
//
//  Created by Martin S. on 26.12.17.
//  Copyright © 2017 Juma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JMContainerControllers/JMContainerViewController.h>
#import <JMMessageInput/JMMessageInputBar.h>

NS_ASSUME_NONNULL_BEGIN

@class JMMessageInputBar;
@interface JMMessageInputController : JMContainerViewController

/* Use this initializer to make the Message controller use your custom bar class.
 Passing nil for input bar class will get you JMMessagesInputBar.
 The arguments must otherwise be subclasses of the JMMessagesInputBar classes.
 */
- (instancetype)initWithInputBarClass:(nullable Class)inputBarClass NS_DESIGNATED_INITIALIZER;

/* If you use a storyboard, you can also set up the input bar via outlet connection
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

@property (nonatomic, strong, readonly) JMMessageInputBar *inputBar;

@end

NS_ASSUME_NONNULL_END
