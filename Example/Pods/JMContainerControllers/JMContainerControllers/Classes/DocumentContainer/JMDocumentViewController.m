//
//  JMContainerViewController.m
//  ContainerViewControllers
//
//  Created by Martin S. on 21/02/2017.
//  Copyright © 2017 juma. All rights reserved.
//

#import <JMContainerControllers/JMDocumentViewController.h>
#import <JMContainerControllers/JMContainerHeaderView.h>
#import <JMContainerControllers/JMSegueTrigger.h>

@interface JMDocumentViewController () <JMContentContainer>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeightConstraint;
@property (nonatomic, weak) IBOutlet JMContainerHeaderView *headerView;
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@end

@implementation JMDocumentViewController

- (void)embedViewControllerView:(UIViewController *)viewController
{
	_viewController = viewController;
	
	[self loadViewIfNeeded];
	
	UIView *view = viewController.view;
	UIView *headerView = self.headerView;
	
	view.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:view];
	
	NSLayoutAnchor *headerAnchor = headerView.bottomAnchor;
	UIView *anchor = self.view;
	
	[view.leadingAnchor constraintEqualToAnchor:anchor.leadingAnchor].active = YES;
	[view.trailingAnchor constraintEqualToAnchor:anchor.trailingAnchor].active = YES;
	[view.topAnchor constraintEqualToAnchor:headerAnchor].active = YES;
	[view.bottomAnchor constraintEqualToAnchor:anchor.bottomAnchor].active = YES;
	[self updateHeader];
}

- (void)updateHeader
{
	self.headerView.title = self.viewController.navigationItem.title;
	self.headerView.subtitle = self.viewController.navigationItem.prompt;
}

- (CGSize)preferredContentSizeForExpectedContainerSize:(CGSize)size
{
	CGSize preferredChildSize = CGSizeZero;
	if ([self.viewController respondsToSelector:@selector(preferredContentSizeForExpectedContainerSize:)]) {
		preferredChildSize = [self.viewController preferredContentSizeForExpectedContainerSize:size];
	}
	if (CGSizeEqualToSize(CGSizeZero,preferredChildSize)) {
		return CGSizeZero;
	}
	preferredChildSize.height += self.headerView.height;
	return preferredChildSize;
}

@end
