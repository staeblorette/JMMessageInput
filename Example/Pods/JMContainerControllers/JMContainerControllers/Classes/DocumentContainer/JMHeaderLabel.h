//
//  JMHeaderLabel.h
//  rate
//
//  Created by Martin S. on 07/02/2017.
//  Copyright © 2017 juma. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface JMHeaderLabel : UILabel

@property (nonatomic, strong) UI_APPEARANCE_SELECTOR UIFont  *headerFont;

@property (nonatomic, strong) UI_APPEARANCE_SELECTOR UIColor *headerTextColor;

@end

IB_DESIGNABLE
@interface JMSubHeaderLabel : UILabel

@property (nonatomic, strong) UI_APPEARANCE_SELECTOR UIFont  *headerFont;

@property (nonatomic, strong) UI_APPEARANCE_SELECTOR UIColor *headerTextColor;

@end
