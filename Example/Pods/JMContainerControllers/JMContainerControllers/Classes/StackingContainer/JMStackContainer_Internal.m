//
//  JMStackContainer_Internal.m
//  ContainerViewControllers
//
//  Created by Martin S. on 05/02/2017.
//  Copyright © 2017 juma. All rights reserved.
//

#import <JMContainerControllers/JMStackContainer_Internal.h>

@interface JMStackContainer_Internal ()
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@end

@implementation JMStackContainer_Internal

- (void)addStackedView:(UIView *)stackedView
{
    [[self stackView] addArrangedSubview:stackedView];
}

@end
