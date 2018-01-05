#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "JMContainerViewController.h"
#import "JMEmbedSegue.h"
#import "JMSegueTrigger.h"
#import "UIView+Embedding.h"
#import "JMContainerHeaderView.h"
#import "JMDocumentViewController.h"
#import "JMHairlineView.h"
#import "JMHeaderLabel.h"
#import "JMStackContainerView.h"
#import "JMStackContainerViewController.h"
#import "JMStackContainer_Internal.h"

FOUNDATION_EXPORT double JMContainerControllersVersionNumber;
FOUNDATION_EXPORT const unsigned char JMContainerControllersVersionString[];

