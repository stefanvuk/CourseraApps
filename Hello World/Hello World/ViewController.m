//
//  ViewController.m
//  Hello World
//
//  Created by Stefan on 10/23/16.
//  Copyright © 2016 Stefan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *testLabel;

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
- (IBAction)testButton:(id)sender {
    self.testLabel.text = @"It Worked!";
}


@end
