//
//  JMMessageInputController.m
//  MessagingUI
//
//  Created by Martin S. on 26.12.17.
//  Copyright © 2017 Juma. All rights reserved.
//

#import "JMMessageInputController.h"
#import "JMMessageInputBar.h"

@interface JMMessageInputBar (JMMessageInputBar_Private)
- (void)updateBackgroundIfNeeded;
@end

#pragma mark - JMMessageInputController

@interface JMMessageInputController () <UIGestureRecognizerDelegate>

// Keyboard
@property (weak  , nonatomic) NSLayoutConstraint *		inputBarConstraint;
@property (strong, nonatomic) IBOutlet JMMessageInputBar *inputBar;

// Keyboard animation
@property (assign, nonatomic) BOOL						keyboardIsPresent;
@property (assign, nonatomic) CGRect					keyboardStartFrame;
@property (assign, nonatomic) CGRect					keyboardTargetFrame;
@property (assign, nonatomic) NSTimeInterval 			keyboardTimeInterval;
@property (assign, nonatomic) UIViewAnimationCurve 		keyboardAnimationCurve;
@property (strong, nonatomic) UIViewPropertyAnimator *	keyboardAnimator;

// View Size Transition
@property (assign, nonatomic) BOOL 					isAnimatingViewSizeTransition;
@property (assign, nonatomic) UIViewAnimationCurve 	viewSizeTransitionCurve;
@property (assign, nonatomic) NSTimeInterval 		viewSizeTransitionDuration;

@end

@implementation JMMessageInputController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	return [self initWithInputBarClass:nil];
}

- (instancetype)initWithInputBarClass:(Class)inputBarClass {
	NSAssert(!inputBarClass || [inputBarClass isSubclassOfClass:[JMMessageInputBar class]], @"Wrong class supplied");
	
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		if (!inputBarClass) {
			inputBarClass = [JMMessageInputBar class];
		}
		
		JMMessageInputBar *inputBar = [[inputBarClass alloc] init];
		self.inputBar = inputBar;
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	return [super initWithCoder:aDecoder];
}

- (void)anchorInputBar:(UIView *)inputBar {
	inputBar.translatesAutoresizingMaskIntoConstraints = NO;
	
	self.inputBarConstraint = [[[self.view safeAreaLayoutGuide] bottomAnchor] constraintEqualToAnchor:inputBar.bottomAnchor];
	self.inputBarConstraint.active = YES;
	
	[[self.view leadingAnchor] constraintEqualToAnchor:inputBar.leadingAnchor].active = YES;
	[[self.view trailingAnchor] constraintEqualToAnchor:inputBar.trailingAnchor].active = YES;
	
	// Workaround if the view has no intrinsic height
	if (inputBar.intrinsicContentSize.height == UIViewNoIntrinsicMetric) {
		[[inputBar heightAnchor] constraintEqualToConstant:44.0f].active = YES;
	}
}

#pragma mark -

- (void)viewDidLoad {
	[super viewDidLoad];
	
	NSAssert(self.inputBar, @"If you used a storyboard, please make sure to connect the outlet of your bar");
	if (!self.inputBar.superview) {
		[self.view addSubview:self.inputBar];
	}
	[self anchorInputBar:self.inputBar];
	
	// The gesture recognizer is used for dismissing
	UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
	[recognizer setDelegate:self];
	[recognizer setRequiresExclusiveTouchType:NO];
	[self.view addGestureRecognizer:recognizer];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self.inputBar updateBackgroundIfNeeded];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

#pragma mark - Keyboard Notifications

- (void)keyboardWillShow:(NSNotification *)notification {

	self.keyboardIsPresent = YES;
	self.keyboardTimeInterval = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
	self.keyboardAnimationCurve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
	
	self.keyboardTargetFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
	self.keyboardTargetFrame = [self.view.window convertRect:self.keyboardTargetFrame fromWindow:nil];
	self.keyboardTargetFrame = [self.view convertRect:self.keyboardTargetFrame fromView:nil];

	self.keyboardStartFrame = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
	self.keyboardStartFrame = [self.view.window convertRect:self.keyboardStartFrame fromWindow:nil];
	self.keyboardStartFrame = [self.view convertRect:self.keyboardStartFrame fromView:nil];

	if (self.isAnimatingViewSizeTransition) {
		[self adjustToolbarToKeyboardDuration:self.viewSizeTransitionDuration curve:self.viewSizeTransitionCurve keyboardIsShowing:YES];
	} else {
		if (self.keyboardTimeInterval == 0) {
			[self adjustToolbarToKeyboard];
			[self.view layoutIfNeeded];
		} else {
			[self adjustToolbarToKeyboardDuration:self.keyboardTimeInterval curve:self.keyboardAnimationCurve keyboardIsShowing:YES];
		}
	}
}
- (void)keyboardWillHide:(NSNotification *)notification {
	NSTimeInterval keyboardTimeInterval = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
	NSUInteger keyboardAnimationCurve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];

	if (!self.keyboardAnimator && !self.isAnimatingViewSizeTransition) {
		[self adjustToolbarToKeyboardDuration:keyboardTimeInterval curve:keyboardAnimationCurve keyboardIsShowing:NO];
	}
}

- (void)keyboardDidHide:(NSNotification *)notification {
	self.keyboardIsPresent = NO;
	self.keyboardTimeInterval = 0;
	self.keyboardAnimationCurve = 0;
	self.keyboardTargetFrame = CGRectZero;
}

- (void)keyboardDidShow:(NSNotification *)notification {
	// Nop
}

#pragma mark - Toolbar placement

- (void)adjustToolbarToKeyboardDuration:(NSTimeInterval)duration curve:(UIViewAnimationCurve)curve keyboardIsShowing:(BOOL)keyboardIsShowing {

	// Move the view
	if (keyboardIsShowing) {
		[self adjustToolbarToKeyboard];
	} else {
		[self adjustToolbarToSafeAnchor];
	}
	
	[self.inputBar updateBackgroundIfNeeded];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:duration];
	[UIView setAnimationCurve:curve];
	[UIView setAnimationBeginsFromCurrentState:YES];

	// The keyboard starts at the bottom,
	// however the input bar started at the safe area so we use some handwaving math
	[UIView setAnimationDelay:0.01];
	[self.view layoutIfNeeded];
	[UIView commitAnimations];
}

- (void)adjustToolbarToKeyboard {
	CGFloat edgeDistance = self.view.bounds.size.height -
	self.view.safeAreaInsets.bottom -
	self.keyboardTargetFrame.origin.y;
		
	[self.inputBarConstraint setConstant:edgeDistance];
	[self.inputBar invalidateIntrinsicContentSize];
}

- (void)adjustToolbarToSafeAnchor {
	[self.inputBarConstraint setConstant:0];
	[self.inputBar invalidateIntrinsicContentSize];
}

#pragma mark - Device Rotation

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
	[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
	
	[coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
		[self setIsAnimatingViewSizeTransition:YES];
		[self setViewSizeTransitionDuration:[context transitionDuration]];
		[self setViewSizeTransitionCurve:[context completionCurve]];
	} completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
		[self setIsAnimatingViewSizeTransition:NO];
	}];
}

#pragma mark - <UIGestureRecognizerDelegate>

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
	if(!self.keyboardIsPresent) {
		return NO;
	}
	
	// Only move the keyboard out if touch did began outside of the input area
	return [self fractionOfTouchInInput:gestureRecognizer] < 0;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	return YES;
}

- (void)didPan:(UIGestureRecognizer *)recognizer {
	
	if (!self.keyboardIsPresent) {
		return;
	}
	
	CGFloat fractionCompleted = MIN([self fractionOfTouchInInput:recognizer], 1.0);
	
	BOOL didEnterInputAccessoryView =  fractionCompleted > 0;
	if (!self.keyboardAnimator && didEnterInputAccessoryView) {
		
		// Since the edit toolbar will not be moved as much as the keyboard (because the toolbar is attached to the safeAreaLayoutGuide),
		// we calculate the relative duration so that both keyboard and toolbar seem
		// to move at the same pace.
		// However this currently only works for linear timing curves. For other curves, we would have to
		// solve the bezier curve for x where y = editToolbarDistance / keyboardDistance
		CGFloat duration = self.keyboardTimeInterval;
		CGFloat keyboardDistance = self.keyboardStartFrame.origin.y - self.keyboardTargetFrame.origin.y;
		CGFloat editToolbarDistance = self.inputBarConstraint.constant;

		CGFloat relativeDuration =  editToolbarDistance / keyboardDistance;
		
		
		self.keyboardAnimator = [[UIViewPropertyAnimator alloc] initWithDuration:duration curve:UIViewAnimationCurveLinear animations:^{
			[self.view endEditing:YES];
		}];
		
		__weak JMMessageInputController *wself = self;
		[self.keyboardAnimator addAnimations:^{
			[UIView animateKeyframesWithDuration:duration delay:0.0f options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
				
				[UIView addKeyframeWithRelativeStartTime:0 relativeDuration:relativeDuration animations:^{
					wself.inputBarConstraint.constant = 0;
					[wself.view layoutIfNeeded];
				}];
				
			} completion:nil];

		}];
		[self.keyboardAnimator addCompletion:^(UIViewAnimatingPosition finalPosition) {
			wself.keyboardAnimator = nil;
			[wself.inputBar updateBackgroundIfNeeded];
		}];
		
		self.keyboardAnimator.userInteractionEnabled = YES;
		[self.keyboardAnimator pauseAnimation];
	}

	if (self.keyboardAnimator) {
		[self.keyboardAnimator setFractionComplete: fractionCompleted];
	}
	
	if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {

		// We slow down the animation depending on our current progress
		[self.keyboardAnimator continueAnimationWithTimingParameters:nil
													  durationFactor:MAX(1, self.keyboardAnimator.fractionComplete * 2)];
	}
}

- (CGFloat)fractionOfTouchInInput:(UIGestureRecognizer *)recognizer {
	CGFloat inputHeight = self.keyboardTargetFrame.size.height;
	CGFloat yLocationInWindow = [recognizer locationInView:self.view.window].y;
	CGFloat yInputOrigin = self.keyboardTargetFrame.origin.y - self.inputBar.frame.size.height;
	CGFloat ylocationInInput = yLocationInWindow - yInputOrigin;
	return  ylocationInInput / inputHeight;
}

#pragma mark - Embedding

- (void)embedViewControllerView:(UIViewController *)viewController {
	[super embedViewControllerView:viewController];
	
	[self.view sendSubviewToBack:viewController.view];
	
	if(@available(iOS 11.0, *)) {
		viewController.additionalSafeAreaInsets = UIEdgeInsetsMake(0, 0, self.inputBar.frame.size.height, 0);
	}
}

@end
