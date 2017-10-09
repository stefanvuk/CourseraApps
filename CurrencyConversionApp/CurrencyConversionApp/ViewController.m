//
//  ViewController.m
//  CurrencyConversionApp
//
//  Created by Stefan on 10/31/16.
//  Copyright © 2016 Stefan. All rights reserved.
//

#import "ViewController.h"
#import "CurrencyRequest/CRCurrencyrequest.h"
#import "CurrencyRequest/CRCurrencyResults.h"



@interface ViewController () <CRCurrencyRequestDelegate>

@property (nonatomic) CRCurrencyRequest *req;
@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UIButton *convertButton;
@property (weak, nonatomic) IBOutlet UILabel *currencyA;
@property (weak, nonatomic) IBOutlet UILabel *currencyB;
@property (weak, nonatomic) IBOutlet UILabel *currencyC;

@end



@implementation ViewController

- (IBAction)buttonTapped:(id)sender {
    self.convertButton.enabled = NO;
    
    self.req = [[CRCurrencyRequest alloc] init];
    self.req.delegate = self;
    [self.req start];
}

- (void)currencyRequest:(CRCurrencyRequest *)req
    retrievedCurrencies:(CRCurrencyResults *)currencies{
 
    self.convertButton.enabled = YES;
    
    double inputValue = [self.inputField.text floatValue];
    double eurValue = inputValue * currencies.EUR;
    double czkValue = inputValue * currencies.CZK;
    double chfValue = inputValue * currencies.CHF;
    
    NSString *eur = [NSString stringWithFormat: @"%.2f", eurValue];
    NSString *czk = [NSString stringWithFormat: @"%.2f", czkValue];
    NSString *chf = [NSString stringWithFormat: @"%.2f", chfValue];
    
    self.currencyA.text = eur;
    self.currencyB.text = czk;
    self.currencyC.text = chf;
    
}


@end
