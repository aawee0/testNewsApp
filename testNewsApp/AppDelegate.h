//
//  AppDelegate.h
//  testNewsApp
//
//  Created by Evgeny Patrikeev on 02.07.2018.
//  Copyright © 2018 Evgeny Patrikeev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

