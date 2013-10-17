//
//  AppDelegate.h
//  WebSocketChatClient
//
//  Created by Augusto Souza on 1/22/13.
//  Copyright (c) 2013 Menki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocketIO.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, SocketIODelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SocketIO *socketIO;
@property (strong, nonatomic) NSMutableArray *users;
@property (strong, nonatomic) NSMutableArray *messages;

@end
