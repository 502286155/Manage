//
//  ANActivityModel.h
//  baobaotang
//
//  Created by 高赛 on 15/12/9.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANActivityModel : NSObject

/**
 *  消息发送时间
 */
@property (nonatomic, copy) NSString *add_time;
/**
 *  消息id
 */
@property (nonatomic, copy) NSString *ID;
/**
 *  消息图片地址
 */
@property (nonatomic, copy) NSString *preview_pic;
/**
 *  消息标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  url
 */
@property (nonatomic, copy) NSString *url;

@end
