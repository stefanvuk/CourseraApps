//
//  ViewController.m
//  UnitConvertor
//
//  Created by Stefan on 10/26/16.
//  Copyright © 2016 Stefan. All rights reserved.
//

#import "ViewController.h"

long convertBinarytoDecimal(long binary){
    long decimalNumber = 0, i = 0, remainder;
    
    while(binary!=0){
        remainder = binary % 10;
        binary = binary / 10;
        decimalNumber += remainder*pow(2, i);
        ++i;
    }
    
    return decimalNumber;
}

long convertBinarytoHexadecimalAndOctal(long binary){
    long Number = 0, i = 1, remainder;
    
    while(binary!=0){
        remainder = binary % 10;
        Number = Number + remainder * i;
        i = i * 2;
        binary = binary / 10;
    }
    
    return Number;
}

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *inputField;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentController;

@property (weak, nonatomic) IBOutlet UILabel *outputField;

@end

@implementation ViewController

- (IBAction)updateButton:(id)sender {
    NSString *text;
    long binary = [self.inputField.text longLongValue];
    
    if(self.segmentController.selectedSegmentIndex == 0){
        long octal = convertBinarytoHexadecimalAndOctal(binary);
        text = [NSString stringWithFormat: @"%lo", octal];
    }
    else if(self.segmentController.selectedSegmentIndex == 1){
        long decimal = convertBinarytoDecimal(binary);
        text = [NSString stringWithFormat: @"%ld", decimal];
    }
    else{
        long hexaDecimal = convertBinarytoHexadecimalAndOctal(binary);
        text = [NSString stringWithFormat: @"%lx", hexaDecimal];
    }

    self.outputField.text = text;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
