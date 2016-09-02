//
//  AppDelegate.h
//  CollaborativeNote
//
//  Created by Jeeva Prakash on 19/01/2016.
//  Copyright © 2016 Jeeva Prakash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

// Instance of window
@property (strong, nonatomic) UIWindow *window;

// Instance of multipeer connectivity manager class
@property (nonatomic, strong) ConnectionManager *connectionManager;

@end

