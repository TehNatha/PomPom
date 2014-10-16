//
//  LRSViewController.m
//  PomPom
//
//  Created by Nathan Stier on 4/30/14.
//  Copyright (c) 2014 LonelyRobotStudio. All rights reserved.
//

#import "LRSViewController.h"

@interface LRSViewController ()

@property (strong, nonatomic) NSMutableDictionary *tasks;
@property (strong, nonatomic) NSString *currentTask;
@property (nonatomic) int seconds;

@property (weak, nonatomic) IBOutlet UIPickerView *taskList;
@property (weak, nonatomic) IBOutlet UIProgressView *timeBar;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITextField *task;
@property (weak, nonatomic) IBOutlet UILabel *pomLabel;
@property (weak, nonatomic) IBOutlet UIButton *remove;

- (IBAction)addNewTask;
- (IBAction)removeCurrentTask;
- (IBAction)startTimer;

- (void) second:(NSTimer *) timer;

- (void) setPomLabelTextWithInt:(int)poms;
- (void) setPomLabelTextWithNSNumber:(NSNumber *)poms;
- (void) setPomLabelTextWithTask:(NSString *)task;
- (void) refresh;
- (void) lock;

// Impliments UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

// Impliments UIPickerViewDelegate
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component;
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;


@end

@implementation LRSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if (self) {
        self.tasks = [[NSMutableDictionary alloc] init];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addNewTask {
    [self.tasks setObject:@0 forKey:self.task.text];
    self.task.text = @"";
    [self refresh];
}

- (IBAction)removeCurrentTask {
    [self.tasks removeObjectForKey:self.currentTask];
    [self refresh];
}

- (IBAction)startTimer {
    if (self.currentTask) {
        self.seconds = 0;
        self.timeLabel.text = @"00:00";
        self.timeBar.progress = 0;
        [self lock];
        NSTimer *seconds = [NSTimer timerWithTimeInterval:.01
                                               target:self
                                             selector:@selector(second:)
                                             userInfo:nil
                                              repeats:YES];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addTimer:seconds forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.tasks.count;
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component {
    return self.tasks.allKeys[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component {
    self.currentTask = self.tasks.allKeys[row];
    [self setPomLabelTextWithTask:self.currentTask];
}

- (void) second:(NSTimer *)timer {
    self.seconds++;
    self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", self.seconds / 60, self.seconds % 60];
    self.timeBar.progress += ((float)1/25)/60;
    if (self.seconds >= 1500) {
        [timer invalidate];NSNumber *taskPoms = [self.tasks objectForKey:self.currentTask];
        taskPoms = [NSNumber numberWithInteger:taskPoms.intValue + 1];
        [self.tasks setObject:taskPoms forKey:self.currentTask];
        [self refresh];
        [self unlock];
    }
}

- (void) refresh {
    [self.taskList reloadAllComponents];
    self.currentTask = self.tasks.allKeys[[self.taskList selectedRowInComponent:0]];
    [self setPomLabelTextWithTask:self.currentTask];
    
}

- (void) lock {
    [self.taskList setUserInteractionEnabled:NO];
    [self.task setUserInteractionEnabled:NO];
    [self.remove setUserInteractionEnabled:NO];
}

- (void) unlock {
    [self.taskList setUserInteractionEnabled:YES];
    [self.task setUserInteractionEnabled:YES];
    [self.remove setUserInteractionEnabled:YES];
}

- (void) setPomLabelTextWithInt:(int)poms {
    NSArray *tomatoes = @[
                          @"",
                          @"🍅",
                          @"🍅🍅",
                          @"🍅🍅🍅",
                          @"🍅🍅🍅🍅",
                          @"🍅🍅🍅🍅🍅",
                          @"🍅🍅🍅🍅🍅🍅",
                          @"🍅🍅🍅🍅🍅🍅🍅",
                          @"🍅🍅🍅🍅🍅🍅🍅🍅",
                          @"🍅🍅🍅🍅🍅🍅🍅🍅🍅",
                          @"🍅🍅🍅🍅🍅🍅🍅🍅🍅🍅",
                          @"🍅🍅🍅🍅🍅🍅🍅🍅🍅🍅🍅",
                          @"🍅🍅🍅🍅🍅🍅🍅🍅🍅🍅🍅🍅"
                          ];
    self.pomLabel.text = tomatoes[poms];
}

- (void) setPomLabelTextWithNSNumber:(NSNumber *)poms {
    [self setPomLabelTextWithInt:[poms intValue]];
}

- (void) setPomLabelTextWithTask:(NSString *)task {
    [self setPomLabelTextWithNSNumber:[self.tasks objectForKey:task]];
}

@end
