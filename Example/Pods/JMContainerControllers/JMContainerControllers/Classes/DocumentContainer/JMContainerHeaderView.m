//
//  JMContainerHeaderView.m
//  ContainerViewControllers
//
//  Created by Martin S. on 07/02/2017.
//  Copyright © 2017 juma. All rights reserved.
//

#import <JMContainerControllers/JMContainerHeaderView.h>
#import <JMContainerControllers/UIView+Embedding.h>

@interface JMContainerHeaderView_Internal : UIView
@property (weak, nonatomic) IBOutlet UIStackView *accessoryContainer;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIStackView *textContainer;


@property (nonatomic, strong) IBInspectable NSString *title;

@property (nonatomic, strong) IBInspectable NSString *subtitle;

@end

@interface JMContainerHeaderView ()

@property (nonnull, strong) JMContainerHeaderView_Internal *internalView;

@end

@implementation JMContainerHeaderView

- (instancetype)init {
	self = [super init];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (void)commonInit
{
	_height = 100;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	if ([self internalView]) {
		return;
	}
	
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	JMContainerHeaderView_Internal *internalView = [[bundle loadNibNamed:@"JMContainerHeaderView_Internal" owner:nil options:nil] firstObject];
	
	[self embedView:internalView];
	[self setInternalView:internalView];
	
	[self setSubtitle:[self subtitle]];
	[self setTitle:[self title]];
	
	[super layoutSubviews];
}

- (CGSize)intrinsicContentSize {
	return CGSizeMake(UIViewNoIntrinsicMetric, [self height]);
}

- (void)setSubtitle:(NSString *)subtitle {
	_subtitle = subtitle;
	
	[[self internalView] setSubtitle:subtitle];
}

- (void)setTitle:(NSString *)title {
	_title = title;
	
	[[self internalView] setTitle:title];
}

- (void)setHeight:(CGFloat)height {
	_height = height;
	
	[self invalidateIntrinsicContentSize];
}

@end

@implementation JMContainerHeaderView_Internal

- (void)setSubtitle:(NSString *)subtitle {
	[[self subtitleLabel] setHidden:!subtitle];
	[[self subtitleLabel] setText:subtitle];
}

- (void)setTitle:(NSString *)title {
	[[self titleLabel] setHidden:!title];
	[[self titleLabel] setText:title];
}

@end
