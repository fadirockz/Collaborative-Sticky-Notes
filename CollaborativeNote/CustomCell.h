//
//  CustomCell.h
//  CollaborativeNote
//
//  Created by Jeeva Prakash on 23/01/2016.
//  Copyright © 2016 Jeeva Prakash. All rights reserved.
//

#import <UIKit/UIKit.h>

// User defined TableViewCell.
@interface CustomCell : UITableViewCell

// Label instance for subject.
@property (nonatomic, weak) IBOutlet UILabel *lblSubject;

// Label instance for created by.
@property (nonatomic, weak) IBOutlet UILabel *lblCreatedBy;

// Label instance for created date.
@property (nonatomic, weak) IBOutlet UILabel *lblDate;
@end
