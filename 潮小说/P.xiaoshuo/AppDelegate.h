//
//  AppDelegate.h
//  P.xiaoshuo
//
//  Created by 王开政 on 16/2/29.
//  Copyright (c) 2016年 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <AVFoundation/AVFoundation.h>
#import "Reachability.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,AVSpeechSynthesizerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *pwd;
@property(nonatomic, copy) NSString *photo;
@property (nonatomic, assign) NSInteger bookNumberName;
@property (nonatomic, copy) NSString *bookName;
@property (nonatomic, assign) int index;
@property (nonatomic, assign) int indexrow;
@property (nonatomic, retain)UITabBarController *barControl;
@property (nonatomic, strong) AVSpeechSynthesizer* talker;
@property (nonatomic, strong) AVSpeechUtterance *utter;
@property (nonatomic, copy) NSString *url1;
@property (nonatomic, assign) BOOL networkSign;

@end

