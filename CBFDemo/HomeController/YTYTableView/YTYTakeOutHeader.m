//
//  TakeOutHeader.m
//  CBFDemo
//
//  Created by iMac on 2017/2/5.
//  Copyright © 2017年 yty. All rights reserved.
//

#import "YTYTakeOutHeader.h"

@interface YTYTakeOutHeader()
@property (nonatomic,weak) UILabel *title;
@end

@implementation YTYTakeOutHeader

+ (instancetype)headerWithTableView:(UITableView *)tableview
{
    static NSString *ID = @"YTYTakeOutHeader";
    YTYTakeOutHeader *header = [tableview dequeueReusableCellWithIdentifier:ID];
    if (header == nil) {
        header = [[YTYTakeOutHeader alloc] initWithReuseIdentifier:ID];
    }
    return header;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 200, 20)];
        title.font = [UIFont systemFontOfSize:11];
        self.title = title;
        [self.contentView addSubview:title];
    }
    return self;
}

- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
    self.title.text = titleStr;
}


@end
