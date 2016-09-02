//
//  MasterViewController.h
//  CollaborativeNote
//
//  Created by Jeeva Prakash on 19/01/2016.
//  Copyright © 2016 Jeeva Prakash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddNoteViewController.h"

// Master view controller interface
@interface MasterViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,
    UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating,AddNoteViewControllerDelegate>

// Gets or sets tabel view
@property (nonatomic, weak) IBOutlet UITableView *tblNotes;

// Action method for create note
-(IBAction)createNote:(id)sender;
@end
