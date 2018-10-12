#import "TBTaskListViewController.h"
@interface TBTaskListViewController ()
@property (strong, nonatomic) IBOutlet UITableView* taskTable;
@property (weak, nonatomic) IBOutlet UIBarButtonItem* backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem* addTaskButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem* addGroupButton;
@property (strong, nonatomic) NSMutableArray* tasks;
@property (strong, nonatomic) NSMutableArray* taskGroups;
@property (assign, nonatomic) BOOL alertShowing;
@end
@implementation TBTaskListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupActions];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self initializeProperties];
    [_taskTable reloadData];
}
- (void)setTaskSource:(NSMutableArray*)tasks groupSource:(NSMutableArray*)groups {
    _tasks = tasks;
    _taskGroups = groups;
}
- (void)initializeProperties {
    _alertShowing = NO;
}
- (void)setupActions {
    [_backButton setTarget:self];
    [_backButton setAction:@selector(backButtonPress:)];
    [_addTaskButton setTarget:self];
    [_addTaskButton setAction:@selector(addTaskButtonPress:)];
    [_addGroupButton setTarget:self];
    [_addGroupButton setAction:@selector(addGroupButtonPress:)];
}
- (void)backButtonPress:(UIBarButtonItem*)sender {
    [TBScreenManager back:self];
}
- (void)addTaskButtonPress:(UIBarButtonItem*)sender {
    [TBScreenManager showModal:@"addTaskNavigationController" from:self withSetup:^(UINavigationController* navigationController) {
        TBCreateTaskViewController* addTaskViewController = [navigationController.viewControllers firstObject];
        addTaskViewController.previousViewController = self;
    }];
}
- (void)addGroupButtonPress:(UIBarButtonItem*)sender {
    if (_alertShowing) {
        return;
    }
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Create New Group" message:@"Enter group name:" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField* textField){
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    }];
    UIAlertAction* createAction = [UIAlertAction actionWithTitle:@"Create" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        UITextField* textField = [alert.textFields objectAtIndex:0];
        TBTaskGroup* taskGroup = [[TBTaskGroup alloc] initWithName:textField.text];
        [_taskGroups addObject:taskGroup];
        [_taskTable reloadData];
        _alertShowing = NO;
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction* action){
        _alertShowing = NO;
    }];
    [alert addAction:createAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    _alertShowing = YES;
}
- (void)taskButtonTapGesture:(UITapGestureRecognizer*)sender {
    if (_alertShowing) {
        return;
    }
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    UIView* contentView = [sender.view superview];
    NSInteger taskIndex = contentView.tag - [_taskGroups count];
    TBTask* task = [_tasks objectAtIndex:taskIndex];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:task.taskName message:task.taskDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        _alertShowing = NO;
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
    _alertShowing = YES;
}
- (void)taskButtonLongPressGesture:(UILongPressGestureRecognizer*)sender {
    if (_alertShowing) {
        return;
    }
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    UIView* contentView = [sender.view superview];
    NSInteger taskIndex = contentView.tag - [_taskGroups count];
    TBTask* task = [_tasks objectAtIndex:taskIndex];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:task.taskName message:@"Done with this task?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        UIView* contentView = [sender.view superview];
        [UIView animateWithDuration:0.25 animations:^{
            [contentView setAlpha:0.0];
        } completion:^(BOOL complete){
            [_tasks removeObjectAtIndex:taskIndex];
            [_taskTable reloadData];
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
- (void)groupButtonTapGesture:(UITapGestureRecognizer*)sender {
    [TBScreenManager showScreen:@"taskListViewController" from:self withSetup:^(UIViewController* viewController) {
        TBTaskListViewController* taskListViewController = (TBTaskListViewController*)viewController;
        TBTaskGroup* taskGroup = [_taskGroups objectAtIndex:sender.view.superview.tag];
        taskListViewController.title = taskGroup.groupName;
        [taskListViewController setTaskSource:taskGroup.tasks groupSource:taskGroup.taskGroups];
    }];
}
- (void)groupButtonLongPressGesture:(UILongPressGestureRecognizer*)sender {
    if (_alertShowing) {
        return;
    }
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    UIView* contentView = [sender.view superview];
    NSInteger groupIndex = contentView.tag;
    TBTaskGroup* taskGroup = [_taskGroups objectAtIndex:groupIndex];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:taskGroup.groupName message:@"Done with this group?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        UIView* contentView = [sender.view superview];
        [UIView animateWithDuration:0.25 animations:^{
            [contentView setAlpha:0.0];
        } completion:^(BOOL complete){
            [_taskGroups removeObjectAtIndex:groupIndex];
            [_taskTable reloadData];
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
    return [_taskGroups count] + [_tasks count];
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    UITableViewCell* cell;
    if (indexPath.row < [_taskGroups count]) {
        cell = [_taskTable dequeueReusableCellWithIdentifier:@"groupCell"];
        TBTaskGroup* taskGroup = [_taskGroups objectAtIndex:indexPath.row];
        [self setupTitleForCell:cell withGroup:taskGroup];
        [self setupButtonForCell:cell withGroup:taskGroup];
    } else {
        cell = [_taskTable dequeueReusableCellWithIdentifier:@"taskCell"];
        NSInteger taskIndex = indexPath.row - [_taskGroups count];
        TBTask* task = [_tasks objectAtIndex:taskIndex];
        [self setupTimeForCell:cell withTask:task];
        [self setupTitleForCell:cell withTask:task];
        [self setupDateForCell:cell withTask:task];
        [self setupButtonForCell:cell withTask:task];
    }
    [cell.contentView setAlpha:1.0];
    [cell.contentView setTag:indexPath.row];
    return cell;
}
- (void)setupTimeForCell:(UITableViewCell*)cell withTask:(TBTask*)task {
    UILabel* taskTime = [cell.contentView.subviews objectAtIndex:0];
    taskTime.text = [NSString stringWithFormat:@"%ld %@", (long)task.timeEstimate, task.timeUnits];
}
- (void)setupTitleForCell:(UITableViewCell*)cell withTask:(TBTask*)task {
    UILabel* taskTitle = [cell.contentView.subviews objectAtIndex:1];
    taskTitle.text = task.taskName;
}
- (void)setupTitleForCell:(UITableViewCell*)cell withGroup:(TBTaskGroup*)group {
    UILabel* groupTitle = [cell.contentView.subviews objectAtIndex:0];
    groupTitle.text = group.groupName;
}
- (void)setupDateForCell:(UITableViewCell*)cell withTask:(TBTask*)task {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    UILabel* taskDate = [cell.contentView.subviews objectAtIndex:2];
    taskDate.text = [NSString stringWithFormat:@"Due Before: %@", [dateFormatter stringFromDate:task.dueDate]];
}
- (void)setupButtonForCell:(UITableViewCell*)cell withTask:(TBTask*)task {
    UIGestureRecognizer* taskButtonTapGesture = [[UITapGestureRecognizer alloc] init];
    [taskButtonTapGesture addTarget:self action:@selector(taskButtonTapGesture:)];
    UIGestureRecognizer* taskButtonLongPressGesture = [[UILongPressGestureRecognizer alloc] init];
    [taskButtonLongPressGesture addTarget:self action:@selector(taskButtonLongPressGesture:)];
    UIButton* taskButton = [cell.contentView.subviews objectAtIndex:3];
    [taskButton addGestureRecognizer:taskButtonTapGesture];
    [taskButton addGestureRecognizer:taskButtonLongPressGesture];
}
- (void)setupButtonForCell:(UITableViewCell*)cell withGroup:(TBTaskGroup*)group {
    UIGestureRecognizer* taskButtonTapGesture = [[UITapGestureRecognizer alloc] init];
    [taskButtonTapGesture addTarget:self action:@selector(groupButtonTapGesture:)];
    UIGestureRecognizer* taskButtonLongPressGesture = [[UILongPressGestureRecognizer alloc] init];
    [taskButtonLongPressGesture addTarget:self action:@selector(groupButtonLongPressGesture:)];
    UIButton* groupButton = [cell.contentView.subviews objectAtIndex:1];
    [groupButton addGestureRecognizer:taskButtonTapGesture];
    [groupButton addGestureRecognizer:taskButtonLongPressGesture];
}
- (void)addTask:(TBTask*)task {
    [_tasks addObject:task];
}
@end
