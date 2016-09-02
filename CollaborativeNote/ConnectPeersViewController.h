//
//  ConnectPeersViewController.h
//  CollaborativeNote
//
//  Created by Jeeva Prakash on 20/01/2016.
//  Copyright © 2016 Jeeva Prakash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "AppDelegate.h"

// Controller for managing connected peers
@interface ConnectPeersViewController : UIViewController <MCBrowserViewControllerDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

// Gets or sets device name used for Multi peer connectivity advertising
@property (nonatomic, weak) IBOutlet UITextField *txtDeviceName;

// Gets or sets Multi peer connectivity device visibility switch
@property (nonatomic, weak) IBOutlet UISwitch *visibilitySwitch;

// Gets or sets table view peers
@property (nonatomic, weak) IBOutlet UITableView *tblPeers;

// Gets or sets action button for disconnect
@property (nonatomic, weak) IBOutlet UIButton *btnDisconnect;

// Search peer devices to establish connection
-(IBAction)searchPeerDevices:(id)sender;

// Action method to set device visibility for other devices
-(IBAction)setDeviceVisibility:(id)sender;

// Action method disconnect from devices
-(IBAction)disconnect:(id)sender;

// Action method navigating to main controller
-(IBAction)back:(id)sender;
@end
