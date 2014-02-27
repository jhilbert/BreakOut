//
//  StartScreenViewController.m
//  BreakOut
//
//  Created by Josef Hilbert on 17.01.14.
//  Copyright (c) 2014 Josef Hilbert. All rights reserved.
//

#import "StartScreenViewController.h"
#import "ViewController.h"

@interface StartScreenViewController ()
{
    
    __weak IBOutlet UIButton *onePlayerButton;
    __weak IBOutlet UIButton *settingsButton;
    __weak IBOutlet UIButton *twoPlayerButton;
    NSInteger numberOfPlayers;
}

@end

@implementation StartScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationController.navigationBarHidden = YES;
}

- (IBAction)onSettingsButtonPressed:(id)sender {
}

- (IBAction)onOnePlayerButtonPressed:(id)sender {
    numberOfPlayers = 1;
    [self performSegueWithIdentifier:@"MySegue" sender:sender];
}

- (IBAction)onTwoPlayerButtonPressed:(id)sender {
    numberOfPlayers = 2;
    [self performSegueWithIdentifier:@"MySegue" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"MySegue"])
    {
        ViewController *vc = [segue destinationViewController];
        [vc setNumberOfPlayers:numberOfPlayers];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
