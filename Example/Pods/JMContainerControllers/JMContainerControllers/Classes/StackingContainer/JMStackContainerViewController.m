//
//  JMStackContainerViewController.m
//  ContainerViewControllers
//
//  Created by Martin S. on 20/02/2017.
//  Copyright © 2017 juma. All rights reserved.
//

#import <JMContainerControllers/JMStackContainerViewController.h>
#import <JMContainerControllers/JMSegueTrigger.h>
#import <JMContainerControllers/JMStackContainerView.h>


@interface JMStackContainerViewController ()
@property (nonatomic, strong) NSMutableArray <NSLayoutConstraint *> *constraintSpecifiers;
@end

@implementation JMStackContainerViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.constraintSpecifiers = [NSMutableArray array];
}

- (void)embedViewControllerView:(UIViewController *)viewController {
	[self loadViewIfNeeded];
	
	JMStackContainerView *container = (JMStackContainerView *)[self view];
	
	NSAssert([container isKindOfClass:[JMStackContainerView class]], @"Set the storyboard view class to JMStackContainer");
	
	[container addChildView:[viewController view]];
	
	UIView *view = [viewController view];
	view.translatesAutoresizingMaskIntoConstraints = NO;
	[view.widthAnchor constraintEqualToAnchor:container.widthAnchor multiplier:1.0f].active = YES;
	NSLayoutConstraint *constraint = [view.heightAnchor constraintEqualToConstant:200];
	constraint.active = YES;
	[self.constraintSpecifiers addObject:constraint];
}


- (CGSize)sizeForChildContentContainer:(id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
	CGSize size = [super sizeForChildContentContainer:container withParentContainerSize:parentSize];
	// FIXME: cast
	NSUInteger constraintIndex = [[self childViewControllers] indexOfObject:(UIViewController *)container];
	if (constraintIndex == NSNotFound) {
		return size;
	}
	
	[self constraintSpecifiers][constraintIndex].constant = size.height;
	
	return size;
}

@end
