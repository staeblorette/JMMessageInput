//
//  JMHeaderLabel.m
//  rate
//
//  Created by Martin S. on 07/02/2017.
//  Copyright © 2017 juma. All rights reserved.
//

#import "JMHeaderLabel.h"

@implementation JMHeaderLabel

- (void)setHeaderFont:(UIFont *)headerFont {
    _headerFont = headerFont;
    [self setFont:headerFont];
}

- (void)setHeaderTextColor:(UIColor *)headerColor {
    _headerTextColor = headerColor;
    [self setTextColor:headerColor];
}

@end

@implementation JMSubHeaderLabel

- (void)setHeaderFont:(UIFont *)headerFont {
	_headerFont = headerFont;
	[self setFont:headerFont];
}

- (void)setHeaderTextColor:(UIColor *)headerColor {
	_headerTextColor = headerColor;
	[self setTextColor:headerColor];
}


@end
