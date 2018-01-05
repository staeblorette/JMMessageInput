//
//  JMContainerHeaderView.h
//  ContainerViewControllers
//
//  Created by Martin S. on 07/02/2017.
//  Copyright © 2017 juma. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface JMContainerHeaderView : UIView

@property (nonatomic, strong) IBInspectable NSString *title;

@property (nonatomic, strong) IBInspectable NSString *subtitle;

@property (nonatomic, assign) UI_APPEARANCE_SELECTOR CGFloat height;

@end
