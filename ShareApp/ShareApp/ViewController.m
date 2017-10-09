//
//  ViewController.m
//  ShareApp
//
//  Created by Stefan on 11/21/16.
//  Copyright © 2016 Stefan. All rights reserved.
//

#import "ViewController.h"
#import "Social/Social.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (weak, nonatomic) IBOutlet UITextView *facebookTextView;
@property (weak, nonatomic) IBOutlet UITextView *moreTextView;

- (void) configureAllTheViews;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureAllTheViews];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// alert function
- (void) showAlertMessage: (NSString *) myMessage{
    UIAlertController *alertController;
    alertController = [UIAlertController alertControllerWithTitle:@"SocialShare" message:myMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelMessage = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:cancelMessage];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

// 1st action button for twitter
- (IBAction)tweetActionController:(id)sender {
    if([self.tweetTextView isFirstResponder])
        [self.tweetTextView resignFirstResponder];
    
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){

        SLComposeViewController *twitterViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        if([self.tweetTextView.text length] < 140)
            [twitterViewController setInitialText: self.tweetTextView.text];
        else{
            [twitterViewController setInitialText:[self.tweetTextView.text substringToIndex:140]];
        }
        [self presentViewController:twitterViewController animated:YES completion:nil];
    }
    else{
        [self showAlertMessage:@"You are not signed in to Twitter"];
    }
}

// 2nd action button for facebook
- (IBAction)facebookActionController:(id)sender {
    if([self.facebookTextView isFirstResponder])
        [self.facebookTextView resignFirstResponder];
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
        
        SLComposeViewController *facebookViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [facebookViewController setInitialText:self.facebookTextView.text];
        
        [self presentViewController:facebookViewController animated:YES completion:nil];
    }
    else
        [self showAlertMessage:@"You are not signed in to Facebook"];
}

// 3rd action button for more
- (IBAction)moreActionController:(id)sender {
    UIActivityViewController *moreViewController = [[UIActivityViewController alloc]  initWithActivityItems:@[self.moreTextView.text] applicationActivities:nil];
    
    [self presentViewController:moreViewController animated:YES completion:nil];

}

// 4th action button
- (IBAction)noFunction:(id)sender {
    [self showAlertMessage:@"I have no functionality"];
}

// I have put all the different configurations for text views
// into one signle function i order to simplify code a little
- (void) configureAllTheViews{
    self.tweetTextView.layer.backgroundColor =
    [UIColor colorWithRed: 1.0 green:1.0 blue:0.9 alpha:1.0].CGColor;
    
    self.tweetTextView.layer.cornerRadius = 12;
    self.tweetTextView.layer.borderColor =
    [UIColor colorWithWhite:0 alpha:0.5].CGColor;
    
    self.tweetTextView.layer.borderWidth = 2.0;

    self.facebookTextView.layer.backgroundColor =
    [UIColor colorWithRed: 0.5 green:0.6 blue:0.9 alpha:1.0].CGColor;
    
    self.facebookTextView.layer.cornerRadius = 10;
    self.facebookTextView.layer.borderColor =
    [UIColor colorWithWhite:0 alpha:0.5].CGColor;
    
    self.facebookTextView.layer.borderWidth = 2.0;

    self.moreTextView.layer.backgroundColor =
    [UIColor colorWithRed: 0.0 green:1.0 blue:0.9 alpha:1.0].CGColor;
    
    self.moreTextView.layer.cornerRadius = 10;
    self.moreTextView.layer.borderColor =
    [UIColor colorWithWhite:0 alpha:0.5].CGColor;
    
    self.moreTextView.layer.borderWidth = 2.0;
    
}

@end
