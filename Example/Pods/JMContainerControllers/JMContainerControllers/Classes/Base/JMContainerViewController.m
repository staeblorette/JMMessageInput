//
//  JMContainerViewController.m
//  rate
//
//  Created by Martin S. on 23/02/2017.
//  Copyright © 2017 juma. All rights reserved.
//

#import <JMContainerControllers/JMContainerViewController.h>
#import <JMContainerControllers/JMSegueTrigger.h>
#import <JMContainerControllers/UIView+Embedding.h>

#if DEBUG
#define  DebugContainerSegueTemplates() [self debugContainerSegueTemplates]
#else
#define  DebugContainerSegueTemplates()
#endif

@implementation UIViewController (JMContentContainerAdditions)
@end

@interface JMContainerViewController ()
@property (nonatomic, assign) BOOL initialLayoutPass;
@property (nonatomic, strong) IBOutletCollection(JMSegueTrigger) NSArray <JMSegueTrigger *> *segueTriggers;
@end

@implementation JMContainerViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	DebugContainerSegueTemplates();
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
	if (self.initialLayoutPass) {
		return;
	}
	
	self.initialLayoutPass = YES;
	for (JMSegueTrigger *trigger in self.segueTriggers) {
		
		NSAssert(trigger.segueIdentifier, @"Missing Segue Identifier");
		
		[self performSegueWithIdentifier:trigger.segueIdentifier sender:nil];
	}
}

- (void)addViewController:(UIViewController *)viewController {
	[self addChildViewController:viewController];
	
	[self embedViewControllerView:viewController];
	
	[self sizeForChildContentContainer:viewController withParentContainerSize:self.view.bounds.size];
	
	[viewController didMoveToParentViewController:self];
}

- (void)embedViewControllerView:(UIViewController *)viewController {
	[self loadViewIfNeeded];
	
	[self.view embedView:viewController.view];
}

- (CGSize)sizeForChildContentContainer:(id<JMContentContainer>)container withParentContainerSize:(CGSize)parentSize {
	CGSize preferredChildSize = CGSizeZero;
	if ([container respondsToSelector:@selector(preferredContentSizeForExpectedContainerSize:)]) {
		preferredChildSize = [container preferredContentSizeForExpectedContainerSize:parentSize];
	}
	if (CGSizeEqualToSize(CGSizeZero, preferredChildSize)) {
		return [super sizeForChildContentContainer:container withParentContainerSize:parentSize];
	}
	return preferredChildSize;
}

#pragma mark - Debugging

#if DEBUG
- (void)debugContainerSegueTemplates
{
	NSArray <NSString *> *segueTemplatesIdentifiers = [self valueForKeyPath:@"storyboardSegueTemplates.identifier"];
	NSArray <NSString *> *registersSegueTemplates = [self valueForKeyPath:@"segueTriggers.segueIdentifier"];
	for (NSString *identifier in segueTemplatesIdentifiers) {
		if (![registersSegueTemplates containsObject:identifier]) {
			NSLog(@"Failed to find connection between segue with identifier '%@' and storyboard segues. Please add a JMSegueTrigger object to your storyboard file and attach the trigger to the segue trigger outlet connection.	\n You can also add the build rule to automatically do this for you. ", identifier);
		}
	}
}
#endif

@end
