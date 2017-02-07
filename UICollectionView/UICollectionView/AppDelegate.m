//
//  AppDelegate.m
//  UICollectionView
//
//  Created by ggt on 2017/2/4.
//  Copyright © 2017年 GGT. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "GPViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    self.window.rootViewController = [[GPViewController alloc] init];
    
    return YES;
}

@end
