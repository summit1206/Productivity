#import "TBListsViewController.h"
@interface TBListsViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem* backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem* addListButton;
@property (strong, nonatomic) IBOutlet UITableView* listTable;
@property (strong, nonatomic) NSMutableArray* lists;
@property (assign, nonatomic) BOOL alertShowing;
@end
@implementation TBListsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupActions];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [_listTable reloadData];
}
- (void)setListSource:(NSMutableArray*)lists {
    _lists = lists;
}
- (void)setupActions {
    [_backButton setTarget:self];
    [_backButton setAction:@selector(backButtonPress:)];
    [_addListButton setTarget:self];
    [_addListButton setAction:@selector(addListButtonPress:)];
}
- (void)backButtonPress:(UIBarButtonItem*)sender {
    [TBScreenManager back:self];
}
- (void)addListButtonPress:(UIBarButtonItem*)sender {
    [TBScreenManager showModal:@"addListNavigationController" from:self withSetup:^(UINavigationController* navigationController) {
        TBCreateListViewController* addListViewController = [navigationController.viewControllers firstObject];
        addListViewController.previousViewController = self;
    }];
}
- (void)listButtonTapGesture:(UITapGestureRecognizer*)sender {
    if (_alertShowing) {
        return;
    }
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    UIView* contentView = [sender.view superview];
    NSInteger listIndex = contentView.tag;
    TBList* list = [_lists objectAtIndex:listIndex];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:list.listName message:@"List" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        _alertShowing = NO;
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
    _alertShowing = YES;
}
- (void)listButtonLongPressGesture:(UILongPressGestureRecognizer*)sender {
    if (_alertShowing) {
        return;
    }
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    UIView* contentView = [sender.view superview];
    NSInteger listIndex = contentView.tag;
    TBList* list = [_lists objectAtIndex:listIndex];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:list.listName message:@"Done with this list?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        UIView* contentView = [sender.view superview];
        [UIView animateWithDuration:0.25 animations:^{
            [contentView setAlpha:0.0];
        } completion:^(BOOL complete){
            [_lists removeObjectAtIndex:listIndex];
            [_listTable reloadData];
            _alertShowing = NO;
        }];
    }];
    UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction* action){
        _alertShowing = NO;
    }];
    [alert addAction:yesAction];
    [alert addAction:noAction];
    [self presentViewController:alert animated:YES completion:nil];
    _alertShowing = YES;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [_lists count];
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    UITableViewCell* cell = [_listTable dequeueReusableCellWithIdentifier:@"listCell"];
    TBList* list = [_lists objectAtIndex:indexPath.row];
    UILabel* listName = [cell.contentView.subviews objectAtIndex:0];
    listName.text = list.listName;
    [self setupButtonForCell:cell withList:list];
    [cell.contentView setAlpha:1.0];
    [cell.contentView setTag:indexPath.row];
    return cell;
}
- (void)setupButtonForCell:(UITableViewCell*)cell withList:(TBList*)list {
    UIGestureRecognizer* listButtonTapGesture = [[UITapGestureRecognizer alloc] init];
    [listButtonTapGesture addTarget:self action:@selector(listButtonTapGesture:)];
    UIGestureRecognizer* listButtonLongPressGesture = [[UILongPressGestureRecognizer alloc] init];
    [listButtonLongPressGesture addTarget:self action:@selector(listButtonLongPressGesture:)];
    UIButton* taskButton = [cell.contentView.subviews objectAtIndex:1];
    [taskButton addGestureRecognizer:listButtonTapGesture];
    [taskButton addGestureRecognizer:listButtonLongPressGesture];
}
- (void)addList:(TBList*)list {
    [_lists addObject:list];
}
@end
