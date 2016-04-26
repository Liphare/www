//
//  AppDelegate.m
//  P.xiaoshuo
//
//  Created by 王开政 on 16/2/29.
//  Copyright (c) 2016年 Wang. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "BookCollectionViewController.h"
#import "HomeViewController.h"
#import "PersonViewController.h"
#import "RegisterViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
//    HomeViewController *view = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
//    BookCollectionViewController *view = [[BookCollectionViewController alloc]initWithNibName:@"BookCollectionViewController" bundle:nil];
    HomeViewController *homeView = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:homeView];
    [nav1 setNavigationBarHidden:YES];
    nav1.tabBarItem.image = [UIImage imageNamed:@"首页"];
    BookCollectionViewController *bookView = [[BookCollectionViewController alloc]initWithNibName:@"BookCollectionViewController" bundle:nil];
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:bookView];
    nav2.tabBarItem.image = [UIImage imageNamed:@"书架"];
    [nav2 setNavigationBarHidden:YES];//隐藏导航栏
    PersonViewController *presonView = [[PersonViewController alloc]initWithNibName:@"PersonViewController" bundle:nil];
    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:presonView];
    nav3.tabBarItem.image = [UIImage imageNamed:@"个人中心"];
    [nav3 setNavigationBarHidden:YES];//隐藏导航栏
    NSArray *bararray = [[NSArray alloc]initWithObjects:nav1,nav2,nav3, nil];
    self.barControl = [[UITabBarController alloc]init];
   self.barControl.viewControllers = bararray;
    
    
   LoginViewController *viewControl = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    
    
    
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *str = [array objectAtIndex:0];
    NSLog(@"%@",str);
    NSString *name = @"photo";
    NSString *path = [str stringByAppendingPathComponent:name];
    NSString *imgname = [[NSBundle mainBundle]pathForResource:@"photo" ofType:@"png"];
    UIImage *img = [UIImage imageNamed:imgname];
    NSData *data =UIImagePNGRepresentation(img);
    [data writeToFile:path atomically:YES];
    self.url1 = [[NSString alloc]init];
    self.talker = [[AVSpeechSynthesizer alloc]init];
    self.utter = [[AVSpeechUtterance alloc]init];
    self.networkSign = YES;
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    if ([r currentReachabilityStatus] == NotReachable)
    {
        self.networkSign = NO;
    }

//    RegisterViewController *viewControl = [[RegisterViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
//    self.window.rootViewController =viewControl;

   self.window.rootViewController = self.barControl;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.fengyun.P_xiaoshuo" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"P_xiaoshuo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"P_xiaoshuo.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
