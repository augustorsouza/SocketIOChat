//
//  AppDelegate.m
//  WebSocketChatClient
//
//  Created by Augusto Souza on 1/22/13.
//  Copyright (c) 2013 Menki. All rights reserved.
//

#import "AppDelegate.h"
#import "SocketIOPacket.h"

@implementation AppDelegate

@synthesize socketIO = _socketIO;
@synthesize users = _users;
@synthesize messages = _messages;

- (NSMutableArray *)messages
{
    if (!_messages) _messages = [NSMutableArray array];
    return _messages;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    self.socketIO = [[SocketIO alloc] initWithDelegate:self];
    [self.socketIO connectToHost:@"localhost" onPort:3000];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self.socketIO disconnect];
}

#pragma mark SocketIODelegate
- (void)socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    if ([packet.name isEqualToString:@"updateusers"]) {
        self.users = [NSMutableArray array];
        NSDictionary *usersDict = [packet.dataAsJSON objectForKey:@"args"][0];
        [usersDict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
            [self.users addObject:key];
        }];
    }
    else if ([packet.name isEqualToString:@"updatechat"]) {
        NSString *username = [packet.dataAsJSON objectForKey:@"args"][0]; // first param
        NSString *data = [packet.dataAsJSON objectForKey:@"args"][1]; // second param
        
        NSString *message = [NSString stringWithFormat:@"%@: %@", username, data];
        [self.messages addObject:message];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateListViewController" object:nil];
}

@end
