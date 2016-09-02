//
//  NoteModel.h
//  CollaborativeNote
//
//  Created by Jeeva Prakash on 21/01/2016.
//  Copyright © 2016 Jeeva Prakash. All rights reserved.
//

#import <Foundation/Foundation.h>

// Interface to model a Note.
@interface NoteModel : NSObject

// Gets or sets note id.
@property (assign) NSInteger noteId;

// Gets or sets note subject.
@property (strong) NSString *subject;

// Gets or sets note text.
@property (strong) NSString *note;

// Gets or sets note shared by.
@property (strong) NSString *sharedBy;

// Gets are sets note shared date.
@property (strong) NSString *sharedDate;

// Instantiate note model.
-(id) initWithSubject: (NSString *)subject Note:(NSString *)note AndShareBy:(NSString*)sharedBy;
@end
