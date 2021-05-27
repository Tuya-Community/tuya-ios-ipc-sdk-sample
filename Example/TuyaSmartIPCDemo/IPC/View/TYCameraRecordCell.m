//
//  TYCameraRecordCell.m
//  TuyaSmartPublic
//
//  Created by 傅浪 on 2018/4/14.
//  Copyright © 2018 Tuya. All rights reserved.
//

#import "TYCameraRecordCell.h"
#import <TuyaSmartCameraBase/TuyaSmartCameraBase.h>

@implementation TYCameraRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _iconImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(20, 6, 96, 54)];
        _startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(124, 14, 80, 22)];
        _startTimeLabel.textColor = [UIColor blackColor];
    
        _durationLabel  = [[UILabel alloc] initWithFrame:CGRectMake(124, 38, 66, 20)];
        _durationLabel.textColor = [UIColor blackColor];
        
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth - 90, 0, 80, 72)];
        _typeLabel.textAlignment = NSTextAlignmentRight;
        
        [self addSubview:_iconImageView];
        [self addSubview:_startTimeLabel];
        [self addSubview:_durationLabel];
        [self addSubview:_typeLabel];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
}

@end
