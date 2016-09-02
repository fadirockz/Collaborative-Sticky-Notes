//
//  ConnectPeersViewController.m
//  CollaborativeNote
//
//  Created by Jeeva Prakash on 20/01/2016.
//  Copyright © 2016 Jeeva Prakash. All rights reserved.
//

#import "ConnectPeersViewController.h"

// Controller for managing connected peers
@interface ConnectPeersViewController ()

// Application deligate instance
@property (nonatomic, strong) AppDelegate *appDelegate;

// Lists all connected peers with the device
@property (nonatomic, strong) NSMutableArray *connectedPeers;

// Notification method for peer state change event
-(void)connectedPeerChangeStateWithNotification:(NSNotification *)notification;

// Load connected peers into table view
-(void)loadConnectedPeers;

// Initialise the view component
-(void)initialiseViewComponents;

// Setup method for delegates
-(void)setupApplicationDelegate;
@end

@implementation ConnectPeersViewController

// Instanntiate object
-(id)init{
    self =[super init];
    if(self){
    }
    
    return self;
}

// View load method
- (void)viewDidLoad {
    [super viewDidLoad];
     _connectedPeers = [[NSMutableArray alloc] init];
    [self initialiseViewComponents];
    [self setupApplicationDelegate];
    
    // sets table view cell footer frame.
    self.tblPeers.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Setup observer for peer state change
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(connectedPeerChangeStateWithNotification:)
                                                 name:@"ChangeStateNotification"
                                               object:nil];
}

// Initialise the view component
-(void)initialiseViewComponents{
    [_txtDeviceName setDelegate:self];
    [_tblPeers setDelegate:self];
    [_tblPeers setDataSource:self];
}

// Setup application delegates
-(void)setupApplicationDelegate{
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([[_appDelegate connectionManager] session] == nil){
        
        [[_appDelegate connectionManager] setupMCBWithDisplayName:[UIDevice currentDevice].name];
    }
    else {
        [_txtDeviceName setText: [UIDevice currentDevice].name];
        [self loadConnectedPeers];
    }
    
    [[_appDelegate connectionManager] deviceAvertising:_visibilitySwitch.isOn];
}

// Load connected peers into table view
-(void)loadConnectedPeers{
    for(MCPeerID *peer in [_appDelegate.connectionManager.session connectedPeers]){
        [_connectedPeers addObject:[peer displayName]];
    }
    
    [_tblPeers reloadData];
}

// Search peer devices to establish connection
-(IBAction)searchPeerDevices:(id)sender{
    // Setup multipeer connectivity browser
    [[_appDelegate connectionManager] setupMCBBrowser];
    
    // Set browser delegate
    [[[_appDelegate connectionManager] browser] setDelegate:self];
    
    // Set browser view to display
    [self presentViewController:[[_appDelegate connectionManager] browser] animated:YES completion:nil];
}

// Navigation button for parent view
-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

// Browser view controller finish event method
-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [_appDelegate.connectionManager.browser dismissViewControllerAnimated:YES completion:nil];
}

// Browser view controller cancelled event method
-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [_appDelegate.connectionManager.browser dismissViewControllerAnimated:YES completion:nil];
}

// Notification method for peer state change event
-(void)connectedPeerChangeStateWithNotification:(NSNotification *)notification{
    // Gets device peer id
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    
    // Gets Peer display name
    NSString *peerDisplayName = peerID.displayName;
    
    // Gets peer session state
    MCSessionState sessionState = [[[notification userInfo] objectForKey:@"state"] intValue];
    
    if (sessionState != MCSessionStateConnecting) {
        if (sessionState == MCSessionStateConnected) {
            // add to list of connected devices
            [_connectedPeers addObject:peerDisplayName];
        }
        else if (sessionState == MCSessionStateNotConnected){ // remove device if it is disconnected
            if ([_connectedPeers count] > 0) {
                int indexOfPeer = (int)[_connectedPeers indexOfObject:peerDisplayName];
                [_connectedPeers removeObjectAtIndex:indexOfPeer];
            }
        }
        
        // Reload table view
        [_tblPeers reloadData];
    }
}

// Table view protocol method for number of rows
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_connectedPeers count];
}

// Table view protocol method for cell for a row index
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"peerCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"peerCell"];
    }
    
    // sets connected device name
    [cell.textLabel setText:[_connectedPeers objectAtIndex:indexPath.row]];
    
    return cell;
}

// Tablbe view protocol to set height of a cell
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

// Sets number of sections in table view
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// Text box delegate method
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_txtDeviceName resignFirstResponder];
    
    _appDelegate.connectionManager.peerID = nil;
    _appDelegate.connectionManager.session = nil;
    _appDelegate.connectionManager.browser = nil;
    
    if(_connectedPeers != nil){ // remove all connected devices
        [_connectedPeers removeAllObjects];
        [_tblPeers reloadData];
    }
    
    if([_visibilitySwitch isOn]){ // Set device to advertise to connect
        [_appDelegate.connectionManager.advertiser stop];
    }
    _appDelegate.connectionManager.advertiser= nil;
    
    [[_appDelegate connectionManager] setupMCBWithDisplayName:_txtDeviceName.text];
    [[_appDelegate connectionManager] setupMCBBrowser];
    [[_appDelegate connectionManager] deviceAvertising:_visibilitySwitch.isOn];
    return YES;
}

// Action method to set device visibility for other devices
- (IBAction)setDeviceVisibility:(id)sender {
    [_appDelegate.connectionManager deviceAvertising: _visibilitySwitch.isOn];
}

// Action method disconnect from devices
- (IBAction)disconnect:(id)sender {
    [_appDelegate.connectionManager.session disconnect];
    [_connectedPeers removeAllObjects];
    [_tblPeers reloadData];
}
@end
