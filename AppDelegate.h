//
//  AppDelegate.h
//  Free Kick Master
//
//  Created by ali arda eker on 3/20/17.
//  Copyright © 2017 AliArdaEker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

