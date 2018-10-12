#import "TBTimerViewController.h"
@interface TBTimerViewController ()
@property (strong, nonatomic) IBOutlet UIView *background;
@property (weak, nonatomic) IBOutlet UIBarButtonItem* backButton;
@property (weak, nonatomic) IBOutlet UILabel* messageLabel;
@property (weak, nonatomic) IBOutlet UILabel* timerLabel;
@property (weak, nonatomic) IBOutlet UIButton* timerControlButton;
@property (weak, nonatomic) IBOutlet UILabel* workTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel* shortBreakLabel;
@property (weak, nonatomic) IBOutlet UILabel* longBreakLabel;
@property (weak, nonatomic) IBOutlet UILabel *cycleLengthLabel;
@property (weak, nonatomic) IBOutlet UISlider* workTimeSlider;
@property (weak, nonatomic) IBOutlet UISlider* shortBreakSlider;
@property (weak, nonatomic) IBOutlet UISlider* longBreakSlider;
@property (weak, nonatomic) IBOutlet UISlider *cycleLengthSlider;
@property (strong, nonatomic) NSTimer* timer;
@property (assign, nonatomic) NSInteger time;
@property (assign, nonatomic) TimerState timerState;
@property (assign, nonatomic) NSInteger numberOfCycles;
@end
@implementation TBTimerViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupActions];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self initializeProperties];
}
- (void)initializeProperties {
    _time = 0;
    _timerState = ON;
    _numberOfCycles = 0;
}
- (void)setupActions {
    [_backButton setTarget:self];
    [_backButton setAction:@selector(backButtonPress:)];
    [_timerControlButton addTarget:self action:@selector(timerControlButtonPress:)
                              forControlEvents:UIControlEventTouchDown];
    [_workTimeSlider addTarget:self action:@selector(workTimeSliderValueChange:)
                          forControlEvents:UIControlEventValueChanged];
    [_shortBreakSlider addTarget:self action:@selector(shortBreakSliderValueChange:)
                            forControlEvents:UIControlEventValueChanged];
    [_longBreakSlider addTarget:self action:@selector(longBreakSliderValueChange:)
                           forControlEvents:UIControlEventValueChanged];
    [_cycleLengthSlider addTarget:self action:@selector(cycleLengthSliderValueChange:)
                 forControlEvents:UIControlEventValueChanged];
}
- (void)backButtonPress:(UIBarButtonItem*)sender {
    [TBScreenManager back:self];
}
- (void)timerControlButtonPress:(UIButton*)sender {
    if ([sender.currentTitle isEqual:@"Start Timer"]) {
        [self startTimer];
    } else {
        [self stopTimer];
    }
}
- (void)workTimeSliderValueChange:(UISlider*)sender {
    _workTimeLabel.text = [NSString stringWithFormat:@"Work Time: %ld min", (long)sender.value];
}
- (void)shortBreakSliderValueChange:(UISlider*)sender {
    _shortBreakLabel.text = [NSString stringWithFormat:@"Short Break: %ld min", (long)sender.value];
}
- (void)longBreakSliderValueChange:(UISlider*)sender {
    _longBreakLabel.text = [NSString stringWithFormat:@"Long Break: %ld min", (long)sender.value];
}
- (void)cycleLengthSliderValueChange:(UISlider*)sender {
    _cycleLengthLabel.text = [NSString stringWithFormat:@"Cycle Length: %ld", (long)sender.value];
}
- (void)startTimer {
    if ((_workTimeSlider.value > 0) && (_shortBreakSlider.value > 0) && (_longBreakSlider.value > 0)) {
        _time = (NSInteger)_workTimeSlider.value * 60;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self
                  selector:@selector(updateTimer) userInfo:nil repeats:YES];
        _timerState = ON;
        _timerLabel.text = [self formatMinSecTime:_time];
        [_timerControlButton setTitle:@"Cancel Timer" forState:normal];
        _messageLabel.text = @"Get to Work!";
        [self disableControls];
        [UIApplication.sharedApplication setIdleTimerDisabled:YES];
    }
}
- (void)stopTimer {
    [_timer invalidate];
    _timer = nil;
    _timerLabel.text = @"00:00";
    [_timerControlButton setTitle:@"Start Timer" forState:normal];
    _messageLabel.text = @"Start Timer When Ready";
    _numberOfCycles = 0;
    [self enableControls];
    [UIApplication.sharedApplication setIdleTimerDisabled:NO];
}
- (void)updateTimer {
    _time -= 1;
    [self checkTimerFinished];
    _timerLabel.text = [self formatMinSecTime:_time];
}
- (NSString*)formatMinSecTime:(NSInteger)time {
    NSInteger minutes = time / 60 % 60;
    NSInteger seconds = time % 60;
    return [NSString stringWithFormat:@"%2ld:%02ld", (long)minutes, (long)seconds];
}
- (void)checkTimerFinished {
    if (_time == 0) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        if (_timerState == ON) {
            _numberOfCycles += 1;
            if (_numberOfCycles >= _cycleLengthSlider.value) {
                _time = (NSInteger)_longBreakSlider.value * 60;
                _numberOfCycles = 0;
            } else {
                _time = (NSInteger)_shortBreakSlider.value * 60;
            }
            _timerState = OFF;
            _messageLabel.text = @"Take a Break";
        } else {
            _time = (NSInteger)_workTimeSlider.value * 60;
            _timerState = ON;
            _messageLabel.text = @"Get to Work!";
        }
    }
}
- (void)disableControls {
    [_workTimeSlider setUserInteractionEnabled:NO];
    [_shortBreakSlider setUserInteractionEnabled:NO];
    [_longBreakSlider setUserInteractionEnabled:NO];
    [_cycleLengthSlider setUserInteractionEnabled:NO];
}
- (void)enableControls {
    [_workTimeSlider setUserInteractionEnabled:YES];
    [_shortBreakSlider setUserInteractionEnabled:YES];
    [_longBreakSlider setUserInteractionEnabled:YES];
    [_cycleLengthSlider setUserInteractionEnabled:YES];
}
@end
