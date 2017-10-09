//
//  ViewController.m
//  TwitterPocetak
//
//  Created by Stefan on 11/20/16.
//  Copyright © 2016 Stefan. All rights reserved.
//

#import "ViewController.h"
#import "Social/Social.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;

- (void) configureTweetTextView;
- (void) showAlertMessage: (NSString *) myMessage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTweetTextView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showAlertMessage: (NSString *) myMessage{
    UIAlertController *alertController;
    alertController = [UIAlertController alertControllerWithTitle:@"SocialSHare" message:myMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelMessage = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:cancelMessage];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)showShareAction:(id)sender {
   // ovako se gasi tastatura kada kliknemo na share dugme recimo
    if([self.tweetTextView isFirstResponder])
        [self.tweetTextView resignFirstResponder];
    
        UIAlertController *actionController = [UIAlertController alertControllerWithTitle:@"Share" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    // napravi se cancel dugme na postavljanju tweeta da mi mogli da ugasimo
    // actionController i ponistimo tweet, a tweet action nam dozvoljana da saljemo
    // dalje poruku na twitter
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction *tweetAction = [UIAlertAction actionWithTitle:@"Tweet" style:UIAlertActionStyleDefault handler:
        ^(UIAlertAction *action){
            // provera da li je korisnik ulogovan, a mora da se uloguje u settings
            if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
                
                // ovo pravi novi popup, da korisnik moze da edituje text jos jednom
                // pre nego sto ga posalje
                SLComposeViewController *twitterViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                
                // posalji tweet
                if([self.tweetTextView.text length] < 140)
                    [twitterViewController setInitialText: self.tweetTextView.text];
                else{
                    NSString *shortText = [self.tweetTextView.text substringToIndex:140];
                    [twitterViewController setInitialText:shortText];
                }
                // poziva twitterViewController, gde zapravo mozemo da postujemo na twitter
                // prvih 140 karakter koje smo ispisali
                [self presentViewController:twitterViewController animated:YES completion:nil];
            }
            else{
                // pozove showAlertMessage i izbaci gresku ukoliko nije
                [self showAlertMessage:@"You are not signed in to Twitter"];
            }
        }];
    
    UIAlertAction *facebookAction = [UIAlertAction actionWithTitle:@"Post to Facebook" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
            SLComposeViewController *facebookViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            NSString *faceText = self.tweetTextView.text;
            [facebookViewController setInitialText:faceText];
            [self presentViewController:facebookViewController animated:YES completion:nil];
        }
        else{
            [self showAlertMessage:@"Please sign into Facebook"];
        }
    }];
    
    // future proof, tj pravimo action tako da moze da se poveze lako na bilo koju
    // social mrezu koja bude napravljena ili tako nesto, to je ono more
    // kad ima u aplikaciji kad pise da moze da se klikne
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"More" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        // inicijalziujemo samo za tekst, ali ako nam treba mozemo u niz staviti
        // i za slike itd sta vec sve tu moze da se sheruje
        UIActivityViewController *moreViewController = [[UIActivityViewController alloc]  initWithActivityItems:@[self.tweetTextView.text] applicationActivities:nil];
        
        [self presentViewController:moreViewController animated:YES completion:nil];
    }];
    
    
    [actionController addAction:tweetAction];
    [actionController addAction:facebookAction];
    [actionController addAction:moreAction];
    [actionController addAction:cancelAction];
    
    // da ne prikazujemo viewcontroller nego da ide direkt na twitter, ili na face
    // znaci izbacuje viewcontroller sto je fina rabota
    // samo stavimo sledecu linju u komentar i gore ovaj deo koda iz handler
    // prebacimo odmah posle provere za za tastaturu
    [self presentViewController:actionController animated:YES completion:nil];
}

- (void) configureTweetTextView{
    self.tweetTextView.layer.backgroundColor =
    [UIColor colorWithRed: 1.0 green:1.0 blue:0.9 alpha:1.0].CGColor;
    
    self.tweetTextView.layer.cornerRadius = 10;
    self.tweetTextView.layer.borderColor =
    [UIColor colorWithWhite:0 alpha:0.5].CGColor;
     
     self.tweetTextView.layer.borderWidth = 2.0;
    
}

@end
