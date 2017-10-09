//
//  MyUIViewController.m
//  CoreDataToDo
//
//  Created by Stefan on 1/14/17.
//  Copyright © 2017 Stefan. All rights reserved.
//

#import "MyUIViewController.h"
#import "ToDoEntity+CoreDataClass.h"

@interface MyUIViewController ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) ToDoEntity *localToDoEntity;

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *detailsField;
@property (weak, nonatomic) IBOutlet UIDatePicker *dueDateField;

@property (nonatomic, assign) BOOL wasDeleted;

@end

@implementation MyUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) receiveMOC:(NSManagedObjectContext *)incomingMOC{
    self.managedObjectContext = incomingMOC;
}

- (void) receiveToDoEntity:(ToDoEntity *)incomingToDoEntity{
    self.localToDoEntity = incomingToDoEntity;
}

- (void) saveMyToDoEntity{
    NSError *err;
    BOOL saveSuccess = [self.managedObjectContext save:&err];
    if(!saveSuccess){
        @throw [NSException exceptionWithName:NSGenericException reason:@"Couldn`t save" userInfo:@{NSUnderlyingErrorKey:err}];
    }
}
// za cuvanje za textView, potrebno za deo fje u viewWillAppear
- (void) textViewDidEndEditing:(NSNotification *) notification{
    if([notification object] == self){
        self.localToDoEntity.toDoDetails = self.detailsField.text;
        [self saveMyToDoEntity];
    }
}
// brisanje to do elementa iz tabele
- (IBAction)trashTapped:(id)sender {
    self.wasDeleted = YES;
    [self.managedObjectContext deleteObject:self.localToDoEntity];
    [self saveMyToDoEntity];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) viewWillAppear:(BOOL)animated{
    // set up delete state
    self.wasDeleted = NO;
    // set up form, it is called just before the view appears
    self.titleField.text = self.localToDoEntity.toDoTitle;
    self.detailsField.text = self.localToDoEntity.toDoDetails;
    
    NSDate *dueDate = self.localToDoEntity.toDoDueDate;
    if(dueDate != nil){
        [self.dueDateField setDate:dueDate];
    }
    // detect edit ends of text views by notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:self];
}

- (void) viewWillDisappear:(BOOL)animated{
    // Save everything
    if(self.wasDeleted == NO){
        self.localToDoEntity.toDoTitle = self.titleField.text;
        self.localToDoEntity.toDoDetails = self.detailsField.text;
        self.localToDoEntity.toDoDueDate = self.dueDateField.date;
        [self saveMyToDoEntity];
    }
    // remove detection
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidEndEditingNotification object:self];
}

// textField i date su laki za cuvanje, textfield je malko tezi, nista strasno
- (IBAction)titleFieldEditted:(id)sender {
    self.localToDoEntity.toDoTitle = self.titleField.text;
    [self saveMyToDoEntity];
}

// samo poziv ove fje nije hteo da sacuva i da pokaze date,
// ponekad se nije pozivala fja, zato u viewWillDisappear dodajemo kod
// i cuvamo sva tri polja, onda pokazuje datum
- (IBAction)dueDateEditted:(id)sender {
    self.localToDoEntity.toDoDueDate = self.dueDateField.date;
    [self saveMyToDoEntity];
}


@end








