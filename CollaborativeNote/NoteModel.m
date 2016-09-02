//
//  NoteModel.m
//  CollaborativeNote
//
//  Created by Jeeva Prakash on 21/01/2016.
//  Copyright © 2016 Jeeva Prakash. All rights reserved.
//

#import "NoteModel.h"
// Private interface section.
@interface NoteModel()

// method to get today date.
-(NSString*)getTodaysDate;
@end

// Models Note.
@implementation NoteModel

// Instantiate note model object.
-(id)init{
    self = [super init];
    if(self){
    }
    return self;
}

// Instantiate note model object.
-(id)initWithSubject:(NSString *)subject Note:(NSString *)note AndShareBy:(NSString*)sharedBy{
    self = [super self];
    if(self){
        _subject = subject;
        _note = note;
        _sharedBy = sharedBy;
        _sharedDate = self.getTodaysDate;
    }
    return self;
}

// Get today's date.
-(NSString *)getTodaysDate{
    NSDateFormatter *dateFormatter;
    NSString        *dateString;
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    
    dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    return dateString;
}
@end
