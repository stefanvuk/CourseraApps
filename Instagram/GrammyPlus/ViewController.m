//
//  ViewController.m
//  Instagram
//
//  Created by Stefan on 11/22/16.
//  Copyright © 2016 Stefan. All rights reserved.
//

#import "ViewController.h"
#import "NXOauth2.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)loginButtonPressed:(id)sender {
    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:@"Instagram"];
}


- (IBAction)logoutButtonPressed:(id)sender {
    
}

- (IBAction)refreshButtonPressed:(id)sender {
    
}
@end
