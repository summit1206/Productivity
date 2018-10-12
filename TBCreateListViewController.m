#import "TBCreateListViewController.h"
@interface TBCreateListViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem* cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem* createButton;
@property (strong, nonatomic) IBOutlet UITableView* listTable;
@property (copy, nonatomic) NSMutableArray* listItems;
@end
@implementation TBCreateListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeProperties];
    [self setupActions];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [_listTable reloadData];
}
- (void)initializeProperties {
    _listItems = [[NSMutableArray alloc] init];
}
- (void)setupActions {
    [_cancelButton setTarget:self];
    [_cancelButton setAction:@selector(cancelButtonPress:)];
    [_createButton setTarget:self];
    [_createButton setAction:@selector(createButtonPress:)];
}
- (void)cancelButtonPress:(UIBarButtonItem*)sender {
    [TBScreenManager dismissModal:self];
}
- (void)createButtonPress:(UIBarButtonItem*)sender {
    if ([_listItems count] > 0) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Productivity" message:@"please enter the list name?" preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField* textField){
            textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        }];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
            UITextField* textField = [alert.textFields objectAtIndex:0];
            TBList* list = [[TBList alloc] initWithName:textField.text];
            list.listItems = _listItems;
            TBListsViewController* listsViewController = (TBListsViewController*)_previousViewController;
            [listsViewController addList:list];
            [TBScreenManager dismissModal:self];
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
- (void)addItemButtonTapGesture:(UITapGestureRecognizer*)sender {
    UITextField* addItemTextField = [sender.view.superview.subviews objectAtIndex:1];
    if (![addItemTextField isFirstResponder]) {
        [addItemTextField setHidden:NO];
        [addItemTextField becomeFirstResponder];
    } else {
        if (![addItemTextField.text isEqual:@""]) {
            [_listItems addObject:addItemTextField.text];
        }
        [addItemTextField resignFirstResponder];
        [_listTable reloadData];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    if (![textField.text isEqual:@""]) {
        [_listItems addObject:textField.text];
    }
    [textField resignFirstResponder];
    [_listTable reloadData];
    return YES;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [_listItems count] + 1;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    UITableViewCell* cell;
    if (indexPath.row < [_listItems count]) {
        cell = [_listTable dequeueReusableCellWithIdentifier:@"listItemCell"];
        UILabel* listItemName = [cell.contentView.subviews objectAtIndex:0];
        listItemName.text = [_listItems objectAtIndex:indexPath.row];
    } else {
        cell = [_listTable dequeueReusableCellWithIdentifier:@"addItemCell"];
        UITextField* addItemTextField = [cell.contentView.subviews objectAtIndex:1];
        addItemTextField.delegate = self;
        addItemTextField.text = @"";
        [addItemTextField setHidden:YES];
        [self setupButtonForCell:cell];
    }
    return cell;
}
- (void)setupButtonForCell:(UITableViewCell*)cell {
    UIGestureRecognizer* addItemButtonTapGesture = [[UITapGestureRecognizer alloc] init];
    [addItemButtonTapGesture addTarget:self action:@selector(addItemButtonTapGesture:)];
    UIButton* addItemButton = [cell.contentView.subviews objectAtIndex:2];
    [addItemButton addGestureRecognizer:addItemButtonTapGesture];
}
@end
