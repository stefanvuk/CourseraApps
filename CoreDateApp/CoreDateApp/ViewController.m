//
//  ViewController.m
//  CoreDateApp
//
//  Created by Stefan on 12/15/16.
//  Copyright © 2016 Stefan. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "ChoreMO+CoreDataClass.h"
#import "PersonMO+CoreDataClass.h"
#import "ChoreLogMO+CoreDataClass.h"

@interface ViewController ()

@property (nonatomic) AppDelegate *appDelegate;

@property (weak, nonatomic) IBOutlet UILabel *numberOfObjectsLabel;
@property (weak, nonatomic) IBOutlet UITextField *choreField;
@property (weak, nonatomic) IBOutlet UILabel *savedChoresLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    [self updateChoreList];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)choreTapped:(id)sender {
    
    ChoreMO * chore = [self.appDelegate createChoresMO];
    chore.chore_name = self.choreField.text;
    [self.appDelegate saveContext];
    [self updateChoreList];
}

- (IBAction)deleteTapped:(id)sender {
    
    NSManagedObjectContext *moc = self.appDelegate.persistentContainer.viewContext;
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Chore"];
    
    NSError *error = nil;
    NSArray *choreRecords = [moc executeFetchRequest:fetchRequest error:&error];
    if(!choreRecords || error != nil){
        NSLog(@"rx:updateChoreList: error fetching chores: %@", error);
        abort();
    }
    
    for(ChoreMO *chore in choreRecords){
        [moc deleteObject:chore];
    }
    
    [self.appDelegate saveContext];
    [self updateChoreList];

}

- (void) updateChoreList{
    
    NSArray *choreRecords = [self fetchChores];
    
    NSMutableString *buffer = [NSMutableString stringWithString:@""];
    for(ChoreMO *chore in choreRecords){
        [buffer appendFormat:@"\n%@", chore.chore_name, nil];
    }
    
    NSString *nrChores = [NSString stringWithFormat:@"%lu", [choreRecords count]];
    
    self.savedChoresLabel.text = buffer;
    self.numberOfObjectsLabel.text = nrChores;
}

- (NSArray *) fetchChores{
    
    NSManagedObjectContext *moc = self.appDelegate.persistentContainer.viewContext;
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Chore"];
    
    NSError *error = nil;
    NSArray *choreRecords = [moc executeFetchRequest:fetchRequest error:&error];
    
    if(!choreRecords || error != nil){
        NSLog(@"rx:updateChoreList: error fetching chores: %@", error);
        abort();
    }
    
    NSLog(@"rx:fetchChores: fetched %lu records", (unsigned long)[choreRecords count]);
    return choreRecords;
}























@end
