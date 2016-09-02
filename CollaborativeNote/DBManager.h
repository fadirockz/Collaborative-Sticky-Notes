//
//  DBManager.h
//  CollaborativeNote
//
//  Created by Jeeva Prakash on 19/01/2016.
//  Copyright © 2016 Jeeva Prakash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteModel.h"

// Database manager interface
@interface DBManager : NSObject

// Gets or Sets database name
@property (strong) NSString* databaseName;
// Gets or sets column names
@property (nonatomic, strong) NSMutableArray *columnNames;

// Initialise database
-(instancetype)initDatabase;

// Create note
-(void)createNote:(NoteModel *)noteModel;

// Update note
-(void)updateNote:(NoteModel *)noteModel;

// Get note by id
-(NoteModel *)getNoteById:(int)noteId;

// Load all notes
-(NSMutableArray *)loadAllNotes;

//delete note by id
-(void)deleteNoteById:(int)noteId;
@end
