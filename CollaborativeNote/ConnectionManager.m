//
//  ConnectionManager.m
//  CollaborativeNote
//
//  Created by Jeeva Prakash on 20/01/2016.
//  Copyright © 2016 Jeeva Prakash. All rights reserved.
//

#import "ConnectionManager.h"

// Connection Manager for establishing Multipeer connectivity
@interface ConnectionManager()

    // Gets service type for multi peer connectivity
    @property (strong) NSString *serviceType;

@end

// Connection Manager for establishing Multipeer connectivity
@implementation ConnectionManager
-(id)init{
    self =[super init];
    if(self){
        _session = nil;
        _defaultDeviceName = nil;
        _advertiser = nil;
        _peerID = nil;
        _browser = nil;
    }
    
    _serviceType = @"collabNote";
    return self;
}

// setup method for multipeer connectivity with device name
-(void)setupMCBWithDisplayName:(NSString *)displayName{
    _defaultDeviceName = displayName;
    _peerID =[[MCPeerID alloc] initWithDisplayName:displayName];
    _session = [[MCSession alloc] initWithPeer:_peerID];
    _session.delegate = self;
}

// Setup multipeer device default browser view controller
-(void)setupMCBBrowser{
    _browser = [[MCBrowserViewController alloc]initWithServiceType:_serviceType session:_session];
}

// Set device to advertise
-(void)deviceAvertising:(bool)isRequired{
    if(isRequired){
        _advertiser =[[MCAdvertiserAssistant alloc] initWithServiceType:_serviceType discoveryInfo:nil session:_session];
        [_advertiser start];
    }
    else{
        [_advertiser stop];
        _advertiser = nil;
    }
}

// Event occure on connected device state change
-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    NSDictionary *dictionary = @{@"peerID": peerID,
                           @"state" : [NSNumber numberWithInt:state]
                           };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeStateNotification"
                                                        object:nil
                                                      userInfo:dictionary];
}

// Event occure on recieving the NSdata message
-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    NSDictionary *dict = @{@"data": data,
                           @"peerID": peerID
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReceiveDataNotification"
                                                        object:nil
                                                      userInfo:dict];}

// Event occure on recieving the resource message
-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
}

// Event occure on recieving specific resource message
-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
}

// Event occure on recieving the stream message
-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
}
@end