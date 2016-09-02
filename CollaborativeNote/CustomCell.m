//
//  CustomCell.m
//  CollaborativeNote
//
//  Created by Jeeva Prakash on 23/01/2016.
//  Copyright © 2016 Jeeva Prakash. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

@synthesize lblSubject, lblDate, lblCreatedBy;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
