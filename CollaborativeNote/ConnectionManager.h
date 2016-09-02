//
//  ConnectionManager.h
//  CollaborativeNote
//
//  Created by Jeeva Prakash on 20/01/2016.
//  Copyright © 2016 Jeeva Prakash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

// Connection Manager for establishing Multipeer connectivity
@interface ConnectionManager : NSObject <MCSessionDelegate>

//Peer device ID instance
@property (nonatomic, strong) MCPeerID *peerID;

// Device display name for other connecting users
@property (nonatomic, strong) NSString *defaultDeviceName;

// Multipeer connectivity session instance
@property (nonatomic, strong) MCSession *session;

// Multipeer connectivity default browser insatnce
@property (nonatomic, strong) MCBrowserViewController *browser;

// Multipeer connectivity advertiser instance
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;

// setup method for multipeer connectivity with device name
-(void)setupMCBWithDisplayName:(NSString *)displayName;

// Setup multipeer device default browser view controller
-(void)setupMCBBrowser;

// Set device to advertise 
-(void)deviceAvertising:(bool)isRequired;
@end
