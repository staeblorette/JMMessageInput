//
//  JMStackContainer.m
//  ContainerViewControllers
//
//  Created by Martin S. on 05/02/2017.
//  Copyright © 2017 juma. All rights reserved.
//

#import <JMContainerControllers/JMStackContainerView.h>
#import <JMContainerControllers/JMStackContainer_Internal.h>
#import <JMContainerControllers/UIView+Embedding.h>

@interface JMStackContainerView ()
@property (nonatomic, weak) JMStackContainer_Internal *stackInternal;
@end

@implementation JMStackContainerView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ([self stackInternal]) {
        return;
    }
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    JMStackContainer_Internal *internalView = [[bundle loadNibNamed:@"JMStackContainer_Internal" owner:nil options:nil] firstObject];
    
    [self embedView:internalView];
    [self setStackInternal:internalView];
}

- (void)addChildView:(UIView *)view
{
    [[self stackInternal] addStackedView:view];
}


@end
