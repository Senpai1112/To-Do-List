//
//  FirstCustomCell.m
//  To Do List
//
//  Created by Youssab on 30/12/2024.
//

#import "FirstCustomCell.h"

@implementation FirstCustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.firstCustomCellImage.translatesAutoresizingMaskIntoConstraints = NO;
    self.firstCustomCellImage.translatesAutoresizingMaskIntoConstraints =NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
