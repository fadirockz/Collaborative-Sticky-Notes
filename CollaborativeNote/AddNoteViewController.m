//
//  AddNoteViewController.m
//  CollaborativeNote
//
//  Created by Jeeva Prakash on 19/01/2016.
//  Copyright © 2016 Jeeva Prakash. All rights reserved.
//

#import "AddNoteViewController.h"
#import "DBManager.h"
#import "AppDelegate.h"
#import "NoteModel.h"

// Add note view controller interface
@interface AddNoteViewController ()

// Shared application delegate
@property (nonatomic, strong) AppDelegate *appDelegate;

// Database manager instance
@property (nonatomic, strong) DBManager *dbManager;

// Note model instance
@property (nonatomic, strong) NoteModel *noteModel;

// Initialise view component
-(void)initialiseViewComponent;

//Load note to edit
-(void)loadNoteToEdit;

// Show simple alert message.
-(void)showSimpleAlertMessage:(NSString*)message WithTitle:(NSString *)title;

// Get note model with data.
-(NoteModel *)getNoteModel;
@end

// Add note view controller
@implementation AddNoteViewController

// View did load
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.shareButton setEnabled:NO];
    
    // get insnce of shared application delegate
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _dbManager = [[DBManager alloc] initDatabase]; // Instantiate database manager
    
    [self initialiseViewComponent]; // initialise view components
    
    // edit note on NOTEID is greater than -1
    if (self.noteID != -1) {
        self.navigationItem.title = @"Edit Note";
        BOOL connectedPeersExists = ([[_appDelegate.connectionManager.session connectedPeers] count] == 0);
        [self.shareButton setEnabled:!connectedPeersExists];
        [self loadNoteToEdit];
    }
}

-(void)initialiseViewComponent{
    // set note textbox style
    UIColor *borderColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:0.5];
    [self.txtNote.layer setBorderColor:borderColor.CGColor];
    [self.txtNote.layer setBorderWidth:1.0];
    [self.txtNote.layer setCornerRadius:5.0];
    [self.txtNote setTextContainerInset:UIEdgeInsetsMake(2.0,1.0,0,0.0)];
    [self.txtNote setFont:[UIFont fontWithName:@"arial" size:17]];
    
    // Set Navigation Bar Tint Color
    [self.navigationController.navigationBar setTintColor: self.navigationItem.rightBarButtonItem.tintColor];
    
    // Share button instance
    self.shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareNote)];
    
     // Save button instance
    self.saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveNote)];
    
    // Flexible space bar button instance
    self.flexibleSpaceBarButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                   target:nil
                                   action:nil];
    
    // Add save button to navigation bar
    self.navigationItem.rightBarButtonItem = self.saveButton;
    
    // Add toolbar buttons
    self.toolbarItems = [NSArray arrayWithObjects:self.flexibleSpaceBarButton,self.shareButton,nil];
}

// Save note details
-(void)saveNote{
    _noteModel = [ self getNoteModel]; // get note model
    
    if(_noteModel.subject.length != 0 || _noteModel.note.length != 0){
        
        if(_noteModel.subject.length == 0){ // Set subject to first word of note
            NSArray *firstWord= [_noteModel.note componentsSeparatedByString:@" "];
            _noteModel.subject = [firstWord objectAtIndex:0];
        }
        
        if (self.noteID == -1) { // create note
            [_dbManager createNote:_noteModel];
        }
        else{ // Update note
            _noteModel.noteId = self.noteID;
            [_dbManager updateNote:_noteModel];
        }
        
        // Sets delegate to reload the table view
        [self.delegate editingNoteWasFinished];
    }
    
    // displays previous controller
    [self.navigationController popViewControllerAnimated:YES];
}

// Returns note model
-(NoteModel *)getNoteModel{
    NoteModel *model = [[NoteModel alloc] init];
    [model setSubject:self.txtSubject.text];
    [model setNote:self.txtNote.text];
    [model setSharedBy:@""];
    [model setSharedDate:@""];
    return model;
}

// load Note to edit
-(void)loadNoteToEdit{
    _noteModel = [_dbManager getNoteById:self.noteID];
    [self.txtNote setText:_noteModel.note];
    [self.txtSubject setText:_noteModel.subject];
}

// Show simple alert message
-(void)showSimpleAlertMessage:(NSString *)message WithTitle:(NSString *)title{
    // Alert view action message
    UIAlertController *view = [UIAlertController
                                alertControllerWithTitle:title
                                message:message
                                preferredStyle:UIAlertControllerStyleAlert];
    // OK action button
    UIAlertAction *ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [view dismissViewControllerAnimated:YES completion:nil];
                             [self.navigationController popViewControllerAnimated:YES];

                         }];
    [view addAction:ok];
    [self presentViewController:view animated:YES completion:nil];
}

// Share note data
-(void) shareNote{
    NSError *error;
    // Get connected peers
    NSArray *peers = _appDelegate.connectionManager.session.connectedPeers;
    
    // Dictionary object for data to share
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.txtSubject.text, @"subject",
                                    self.txtNote.text, @"note",
                                    Nil];
    
    // JSON data
    NSData *noteDataToSend = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    // send data
    [_appDelegate.connectionManager.session sendData:noteDataToSend
                                     toPeers:peers
                                    withMode:MCSessionSendDataReliable
                                       error:&error];
    if (error != nil) {
        NSLog(@"%@", [error localizedDescription]);
        [self showSimpleAlertMessage:@"Failed to share note." WithTitle:@"Share Note"];
    }
    else{
        [self showSimpleAlertMessage:@"Successfully shared note with connected peers." WithTitle:@"Share Note"];
    }
}
@end
