//
//  HomeViewController.m
//  LocalPush
//
//  Created by mapboo on 2/17/14.
//  Copyright (c) 2014 mapboo. All rights reserved.
//

#import "HomeViewController.h"

// 闹钟本地推送
// 如果闹钟需要设置多个通知，key就不能写成宏定义了，需要动态生成，
// 以便在用户关闭某个闹钟时，可以移除对应的本地通知
#define KAlarmLocalNotificationKey @"KAlarmLocalNotificationKey"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    self.title = @"本地通知";
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UIButton *notBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  notBtn.frame = CGRectMake(20, 100, 320-40, 40);
  [notBtn setBackgroundColor:[UIColor lightGrayColor]];
  [notBtn setTitle:@"开讲啦" forState:UIControlStateNormal];
  [notBtn addTarget:self action:@selector(notClick:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:notBtn];
}

- (void)notClick:(id)sender {
  NSLog(@"notBtn:%s",__FUNCTION__);
  
  [HomeViewController registerLocalNotification:4];// 4秒后
}

// 设置本地通知
+ (void)registerLocalNotification:(NSInteger)alertTime {
  UILocalNotification *notification = [[UILocalNotification alloc] init];
  // 设置触发通知的时间
  NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:alertTime];
  NSLog(@"fireDate=%@",fireDate);
  
  notification.fireDate = fireDate;
  // 时区
  notification.timeZone = [NSTimeZone defaultTimeZone];
  // 设置重复的间隔
  notification.repeatInterval = kCFCalendarUnitSecond;
  
  // 通知内容
  notification.alertBody =  @"该起床了...";
  notification.applicationIconBadgeNumber = 1;
  // 通知被触发时播放的声音
  notification.soundName = UILocalNotificationDefaultSoundName;
  // 通知参数
  NSDictionary *userDict = [NSDictionary dictionaryWithObject:@"开始学习iOS开发了" forKey:@"key"];
  notification.userInfo = userDict;
  
  // ios8后，需要添加这个注册，才能得到授权
  if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
    UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                             categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    // 通知重复提示的单位，可以是天、周、月
    notification.repeatInterval = NSCalendarUnitDay;
  } else {
    // 通知重复提示的单位，可以是天、周、月
    notification.repeatInterval = NSDayCalendarUnit;
  }
  
  // 执行通知注册
  [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

// 取消某个本地推送通知
+ (void)cancelLocalNotificationWithKey:(NSString *)key {
  // 获取所有本地通知数组
  NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
  
  for (UILocalNotification *notification in localNotifications) {
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo) {
      // 根据设置通知参数时指定的key来获取通知参数
      NSString *info = userInfo[key];
      
      // 如果找到需要取消的通知，则取消
      if (info != nil) {
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
        break;
      }
    }
  }
}

@end
