#import "TBMenuViewController.h"
@interface TBMenuViewController ()
@property (weak, nonatomic) IBOutlet UILabel* messageLabel;
@property (weak, nonatomic) IBOutlet UIButton* timerButton;
@property (weak, nonatomic) IBOutlet UIButton* tasksButton;
@property (weak, nonatomic) IBOutlet UIButton* listsButton;
@property (weak, nonatomic) IBOutlet UIButton* settingsButton;
@property (strong, nonatomic) NSArray* greetings;
@property (assign, nonatomic) BOOL firstTimeOnScreen;
@end
@implementation TBMenuViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeProperties];
    [self setupActions];
    [self formatButtons];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    if (!(TBDataManager.instance.userName)) {
        [self askForUserName];
    }
    [self createMessage];
}
- (void)initializeProperties {
    _firstTimeOnScreen = YES;
    _greetings = @[@"Always get plenty of sleep.",
                   @"A sharp mind is a happy mind.",
                   @"If you stay determined, there is nothing you cannot accomplish.",
                   @"Take a minute to look outside. Even if it's raining.",
                   @"If you can find just one thing to make you happy, you can be truly happy about anything."];
}
- (void)setupActions {
    [_timerButton addTarget:self action:@selector(timerButtonPress:) forControlEvents:UIControlEventTouchDown];
    [_tasksButton addTarget:self action:@selector(tasksButtonPress:) forControlEvents:UIControlEventTouchDown];
    [_listsButton addTarget:self action:@selector(listsButtonPress:) forControlEvents:UIControlEventTouchDown];
    [_settingsButton addTarget:self action:@selector(settingsButtonPress:) forControlEvents:UIControlEventTouchDown];
}
-(void)formatButtons {
    [_timerButton.layer setCornerRadius:10];
    _timerButton.clipsToBounds = YES;
    [_tasksButton.layer setCornerRadius:10];
    _tasksButton.clipsToBounds = YES;
    [_listsButton.layer setCornerRadius:10];
    _listsButton.clipsToBounds = YES;
    [_settingsButton.layer setCornerRadius:10];
    _settingsButton.clipsToBounds = YES;
}
-(void)timerButtonPress:(UIButton*)sender {
    [TBScreenManager showScreen:@"timerViewController" from:self withSetup:nil];
}
-(void)tasksButtonPress:(UIButton*)sender {
    [TBScreenManager showScreen:@"taskListViewController" from:self withSetup:^(UIViewController* viewController) {
        TBTaskListViewController* taskListViewController = (TBTaskListViewController*)viewController;
        taskListViewController.title = @"Tasks";
        [taskListViewController setTaskSource:TBDataManager.instance.tasks groupSource:TBDataManager.instance.taskGroups];
    }];
}
-(void)listsButtonPress:(UIButton*)sender {
    [TBScreenManager showScreen:@"listsViewController" from:self withSetup:^(UIViewController* viewController) {
        TBListsViewController* listsViewController = (TBListsViewController*)viewController;
        [listsViewController setListSource:TBDataManager.instance.lists];
    }];
}
-(void)settingsButtonPress:(UIButton*)sender {
    [TBScreenManager showScreen:@"settingsViewController" from:self withSetup:nil];
}
- (void)askForUserName {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Productivity App" message:@"What is your name?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField* textField){
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    }];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        UITextField* textField = [alert.textFields objectAtIndex:0];
        TBDataManager.instance.userName = textField.text;
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)createMessage {
    if (_firstTimeOnScreen) {
        if ((TBDataManager.instance.userName)) {
            _messageLabel.text = [NSString stringWithFormat:@"Welcome back, %@!", TBDataManager.instance.userName];
            _firstTimeOnScreen = NO;
        } else {
            _messageLabel.text = @"Welcome!";
            _firstTimeOnScreen = NO;
        }
    } else {
        NSInteger randomNum = arc4random() % _greetings.count;
        _messageLabel.text = [_greetings objectAtIndex:randomNum];
    }
}
@end
