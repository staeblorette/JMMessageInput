//
//  JMMessageInputBar.m
//  MessagingUI
//
//  Created by Martin S. on 28.12.17.
//  Copyright © 2017 Juma. All rights reserved.
//

#import <JMMessageInput/JMMessageInputBar.h>

#pragma mark -

NSNotificationName const JMMessageInputBarDidResizeNotification = @"JMMessageInputBarDidResizeNotification";
NSString *const JMMessageInputBarSizeUserInfoKey = @"JMMessageInputBarSizeUserInfoKey";

static CGFloat const JMMessageInputFieldHeight = 40;
static CGFloat const JMMessageInputFieldHorizonalPadding = 6.0f;
static CGFloat const JMMessageInputFieldVerticalPadding = 8.0f;

static CGFloat const JMMessageInputBarHorizontalMargin = 8.0f;
static CGFloat const JMMessageInputBarVerticalMargin = 6.0f;

#pragma mark -

@interface _JMTextViewContainer : UIView
@end

@implementation _JMTextViewContainer

- (CGSize)intrinsicContentSize {
	return CGSizeMake(UIViewNoIntrinsicMetric, JMMessageInputFieldHeight);
}

- (NSLayoutYAxisAnchor *)lastBaselineAnchor {
	return self.layoutMarginsGuide.bottomAnchor;
}

@end

@interface JMMessageInputBar ()

@property (strong, nonatomic, readwrite) IBOutlet UITextView *	textView;
@property (strong, nonatomic, readwrite) IBOutlet UIButton *	rightAccessoryButton;
@property (strong, nonatomic, readwrite) IBOutlet UIButton *	leftAccessoryButton;
@property (strong, nonatomic, readwrite) IBOutlet UIButton *	sendButton;
@property (strong, nonatomic, readwrite) IBOutlet UILabel *		placeholderLabel;

@property (assign, nonatomic, readwrite) JMMessageInputBarStyle style;

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIView *textViewContainer;
@property (assign, nonatomic) CGFloat intrinsicContentHeight;

@property (assign, nonatomic) BOOL didSetup;
@property (assign, nonatomic) BOOL didClearPlaceholder;

@property (strong, nonatomic) NSLayoutConstraint *dynamicSizeConstraint;
@property (assign, nonatomic) BOOL hasDynamicSize;

@end

@implementation JMMessageInputBar

- (instancetype)initWithFrame:(CGRect)frame {
	return [self initWithStyle:JMMessageInputBarStyleDefault];
}

- (instancetype)initWithStyle:(JMMessageInputBarStyle)style {
	#pragma unused(style)
	
	self = [super initWithFrame:CGRectZero];
	if (self) {
		_horizontalStackView = [[UIStackView alloc] initWithFrame:CGRectZero];
		_horizontalStackView.axis = UILayoutConstraintAxisHorizontal;
		_horizontalStackView.spacing = JMMessageInputFieldVerticalPadding;
		[self addSubview:_horizontalStackView];

		_horizontalStackView.translatesAutoresizingMaskIntoConstraints = NO;
		_horizontalStackView.alignment = UIStackViewAlignmentLastBaseline;

		[self.readableContentGuide.leadingAnchor constraintEqualToAnchor:_horizontalStackView.leadingAnchor].active = YES;
		[self.readableContentGuide.trailingAnchor constraintEqualToAnchor:_horizontalStackView.trailingAnchor].active = YES;
		[self.layoutMarginsGuide.topAnchor constraintEqualToAnchor:_horizontalStackView.topAnchor].active = YES;
		[self.layoutMarginsGuide.bottomAnchor constraintEqualToAnchor:_horizontalStackView.bottomAnchor].active = YES;
		
		// The textView's baseline does behave strangely after resize, hence we supply our own baseline view.
		_textViewContainer = [[_JMTextViewContainer alloc] init];
		[_horizontalStackView addArrangedSubview:_textViewContainer];
		[_textViewContainer setContentHuggingPriority:249 forAxis:UILayoutConstraintAxisHorizontal];
		[_textViewContainer setTranslatesAutoresizingMaskIntoConstraints:NO];

		_textView = [[UITextView alloc] init];
		_textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
		_textView.translatesAutoresizingMaskIntoConstraints = NO;
		[_textView setContentHuggingPriority:249 forAxis:UILayoutConstraintAxisHorizontal];
		_textView.scrollEnabled = NO;

		[_textViewContainer addSubview:_textView];
		[_textViewContainer.leadingAnchor constraintEqualToAnchor:_textView.leadingAnchor].active = YES;
		[_textViewContainer.trailingAnchor constraintEqualToAnchor:_textView.trailingAnchor].active = YES;
		[_textViewContainer.bottomAnchor constraintEqualToAnchor:_textView.bottomAnchor].active = YES;
		[_textViewContainer.topAnchor constraintEqualToAnchor:_textView.topAnchor].active = YES;

		[_textView invalidateIntrinsicContentSize];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	return [super initWithCoder:aDecoder];
}

#pragma mark -

- (UIButton *)leftAccessoryButton {

	if (!self.horizontalStackView) {
		return nil;
	}

	if (!_leftAccessoryButton) {
		_leftAccessoryButton = [UIButton buttonWithType:UIButtonTypeSystem];
		[_leftAccessoryButton setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
		[self.horizontalStackView insertArrangedSubview:_leftAccessoryButton atIndex:0];
	}
	return _leftAccessoryButton;
}

- (UIButton *)rightAccessoryButton {

	if (!self.horizontalStackView) {
		return nil;
	}
	
	if (!_rightAccessoryButton) {
		_rightAccessoryButton = [UIButton buttonWithType:UIButtonTypeSystem];
		[_rightAccessoryButton setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
		[self.horizontalStackView addArrangedSubview:_rightAccessoryButton];
	}
	return _rightAccessoryButton;
}

- (UIButton *)sendButton {

	if (!self.horizontalStackView) {
		return nil;
	}
	
	if (!_sendButton) {
		_sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
		_sendButton.translatesAutoresizingMaskIntoConstraints = NO;
		
		// TODO: <Martin S., 12/03/18> Configure Accessibility
		
		[self.textViewContainer addSubview:_sendButton];
		[self.textViewContainer.layoutMarginsGuide.trailingAnchor constraintEqualToAnchor:_sendButton.trailingAnchor].active = YES;
		[self.textViewContainer.lastBaselineAnchor constraintEqualToAnchor:_sendButton.lastBaselineAnchor].active = YES;

		// Reset the content insets to accomondate horizonal spacing
		[self layoutIfNeeded];
		self.textView.textContainerInset = [self inputFieldInsets];
	}
	return _sendButton;
}

#pragma mark - Background

- (BOOL)isAtBottomOfSuperView {
	UIView *superview = self.superview;
	CGFloat distanceToBottom = 0;
	if(@available(iOS 11.0, *)) {
		distanceToBottom = self.superview.safeAreaInsets.bottom;
	}
	CGRect frame= self.frame;
	return frame.origin.y + frame.size.height >= superview.frame.size.height - distanceToBottom;
}

- (void)updateBackgroundIfNeeded {
	CGFloat distanceToBottom = 0;
	if(@available(iOS 11.0, *)) {
		distanceToBottom = self.superview.safeAreaInsets.bottom;
	}
 	CGRect frame = self.frame;
	
	if ([self isAtBottomOfSuperView]) {
		self.backgroundView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height + distanceToBottom);
	} else {
		self.backgroundView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
	}
}

#pragma mark - Layouting

- (void)layoutSubviews {

	[self invalidateIntrinsicContentSize];

	[super layoutSubviews];
	
	if (!self.didSetup) {
		self.didSetup = YES;
	
		// The background view will extend outside of the view's bounds.
		self.clipsToBounds = NO;
		
		NSAssert(self.textView, @"TextView has not been set. Please attach it in interface builder");
		self.textView.scrollEnabled = NO;
		self.textView.textContainerInset = [self inputFieldInsets];
		self.textView.showsVerticalScrollIndicator = NO;
		self.textViewContainer.layoutMargins = [self inputFieldContainerInsets];
		self.dynamicSizeConstraint = [[self.textView heightAnchor] constraintEqualToConstant:self.textView.frame.size.height];
		self.dynamicSizeConstraint.active = NO;
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeContentOfTextView) name:UITextViewTextDidChangeNotification object:self.textView];

		UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
		UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
		[self insertSubview:effectView atIndex:0];
		self.backgroundView = effectView;
	}

	[self updateBackgroundIfNeeded];
	
	[self layoutTextContainerIfNeeded];
}

- (UIEdgeInsets)layoutMargins {
	return UIEdgeInsetsMake(JMMessageInputBarVerticalMargin, JMMessageInputBarHorizontalMargin, JMMessageInputBarVerticalMargin, JMMessageInputBarHorizontalMargin);
}

- (CGSize)intrinsicContentSize {
	CGFloat expectedInputFieldHeight = [self expectedInputFieldHeight];
	
	if (expectedInputFieldHeight <= JMMessageInputFieldHeight) {
		expectedInputFieldHeight = JMMessageInputFieldHeight;
	}
	return CGSizeMake(UIViewNoIntrinsicMetric, expectedInputFieldHeight + self.layoutMargins.top + self.layoutMargins.bottom);
}

- (UIEdgeInsets)inputFieldInsets {
	CGFloat verticalInsets;
	CGFloat horizontalInsets;
	
	// Vertical
	if ([self expectedInputFieldHeight] < JMMessageInputFieldHeight) {
		verticalInsets = roundf((JMMessageInputFieldHeight - self.textView.font.lineHeight) / 2);
	} else {
		verticalInsets =  JMMessageInputFieldVerticalPadding;
	}
	
	// Horizontal
	if (_sendButton) {
		horizontalInsets = JMMessageInputFieldHorizonalPadding + _sendButton.frame.size.width;
	} else {
		horizontalInsets = JMMessageInputFieldHorizonalPadding;
	}
	
	return UIEdgeInsetsMake(verticalInsets, JMMessageInputFieldHorizonalPadding, verticalInsets, horizontalInsets);
}

- (UIEdgeInsets)inputFieldContainerInsets {
	UIEdgeInsets insets = [self inputFieldInsets];
	insets.bottom += self.textView.font.leading - self.textView.font.descender;
	return insets;
}

- (CGFloat)expectedInputFieldHeight {
	return self.textView.font.lineHeight;
}

#pragma mark -

- (void)didChangeContentOfTextView {
	[self layoutTextContainerIfNeeded];
}

- (void)layoutTextContainerIfNeeded {
	// We have to force the layout to use the new height
	[self.textView.superview layoutIfNeeded];

	CGSize oldSize = self.textView.frame.size;
	CGSize expectedSize = [JMMessageInputBar sizeOfText:self.textView.attributedText inTextView:self.textView];
	CGSize replacementSize = [self replacementSizeForSize:expectedSize oldSize:oldSize];
	BOOL isDynamic = replacementSize.height < expectedSize.height;
	
	if (!isDynamic) {
		[self didResizeToSize:expectedSize oldSize:oldSize];
	}

	self.hasDynamicSize = isDynamic;
	self.textView.scrollEnabled = isDynamic;

	self.dynamicSizeConstraint.constant = replacementSize.height;
	self.dynamicSizeConstraint.active = isDynamic;

	[[self textView] invalidateIntrinsicContentSize];
}


#pragma mark - <JMMessageInputBarDelegate>

- (CGSize)replacementSizeForSize:(CGSize)size oldSize:(CGSize)oldSize {
	if ([[self delegate] respondsToSelector:@selector(inputBar:replacmentSizeForSize:oldSize:)]) {
		return [[self delegate] inputBar:self replacmentSizeForSize:size oldSize:oldSize];
	}
	return size;
}

- (void)didResizeToSize:(CGSize)size oldSize:(CGSize)oldSize{
	if ([[self delegate] respondsToSelector:@selector(inputBar:didResizeToSize:oldSize:)]) {
		return [[self delegate] inputBar:self didResizeToSize:size oldSize:oldSize];
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:JMMessageInputBarDidResizeNotification object:self userInfo:@{JMMessageInputBarSizeUserInfoKey:@(size)}];
}

#pragma mark - Cleanup

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -

/**
 A helper function to get the "correct" size of the textView. It seems that the text view's own layout manager
 is not up to date on line breaks, and will only have the correct height after the next input.
 All attempts to force the layouting were in vain.
 However I'm not sure if I used NSLayoutManager/TextContainer/TextStorage correctly. The delegates of the respective
 objects didn't help either. Therefore we use our own layout manager, and try - to the best of our abilites - to add the same
 properties as the original textView. This all seems very unpleasent and there is no gurantee that for certain cases this will
 work. However initial testing showed that this produced right results.
 
 @param attributedString A attributed string
 @param textView The text view whose layout should be emulated
 @return The total text container size
 */
+ (CGSize)sizeOfText:(NSAttributedString *)attributedString inTextView:(UITextView *)textView {
	NSTextStorage *textStorage = [[NSTextStorage alloc]
								  initWithAttributedString:attributedString];
	NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(UIEdgeInsetsInsetRect(textView.frame, textView.textContainerInset).size.width, FLT_MAX)];
	NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
	
	[layoutManager addTextContainer:textContainer];
	[textStorage addLayoutManager:layoutManager];
	
	[textContainer setLineFragmentPadding:textView.textContainer.lineFragmentPadding];
	[textContainer setLineBreakMode:textView.textContainer.lineBreakMode];
	(void) [layoutManager glyphRangeForTextContainer:textContainer];
	
	return [layoutManager usedRectForTextContainer:textContainer].size;
}

@end
