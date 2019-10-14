//
//  DateSelectController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DateSelectController.h"

@interface DateSelectController ()
@property (nonatomic,readonly) NSDateFormatter *formatter;
@end

@implementation DateSelectController
@synthesize datePicker=_datePicker;
@synthesize timedatePicker=_timedatePicker;
@synthesize delegate=_delegate;
@synthesize datefrom=_datefrom;
@synthesize formatter=_formatter;
@synthesize dateselectPopover=_dateselectPopover;
//时间选择器类型标识，为0时只选择日期，为1时可选择日期和具体时间
@synthesize pickerType=_pickerType;

- (NSDateFormatter *)formatter{
    if (_formatter==nil) {
        _formatter=[[NSDateFormatter alloc] init];
        [_formatter setLocale:[NSLocale currentLocale]];
        if (_pickerType == 0) {
            [_formatter setDateFormat : @"yyyy-MM-dd"];
        } else if (_pickerType == 1) {
            [_formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        } else if (_pickerType == 2) {
            [_formatter setDateFormat:@"HH:mm"];
        }else{
        }
    }
    return _formatter;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad{
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated{
    [_timedatePicker setHidden:YES];
//    _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
//    _datePicker.calendar = [NSCalendar autoupdatingCurrentCalendar];
    [self.datePicker setCalendar:[NSCalendar currentCalendar]];
    if (_pickerType==0) {
        _datePicker.datePickerMode=UIDatePickerModeDate;
        [_datePicker setTimeZone:[NSTimeZone localTimeZone]];
    } else if (_pickerType==1) {
        _datePicker.datePickerMode= UIDatePickerModeDate;
        [_timedatePicker setHidden:NO];
//        _timedatePicker.datePickerMode = UIDatePickerModeCountDownTimer;
        [_datePicker setTimeZone:[NSTimeZone localTimeZone]];
        [_timedatePicker setTimeZone:[NSTimeZone localTimeZone]];
        [_datePicker setFrame:CGRectMake(5, 0, self.view.frame.size.width/12*9, self.view.frame.size.height)];
        [_timedatePicker setFrame:CGRectMake(self.view.frame.size.width/3*2-10, 0, self.view.frame.size.width/3+5, self.view.frame.size.height)];
        
    }else if(_pickerType == 2){
        _datePicker.datePickerMode=UIDatePickerModeTime;
        [_datePicker setTimeZone:[NSTimeZone localTimeZone]];
    }
    if ([self.datefrom isEmpty]){
        NSDate *datenew=[NSDate date];
        [self.datePicker setDate:datenew];
    }else{
        NSDate *dateTime = [self.formatter dateFromString:_datefrom];
        if (dateTime==nil) {
            dateTime=[NSDate date];
        }
        [self.datePicker setDate:dateTime];
    }
    if (self.pastDate) {
        [self.datePicker setDate:self.pastDate];
    }
    [super viewWillAppear:animated];
}
- (void)viewDidUnload{
    [self setDatePicker:nil];
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}
- (IBAction)btnSave:(id)sender {
    if (_pickerType==1){
        NSDateFormatter * tmpformatter =  [[NSDateFormatter alloc] init];
        [tmpformatter setDateFormat:@"yyyy-MM-dd"];
        NSString * datestr1 = [tmpformatter stringFromDate:[self.datePicker date]];
        [tmpformatter setDateFormat:@"HH:mm"];
        NSString * datestr2 = [tmpformatter stringFromDate:[self.timedatePicker date]];
        NSString * datestr = [NSString stringWithFormat:@"%@ %@",datestr1,datestr2];
        [self.datePicker setDate:[self.formatter dateFromString:datestr]];
    }
    
    if (self.pastDate) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(setPastDate: withTag:)]) {
            [self.delegate setPastDate:[self.datePicker date] withTag:self.textFieldTag];;
        }
    }else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(setDate:)]) {
            [self.delegate setDate:[self.formatter stringFromDate:[self.datePicker date]]];
        }
    }
    NSLog(@"%@",[self.datePicker date]);
    [self.dateselectPopover dismissPopoverAnimated:YES];
}
- (IBAction)btnCancel:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(setDate:)]) {
        [self.delegate setDate:@""];
    }
    [self.dateselectPopover dismissPopoverAnimated:YES];
}
-(void)showdate:(NSString *)date{
    self.datefrom=date;
}

- (void)showPastDate:(NSDate* )date{
    self.pastDate = date;
}
- (void)awakeFromNib
{
    self.preferredContentSize = CGSizeMake(320.0, 220.0);
    [super awakeFromNib];
}

@end
