//
//  JMContainerViewController.h
//  ContainerViewControllers
//
//  Created by Martin S. on 23/02/2017.
//  Copyright © 2017 juma. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JMContentContainer <UIContentContainer>

@optional
- (CGSize)preferredContentSizeForExpectedContainerSize:(CGSize)size;

@end

@interface UIViewController (JMContentContainerAdditions) <JMContentContainer>

@end

@interface JMContainerViewController : UIViewController

- (void)addViewController:(UIViewController *)viewController;


/**
 To be overwritten by subclasses.
 Allows you to customize the view embedding and layouting
 
 @param viewController The viewController whos view requires embedding.
 */
- (void)embedViewControllerView:(UIViewController *)viewController;

@end
