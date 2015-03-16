//
//  HomeViewController.h
//  LocalPush
//
//  Created by mapboo on 2/17/14.
//  Copyright (c) 2014 mapboo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController

// 设置本地通知
+ (void)registerLocalNotification:(NSInteger)alertTime;
+ (void)cancelLocalNotificationWithKey:(NSString *)key;

@end
