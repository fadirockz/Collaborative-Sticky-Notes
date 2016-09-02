//
//  AddNoteViewController.h
//  CollaborativeNote
//
//  Created by Jeeva Prakash on 19/01/2016.
//  Copyright © 2016 Jeeva Prakash. All rights reserved.
//

#import <UIKit/UIKit.h>

// View controller delegate
@protocol AddNoteViewControllerDelegate

// Delegate called on note edit
-(void)editingNoteWasFinished;
@end

// View controller for Add/Edit Note
@interface AddNoteViewController : UIViewController

// view controller delegate instance
@property (nonatomic, strong) id<AddNoteViewControllerDelegate> delegate;

// Subject textfield instance
@property (nonatomic, weak) IBOutlet UITextField *txtSubject;

// Note textview instance
@property (nonatomic, weak) IBOutlet UITextView *txtNote;

// Share bar button ietm instance
@property (nonatomic, strong) UIBarButtonItem *shareButton;

// Save bar button item instance
@property (nonatomic, strong) UIBarButtonItem *saveButton;

// Flexible bar button item instance
@property (nonatomic, strong) UIBarButtonItem *flexibleSpaceBarButton;

// Gets or sets Note Id
@property (nonatomic) int noteID;

// Share note details
-(void)shareNote;

// Save note data
-(void)saveNote;
@end
