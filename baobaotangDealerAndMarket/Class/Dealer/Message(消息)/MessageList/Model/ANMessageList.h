//
//  ANMessageList.h
//  baobaotang
//
//  Created by 高赛 on 15/12/2.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANMessageList : NSObject

@property (nonatomic, copy) NSString *listID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, assign) CGFloat cellHeight;

- (CGFloat)returnCellHeight;

@end
