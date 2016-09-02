//
//  DBManager.m
//  CollaborativeNote
//
//  Created by Jeeva Prakash on 19/01/2016.
//  Copyright © 2016 Jeeva Prakash. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h>

// Database manager interface
@interface DBManager ()

// Database path
@property (nonatomic, strong) NSString *databasePath;

// Query result
@property (nonatomic, strong) NSMutableArray *queryResult;

// Setup database method
-(void)setupDatabase;

// Execute select query method
-(NSMutableArray *)executeSelectQuery:(const char *)query;

// Execute query method
-(void)executeQuery:(const char *)query;
@end

// Database manager
@implementation DBManager

// Instatiate database manager
-(instancetype)initDatabase{
    self = [super init];
    
    if(self){
        self.databaseName = @"noteDB.sql";
        
        // Sets Database path
        NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
        _databasePath  = [documentsPaths objectAtIndex:0];
        
        // Setup database
        [self setupDatabase];
    }
    
    return self;
}

// Setup database
-(void) setupDatabase{
    // Locate database path
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSError *error;
    if([filemanager fileExistsAtPath:_databasePath]){
        NSLog(@"database exists");
        return;
    }
    
    // Copy database to local domain directory
    NSString *databaseDestinationPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseName];
    
    [filemanager copyItemAtPath:databaseDestinationPath toPath:_databasePath error:&error];
    
    if(error != nil){
        NSLog(@"%@", [error localizedDescription]);
    }
}

// Create note database method
-(void) createNote:(NoteModel *)noteModel{
    NSString *query;
    query = [NSString stringWithFormat:@"INSERT INTO notes (subject, description, sharedBy, sharedDate) values ('%@', '%@','%@', '%@')", noteModel.subject, noteModel.note, noteModel.sharedBy, noteModel.sharedDate];
    [self executeQuery:[query UTF8String]];
    
}

// Update note database method
-(void) updateNote:(NoteModel *)noteModel{
    NSString *query;
    query = [NSString stringWithFormat:@"UPDATE notes SET subject = '%@', description = '%@' WHERE noteID = '%ld'", noteModel.subject, noteModel.note, (long)noteModel.noteId];
    [self executeQuery:[query UTF8String]];
}

// Get note by id
-(NoteModel *)getNoteById:(int)noteId{
    NoteModel *model = [[NoteModel alloc] init];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM notes WHERE noteID=%d",noteId];
    NSArray *results = [[NSArray alloc] initWithArray:[self executeSelectQuery:[query UTF8String]]];
    
    model.subject = [[results objectAtIndex:0] objectAtIndex:[self.columnNames indexOfObject:@"subject"]];
    model.note = [[results objectAtIndex:0] objectAtIndex:[self.columnNames indexOfObject:@"description"]];
    
    return model;
}

// delete note by id
-(void) deleteNoteById:(int)noteId{
    NSString *query = [NSString stringWithFormat:@"DELETE FROM notes WHERE noteID=%d", noteId];
    [self executeQuery:[query UTF8String]];
}

// Load all notes
-(NSMutableArray *)loadAllNotes{
    NSString *query = @"SELECT * FROM notes";
    return [[NSMutableArray alloc]initWithArray:[self executeSelectQuery:[query UTF8String]]];
}

// Generic method for select queries
-(NSMutableArray *)executeSelectQuery:(const char *)query{
    sqlite3 *database;
    _queryResult = [[NSMutableArray alloc] init];
    
    // column names array
    self.columnNames = [[NSMutableArray alloc] init];
    
    // Populate multi dimension array for the all tables
    if (sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK) {
        sqlite3_stmt *compiledStatement;
        if (sqlite3_prepare_v2(database, query, -1, &compiledStatement, NULL)==SQLITE_OK) {
            NSMutableArray *dataRows;
            while (sqlite3_step(compiledStatement)==SQLITE_ROW) {
                dataRows = [[NSMutableArray alloc] init];
                int totalColumns = sqlite3_column_count(compiledStatement);
                for (int i=0; i<totalColumns; i++){ // loop through number of columns
                    char *columnValues = (char *)sqlite3_column_text(compiledStatement, i);
                    if (columnValues != NULL) { // add column values into array
                        [dataRows addObject:[NSString  stringWithUTF8String:columnValues]];
                    }
                    
                    // Assign to column array
                    if (self.columnNames.count != totalColumns) {
                        char *columnName = (char *)sqlite3_column_name(compiledStatement, i);
                        [self.columnNames addObject:[NSString stringWithUTF8String:columnName]];
                    }
                }
                
                if (dataRows.count > 0) {
                    [_queryResult addObject:dataRows];
                }
            }
        }
        // release the compiled statement
        sqlite3_finalize(compiledStatement);
        // close the database
        sqlite3_close(database);
    }
    
    return _queryResult;
}

// Execute query for Insert/ Update / Delete
-(void)executeQuery:(const char *)query{
    sqlite3 *database;
    
    if (sqlite3_open([_databasePath UTF8String], &database) == SQLITE_OK) {
        sqlite3_stmt *compiledStatement;
        if (sqlite3_prepare_v2(database, query, -1, &compiledStatement, NULL)==SQLITE_OK) {
           if(sqlite3_step(compiledStatement)==SQLITE_ROW){
               NSLog(@"Note created");

            }
           else{
                NSLog(@"DB Error: %s", sqlite3_errmsg(database));
           }
            
        }
        // release the compiled statement
        sqlite3_finalize(compiledStatement);
        // close the database
        sqlite3_close(database);
    }
}
@end
