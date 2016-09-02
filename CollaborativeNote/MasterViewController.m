//
//  MasterViewController.m
//  CollaborativeNote
//
//  Created by Jeeva Prakash on 19/01/2016.
//  Copyright © 2016 Jeeva Prakash. All rights reserved.
//

#import "MasterViewController.h"
#import "ConnectPeersViewController.h"
#import "DBManager.h"
#import "CustomCell.h"

// Master view controller interface
@interface MasterViewController ()

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSMutableArray *notes;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *filteredNoteItems;
@property (nonatomic, weak) NSMutableArray *displayedNoteItems;

@property (nonatomic) int noteID;

-(void)initialzeViewComponent;
-(void)loadData;
-(void)peerReceiveDataWithNotification:(NSNotification *)notification;
-(void)saveReceivedNoteData:(NSDictionary *)receivedData ShareBy:(NSString *)sharedBy;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dbManager = [[DBManager alloc] initDatabase];
    [self initialzeViewComponent];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerReceiveDataWithNotification:)
                                                 name:@"ReceiveDataNotification"
                                               object:nil];
    
    self.definesPresentationContext = YES;
    [self loadData];
}

-(void)initialzeViewComponent{
    self.tblNotes.delegate = self;
    self.tblNotes.dataSource = self;

    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"All Notes" style:UIBarButtonItemStylePlain target:nil action:nil]];
    
    UIColor *navigationTintColor = [[UIColor alloc] initWithRed:0.95 green:0.76 blue:0.20 alpha:1.0];
    [self.navigationController.toolbar setBarTintColor:navigationTintColor];
    [self.navigationController.navigationBar setBarTintColor:navigationTintColor];
    [self.navigationController.navigationBar setTranslucent:YES];

    _filteredNoteItems = [[NSMutableArray alloc]init];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    [_searchController setSearchResultsUpdater:self];
    [_searchController.searchBar setDelegate:self];
    [_searchController setDimsBackgroundDuringPresentation:FALSE];
    [_searchController.searchBar sizeToFit];
    
    self.tblNotes.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tblNotes registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
    [self.tblNotes setTableHeaderView:_searchController.searchBar];
    [self.tblNotes setContentOffset:CGPointMake(0, _searchController.searchBar.frame.size.height)];
}

// Action method for create note
-(IBAction)createNote:(id)sender{
    self.noteID = -1;
    [self performSegueWithIdentifier:@"addEditNote" sender:self];
}

// delegate method loading table view on success of edit note
-(void)editingNoteWasFinished{
    [self loadData];
}

// Load data on table view
-(void)loadData{
    _notes = [_dbManager loadAllNotes];
    _displayedNoteItems = _notes;
    [self.tblNotes reloadData];
}

// Table view row databind method
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = (CustomCell*)[tableView dequeueReusableCellWithIdentifier:@"CustomCell" forIndexPath:indexPath];
    
    // Get index of subject, shared by and shared date details
    NSInteger indexOfSubject = [_dbManager.columnNames indexOfObject:@"subject"];
    NSInteger indexOfSharedBy = [_dbManager.columnNames indexOfObject:@"sharedBy"];
    NSInteger indexOfSharedDate = [_dbManager.columnNames indexOfObject:@"sharedDate"];
    
    // Custome cell with Subject
    cell.lblSubject.text = [NSString stringWithFormat:@"%@",[[_displayedNoteItems objectAtIndex:indexPath.row] objectAtIndex:indexOfSubject]];
    
    // Custome cell with createby
    cell.lblCreatedBy.text = [NSString stringWithFormat:@"%@",[[_displayedNoteItems objectAtIndex:indexPath.row] objectAtIndex:indexOfSharedBy]];
    
    // Custom cell with shared date
    cell.lblDate.text = [NSString stringWithFormat:@"%@",[[_displayedNoteItems objectAtIndex:indexPath.row] objectAtIndex:indexOfSharedDate]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.noteID = [[[_displayedNoteItems objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
    [self performSegueWithIdentifier:@"addEditNote" sender:self.view];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        int noteIDToDelete = [[[_displayedNoteItems objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
        [_dbManager deleteNoteById:noteIDToDelete];
        [self loadData];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"addEditNote"]) {
        AddNoteViewController *controller = [segue destinationViewController];
        controller.delegate = self;
        controller.noteID = self.noteID;
    }
    
    if ([segue.identifier isEqualToString:@"peerConnect"]) {
    }
}

-(void)peerReceiveDataWithNotification:(NSNotification *)notification{
    NSError *error;
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    
    NSData *receivedJsonData = [[notification userInfo] objectForKey:@"data"];
    NSDictionary *noteData = [NSJSONSerialization JSONObjectWithData:receivedJsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&error];
    [self saveReceivedNoteData:noteData ShareBy:peerDisplayName];
    [self loadData];
}

-(void)saveReceivedNoteData:(NSDictionary *)noteData ShareBy:(NSString *)sharedBy{
    NoteModel *model = [[NoteModel alloc]initWithSubject:[noteData objectForKey:@"subject"] Note:[noteData objectForKey:@"note"] AndShareBy:sharedBy];
    [_dbManager createNote:model];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _displayedNoteItems.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = _searchController.searchBar.text;
    NSInteger indexOfSubject = [_dbManager.columnNames indexOfObject:@"subject"];
    
    if (![searchString isEqualToString:@""]) {
        [_filteredNoteItems removeAllObjects];
        for (NSArray *note in _notes) {
            NSString *subject = [note objectAtIndex:indexOfSubject];
            if ([searchString isEqualToString:@""] || [subject localizedCaseInsensitiveContainsString:searchString] == YES) {
                NSLog(@"str=%@", note);
                [_filteredNoteItems addObject:note];
            }
        }
        
        _displayedNoteItems = _filteredNoteItems;
    }
    else {
        _displayedNoteItems = _notes;
    }
    
    [self.tblNotes reloadData];
}
@end
