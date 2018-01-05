//
//  JMEmbedSegue.m
//  ContainerViewControllers
//
//  Created by Martin S. on 23/02/2017.
//  Copyright © 2017 juma. All rights reserved.
//

#import <JMContainerControllers/JMEmbedSegue.h>
#import <JMContainerControllers/JMSegueTrigger.h>
#import <JMContainerControllers/JMContainerViewController.h>
#import <JMContainerControllers/JMDocumentViewController.h>

@implementation JMEmbedSegue

- (void)perform {
    JMContainerViewController *container = self.sourceViewController;
    [container addViewController:self.destinationViewController];
}

@end


@implementation JMEmbedInDocumentSegue

- (void)perform  {
    JMContainerViewController *container = self.sourceViewController;
    JMDocumentViewController *embededContainer = [[JMDocumentViewController alloc] initWithNibName:@"JMDocumentViewController" bundle:[NSBundle bundleForClass:[self class]]];
    [embededContainer addViewController:self.destinationViewController];
    [container addViewController:embededContainer];
}

@end
