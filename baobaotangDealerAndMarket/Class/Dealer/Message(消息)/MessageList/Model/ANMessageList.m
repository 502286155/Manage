//
//  ANMessageList.m
//  baobaotang
//
//  Created by 高赛 on 15/12/2.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import "ANMessageList.h"

@implementation ANMessageList

- (CGFloat)returnCellHeight
{
    CGSize size = [ANCommon sizeWithText:self.title font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(WIDTH - 60, 1000)];
    self.contentHeight = size.height;
    self.cellHeight = size.height + 50;
    return self.cellHeight;
}

@end
