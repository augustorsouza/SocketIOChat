//
//  ListViewController.m
//  WebSocketChatClient
//
//  Created by Augusto Souza on 1/22/13.
//  Copyright (c) 2013 Menki. All rights reserved.
//

#import "ListViewController.h"
#import "AppDelegate.h"

@interface ListViewController () <UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray *objects;

- (void)updateView:(NSNotification *)notification;
- (BOOL)isListingUsers;
- (BOOL)isListingMessages;
- (void)sendNewChatMessage:(id)sender;

@end

@implementation ListViewController

@synthesize option = _option;
@synthesize objects = _objects;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(sendNewChatMessage:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateView:) name:@"updateListViewController" object:nil];
}

- (void)updateView:(NSNotification *)notification
{
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = self.option;
}

- (BOOL)isListingUsers
{
    return [self.option isEqualToString:@"Users"];
}

- (BOOL)isListingMessages
{
    return [self.option isEqualToString:@"Messages"];
}

- (void)sendNewChatMessage:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"What would like to say?"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Send", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // If button is different than cancel
    if (buttonIndex != 0) {
        NSString *message = [alertView textFieldAtIndex:0].text;
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate.socketIO sendEvent:@"sendchat" withData:message];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([self isListingUsers]) {
        return [appDelegate.users count];
    }
    else {
        return [appDelegate.messages count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
 
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([self isListingUsers]) {
        cell.textLabel.text = appDelegate.users[indexPath.row];
    }
    else {
        cell.textLabel.text = appDelegate.messages[indexPath.row];
    }
    
    return cell;
}

@end
