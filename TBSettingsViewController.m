#import "TBSettingsViewController.h"
#import "TBDataManager.h"
@interface TBSettingsViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem* backButton;
- (IBAction)ChangeYourNameAction:(id)sender;
@end
@implementation TBSettingsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupActions];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
}
- (void)setupActions {
    [_backButton setTarget:self];
    [_backButton setAction:@selector(backButtonPress:)];
}
- (void)backButtonPress:(UIBarButtonItem*)sender {
    [TBScreenManager back:self];
}
- (IBAction)ChangeYourNameAction:(id)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Productivity App" message:@"please enter your new name?" preferredStyle:UIAlertControllerStyleAlert];
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
@end
