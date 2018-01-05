//
//  UIView+Embedding.m
//  ContainerViewControllers
//
//  Created by Martin S. on 13/02/2017.
//  Copyright © 2017 juma. All rights reserved.
//

#import <JMContainerControllers/UIView+Embedding.h>

@implementation UIView (Embedding)

- (void)embedView:(UIView *)view {
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addSubview:view];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
}

@end
