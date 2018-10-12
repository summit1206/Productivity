#import "TBCreateTaskViewController.h"
@interface TBCreateTaskViewController ()
@property (strong, nonatomic) IBOutlet UIView* background;
@property (weak, nonatomic) IBOutlet UIBarButtonItem* cancelButton;
@property (weak, nonatomic) IBOutlet UITextField* taskNameField;
@property (weak, nonatomic) IBOutlet UITextView* descriptionField;
@property (weak, nonatomic) IBOutlet UIPickerView* timeEstimatePicker;
@property (weak, nonatomic) IBOutlet UILabel* timeUnitsLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker* dueDatePicker;
@property (weak, nonatomic) IBOutlet UIButton* addTaskButton;
@property (strong, nonatomic) NSArray* timeIntervals;
@end
@implementation TBCreateTaskViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeProperties];
    [self initializePicker];
    [self setupActions];
    [self setupGestureRecognizers];
    [self setupTextView];
}
- (void)initializeProperties {
    _timeIntervals = @[@"5", @"10", @"15", @"20", @"30", @"45", @"1", @"2", @"4", @"8", @"12"];
}
- (void)initializePicker {
    _timeEstimatePicker.delegate = self;
    _timeEstimatePicker.dataSource = self;
    [_timeEstimatePicker selectRow:6 inComponent:0 animated:NO];
}
- (void)setupActions {
    [_cancelButton setTarget:self];
    [_cancelButton setAction:@selector(cancelButtonPress:)];
    [_addTaskButton addTarget:self action:@selector(addTaskButtonPress:) forControlEvents:UIControlEventTouchDown];
    [_taskNameField setDelegate:self];
}
- (void)setupGestureRecognizers {
    UITapGestureRecognizer* backgroundTapGesture = [[UITapGestureRecognizer alloc] init];
    [backgroundTapGesture addTarget:self action:@selector(backgroundTapGesture:)];
    [_background addGestureRecognizer:backgroundTapGesture];
}
- (void)setupTextView {
    [_descriptionField.layer setBorderColor:[UIColor grayColor].CGColor];
    [_descriptionField.layer setBorderWidth:0.25];
    [_descriptionField.layer setCornerRadius:10];
}
- (void)cancelButtonPress:(UIBarButtonItem*)sender {
    [_taskNameField resignFirstResponder];
    [_descriptionField resignFirstResponder];
    [TBScreenManager dismissModal:self];
}
- (void)addTaskButtonPress:(UIButton*)sender {
    if ([_taskNameField hasText]) {
        [_taskNameField resignFirstResponder];
        [_descriptionField resignFirstResponder];
        TBTask* task = [[TBTask alloc] initWithName:_taskNameField.text
                                        description:_descriptionField.text
                                       timeEstimate:[self getTimeEstimatePickerValue]
                                          timeUnits:_timeUnitsLabel.text
                                            dueDate:_dueDatePicker.date];
        TBTaskListViewController* taskListViewController = (TBTaskListViewController*)_previousViewController;
        [taskListViewController addTask:task];
        [TBScreenManager dismissModal:self];
    }
}
- (void)backgroundTapGesture:(UITapGestureRecognizer*)sender {
    [_taskNameField resignFirstResponder];
    [_descriptionField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    [textField resignFirstResponder];
    return YES;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_timeIntervals count];
}
- (NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_timeIntervals objectAtIndex:row];
}
- (void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row > 5) {
        _timeUnitsLabel.text = @"hr";
    } else {
        _timeUnitsLabel.text = @"min";
    }
}
- (NSInteger)getTimeEstimatePickerValue {
    NSInteger selectedRow = [_timeEstimatePicker selectedRowInComponent:0];
    return [_timeIntervals[selectedRow] integerValue];
}
@end
