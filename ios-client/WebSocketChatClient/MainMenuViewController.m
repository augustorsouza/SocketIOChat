//
//  MasterViewController.m
//  WebSocketChatClient
//
//  Created by Augusto Souza on 1/22/13.
//  Copyright (c) 2013 Menki. All rights reserved.
//

#import "MainMenuViewController.h"
#import "AppDelegate.h"
#import "ListViewController.h"
#import "SocketIO.h"

@interface MainMenuViewController () <UIAlertViewDelegate>

@property (strong, nonatomic) NSArray *options;

@end

@implementation MainMenuViewController

@synthesize options = _options;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.options = @[@"Users", @"Messages"];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"What's your name?"
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
        NSString *name = [alertView textFieldAtIndex:0].text;
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate.socketIO sendEvent:@"adduser" withData:name];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.options count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainMenuCellIdentifier" forIndexPath:indexPath];
    
    cell.textLabel.text = self.options[indexPath.row];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"selectOption"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *option = self.options[indexPath.row];
        [[segue destinationViewController] setOption:option];
    }
}

@end
