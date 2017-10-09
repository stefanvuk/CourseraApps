//
//  ViewController.m
//  TableViewDemo
//
//  Created by Stefan on 1/12/17.
//  Copyright © 2017 Stefan. All rights reserved.
//

#import "ViewController.h"
#import "MyCellTableViewCell.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *ourStrings;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ourStrings = [NSMutableArray arrayWithArray:@[@"The first row!", @"More data!"]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

    // prvi bag, sortira prva dva vec postojana elementa zasebno, i onda zasebno ovde koje posle unosim
    // resenje je da beginUpdates i endUpdates moraju biti unutar if, a ne na pocetku i kraju fje
- (IBAction)sortTapped:(id)sender {
    // zelimo da poredimo sa krajem zato necemo da krecemo od kraja tj. -1
    // nego od predzadnjeg elementa tj -2
    for(long i = [self.ourStrings count] - 2; i>=0; i--){
        // ovde sam omasio i zaboravio sam -1 i javljao je gresku:
        //Terminating app due to uncaught exception 'NSRangeException', reason: '*** -[__NSArrayM objectAtIndex:]: index 2 beyond bounds [0 .. 1]'
        // sto znaci da tableview ima vise elemenata od niza, ja mislim
        for(long j = i; j < [self.ourStrings count] - 1; j++){
            if([self.ourStrings[j] compare:self.ourStrings[j+1]] > 0){
                [self.tableView beginUpdates];
                
                // zameni elemente, insertion sort
                [self.ourStrings exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                
                NSIndexPath *firstIndex = [NSIndexPath indexPathForRow:j inSection:0];
                NSIndexPath *secondIndex = [NSIndexPath indexPathForRow:j+1 inSection:0];
                
                [self.tableView moveRowAtIndexPath:firstIndex toIndexPath:secondIndex];
                
                [self.tableView endUpdates];
            }
        }
    }

}

- (IBAction)addTapped:(id)sender {
    [self.tableView beginUpdates];
    // update data store
    [self.ourStrings addObject:self.textField.text];
    // ovde gledamo u koji red ubacujemo tekst
    NSInteger newRow = [self.ourStrings count] - 1;
    // pravimo novi indeks za taj red
    NSIndexPath *newIndex = [NSIndexPath indexPathForRow:newRow inSection:0];
    // ubacujemo to u tableview
    [self.tableView insertRowsAtIndexPaths:@[newIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self.tableView endUpdates];
}

# pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.ourStrings.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCellTableViewCell *cell = (MyCellTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"OurCell"forIndexPath:indexPath];

    
    
    cell.ourCellLabel.text = self.ourStrings[indexPath.row];
    
    return cell;
}









@end
