//
//  InspectionConstructionViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 14-8-18.
//
//

#import "InspectionConstructionViewController.h"
#import "UserInfo.h"
#import "InspectionConstructionCell.h"
#import "AttachmentViewController.h"
#import "InspectionConstructionPDFViewController.h"

static NSString *inspectionConstructionTable = @"InspectionConstructionTable";
static NSString *inspectionConstruction = @"InspectionConstruction";

typedef enum {
    kStartTime1=0,
    kEndTime1,
    kStartTime2,
    kEndTime2,
    kInspectionDate
} TimeState;

@interface InspectionConstructionViewController ()
@property (retain, nonatomic) NSMutableArray *constructionList;
@property (retain, nonatomic) UIPopoverController *pickerPopover;
@property (copy, nonatomic) NSString *constructionID;
@property (assign, nonatomic) TimeState timeState;



@property (assign,nonatomic)BOOL isWeatherFirstOrWeatherSecond;
@property (assign,nonatomic)NSInteger touchTextTag;

-(void)keyboardWillShow:(NSNotification *)aNotification;
-(void)keyboardWillHide:(NSNotification *)aNotification;
-(BOOL)checkInspectionConstructionInfo;
@end

@implementation InspectionConstructionViewController{
    NSIndexPath *notDeleteIndexPath;
}
@synthesize uiBtnSave;
@synthesize tableCloseList;
@synthesize scrollContent;
@synthesize constructionList;
@synthesize pickerPopover;
@synthesize constructionID = _constructionID;
@synthesize firstView;
@synthesize secondView;
@synthesize isWeatherFirstOrWeatherSecond;
@synthesize pdfFormatFileURL;
@synthesize pdfFileURL;
- (NSString *)constructionID{
    if (_constructionID==nil) {
        _constructionID=@"";
    }
    return _constructionID;
}

- (void)viewDidLoad
{
    self.constructionList=[[InspectionConstruction inspectionConstructionInfoForID:@""] mutableCopy];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    

    firstView.layer.cornerRadius = 8;
    firstView.layer.masksToBounds = YES;
    firstView.layer.borderWidth = 1;
    firstView.layer.borderColor = [[UIColor blackColor] CGColor];
    

    secondView.layer.cornerRadius = 8;
    secondView.layer.masksToBounds = YES;
    secondView.layer.borderWidth = 1;
    secondView.layer.borderColor = [[UIColor blackColor] CGColor];
    
    

    self.scrollContent.showsVerticalScrollIndicator=NO;
    
    if([self.constructionList count]> 0){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self tableView:tableCloseList didSelectRowAtIndexPath:indexPath];
    }
    [super viewDidLoad];
}
- (void)viewDidAppear:(BOOL)animated{
    

}
- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setTableCloseList:nil];
    [self setConstructionID:nil];
    [self setScrollContent:nil];
    [self setUiBtnSave:nil];
    [self setSecondView:nil];
    [self setFirstView:nil];
    [self setFirstView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.constructionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"InspectionConstructionCell";
    InspectionConstructionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    InspectionConstruction *constructionInfo=[self.constructionList objectAtIndex:indexPath.row];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    cell.textLabel.text=[formatter stringFromDate:constructionInfo.inspectiondate];
    cell.textLabel.backgroundColor=[UIColor clearColor];
    NSString *local=@"";
    
    [formatter setDateFormat:@"HH:mm"];
    local = [local stringByAppendingString:@"检查时间:"];
    if(constructionInfo.timestart1 != nil){
        local = [local stringByAppendingString:[formatter stringFromDate: constructionInfo.timestart1]];
    }
    local = [local stringByAppendingString:@"至"];
    if(constructionInfo.timeend1 != nil){
        local = [local stringByAppendingString:[formatter stringFromDate: constructionInfo.timeend1]];
    }
    local = [local stringByAppendingString:@" 桩号:K"];
    if(constructionInfo.stationstart1 != nil){
        local = [local stringByAppendingString:[NSString stringWithFormat:@"%ld", constructionInfo.stationstart1.integerValue/1000]];
    }
    local = [local stringByAppendingString:@"+"];
    if(constructionInfo.stationstart1 != nil){
        local = [local stringByAppendingString:[NSString stringWithFormat:@"%ld",constructionInfo.stationstart1.integerValue%1000]];
    }
    local = [local stringByAppendingString:@"至"];
    if(constructionInfo.stationend1 != nil){
        local = [local stringByAppendingString:[NSString stringWithFormat:@"%ld",constructionInfo.stationend1.integerValue/1000]];
    }
    local = [local stringByAppendingString:@"+"];
    if(constructionInfo.stationend1 != nil){
        local = [local stringByAppendingString:[NSString stringWithFormat:@"%ld",constructionInfo.stationend1.integerValue%1000]];
    }
    
    cell.detailTextLabel.text=local;

    
    
    cell.textLabel.backgroundColor=[UIColor clearColor];
    if (constructionInfo.isuploaded.boolValue) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    id obj;
    if(indexPath){
        obj=[self.constructionList objectAtIndex:indexPath.row];
    }else{
        if(notDeleteIndexPath){
            obj=[self.constructionList objectAtIndex:notDeleteIndexPath.row];
            indexPath = notDeleteIndexPath;
        }
    }
    if(obj){
        [self selectFirstRow:indexPath];
    }else{
        [self selectFirstRow:nil];
    }
}
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    notDeleteIndexPath = nil;
    return @"删除";
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        id obj=[self.constructionList objectAtIndex:indexPath.row];
        BOOL isPromulgated=[[obj isuploaded] boolValue];
        if (isPromulgated) {
            notDeleteIndexPath = indexPath;
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"删除失败" message:@"已上传信息，不能直接删除" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [alert show];
        } else {
            
            
            NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
            [context deleteObject:obj];
            [self.constructionList removeObject:obj];
            
            InspectionConstruction *inspection = (InspectionConstruction *)obj;
            NSArray *pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentPath=[pathArray objectAtIndex:0];
            NSString *photoPath=[NSString stringWithFormat:@"InspectionConstruction/%@",inspection.myid];
            photoPath=[documentPath stringByAppendingPathComponent:photoPath];
            [[NSFileManager defaultManager]removeItemAtPath:photoPath error:nil];
            
            [[AppDelegate App] saveContext];
            

            
            self.constructionID = @"";
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    InspectionConstruction *constructionInfo=[self.constructionList objectAtIndex:indexPath.row];
    self.constructionID=constructionInfo.myid;
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    self.inspectionDate.text =[formatter stringFromDate:constructionInfo.inspectiondate];
    [formatter setDateFormat:@"HH:mm"];
    self.timeStart1.text = [formatter stringFromDate: constructionInfo.timestart1];
    self.timeStart2.text = [formatter stringFromDate: constructionInfo.timestart2];
    self.timeEnd1.text = [formatter stringFromDate: constructionInfo.timeend1];
    self.timeEnd2.text = [formatter stringFromDate: constructionInfo.timeend2];
    self.weather1.text = constructionInfo.weather1;
    self.weather2.text = constructionInfo.weather2;
    
    self.textStartKM1.text=[NSString stringWithFormat:@"%ld", constructionInfo.stationstart1.integerValue/1000];
    self.textStartM1.text=[NSString stringWithFormat:@"%ld",constructionInfo.stationstart1.integerValue%1000];
    self.textStartKM2.text=[NSString stringWithFormat:@"%ld",constructionInfo.stationstart2.integerValue/1000];
    self.textStartM2.text=[NSString stringWithFormat:@"%ld",constructionInfo.stationstart2.integerValue%1000];
    
    self.textEndKM1.text=[NSString stringWithFormat:@"%ld", constructionInfo.stationend1.integerValue/1000];
    self.textEndM1.text=[NSString stringWithFormat:@"%ld",constructionInfo.stationend1.integerValue%1000];
    self.textEndKM2.text=[NSString stringWithFormat:@"%ld",constructionInfo.stationend2.integerValue/1000];
    self.textEndM2.text=[NSString stringWithFormat:@"%ld",constructionInfo.stationend2.integerValue%1000];

    self.inspectionor1.text = constructionInfo.inspectionor1;
    self.inspectionor2.text = constructionInfo.inspectionor2;
    //所有控制表格中行高亮的代码都只在这里
    [self.tableCloseList deselectRowAtIndexPath:[self.tableCloseList indexPathForSelectedRow] animated:YES];
    [self.tableCloseList selectRowAtIndexPath:indexPath animated:nil scrollPosition:nil];
}


- (IBAction)btnAddNew:(UIButton *)sender {
    for (UITextField *textField in [self.scrollContent subviews]) {
        if ([textField isKindOfClass:[UITextField class]]) {
            textField.text=@"";
        }
    }
    for (UITextField *textField in [self.firstView subviews]) {
        if ([textField isKindOfClass:[UITextField class]]) {
            textField.text=@"";
        }
    }
    for (UITextField *textField in [self.secondView subviews]) {
        if ([textField isKindOfClass:[UITextField class]]) {
            textField.text=@"";
        }
    }
    self.constructionID=@"";
    [self.tableCloseList deselectRowAtIndexPath:[self.tableCloseList indexPathForSelectedRow] animated:YES];
}

- (IBAction)btnSave:(UIButton *)sender {
	if(![self checkInspectionConstructionInfo]){
		return;
	}
	InspectionConstruction *constructionInfo;
    
    NSIndexPath *indexPath;
    if ([self.constructionID isEmpty]) {
		constructionInfo=[InspectionConstruction newDataObjectWithEntityName:inspectionConstruction];
        self.constructionID = constructionInfo.myid;
        indexPath = [NSIndexPath indexPathForRow:[self.constructionList count] inSection:0];
	} else {
		constructionInfo=[[InspectionConstruction inspectionConstructionInfoForID:self.constructionID] objectAtIndex:0];
	}
	constructionInfo.myid=self.constructionID;
    constructionInfo.inspectionor1 = self.inspectionor1.text;
    constructionInfo.inspectionor2 = self.inspectionor2.text;
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
	constructionInfo.inspectiondate = [formatter dateFromString:self.inspectionDate.text];
    [formatter setDateFormat:@"HH:mm"];
    constructionInfo.timestart1 = [formatter dateFromString:self.timeStart1.text];
    constructionInfo.timestart2 = [formatter dateFromString:self.timeStart2.text];
    constructionInfo.timeend1 = [formatter dateFromString:self.timeEnd1.text];
    constructionInfo.timeend2 = [formatter dateFromString:self.timeEnd2.text];
	constructionInfo.weather1 = self.weather1.text;
    constructionInfo.weather2 = self.weather2.text;
    constructionInfo.stationstart1=[NSNumber numberWithInteger:(self.textStartKM1.text.integerValue*1000+self.textStartM1.text.integerValue)];
    constructionInfo.stationstart2=[NSNumber numberWithInteger:(self.textStartKM2.text.integerValue*1000+self.textStartM2.text.integerValue)];
    constructionInfo.stationend1=[NSNumber numberWithInteger:(self.textEndKM1.text.integerValue*1000+self.textEndM1.text.integerValue)];
    constructionInfo.stationend2=[NSNumber numberWithInteger:(self.textEndKM2.text.integerValue*1000+self.textEndM2.text.integerValue)];
    [[AppDelegate App] saveContext];
    self.constructionList=[[InspectionConstruction inspectionConstructionInfoForID:@""] mutableCopy];
    [self.tableCloseList reloadData];
   
    //当新增的时候，会在左侧的列表中添加一条新的记录，所以这条新的记录必须高亮
    if(indexPath){
        [self tableView:tableCloseList didSelectRowAtIndexPath:indexPath];
        return;
    }
    
    for (NSInteger i = 0; i < [self.constructionList count]; i++) {
        InspectionConstruction *inspection = [self.constructionList objectAtIndex:i];
        if([inspection.myid isEqualToString:self.constructionID]){
            indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self tableView:tableCloseList didSelectRowAtIndexPath:indexPath];
        }
    }
}


- (IBAction)textTouch:(UITextField *)sender {
    switch (sender.tag) {
        case 1:{
            if ([self.pickerPopover isPopoverVisible]) {
                [self.pickerPopover dismissPopoverAnimated:YES];
            } else {
                DateSelectController *datePicker=[self.storyboard instantiateViewControllerWithIdentifier:@"datePicker"];
                datePicker.delegate=self;
                datePicker.pickerType=0;
                NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
                [dateFormatter setLocale:[NSLocale currentLocale]];
                [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
                NSDate *temp=[dateFormatter dateFromString:self.inspectionDate.text];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                [datePicker showdate:[dateFormatter stringFromDate:temp]];
                self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
                [self.pickerPopover presentPopoverFromRect:sender.frame inView:self.scrollContent permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
                datePicker.dateselectPopover=self.pickerPopover;
            }
        }
            self.timeState = kInspectionDate;
            break;
        case 2:{
            if ([self.pickerPopover isPopoverVisible]) {
                [self.pickerPopover dismissPopoverAnimated:YES];
            } else {
                DateSelectController *datePicker=[self.storyboard instantiateViewControllerWithIdentifier:@"datePicker"];
                datePicker.delegate=self;
                datePicker.pickerType=2;
                [datePicker showdate:self.timeStart1.text];
                self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
               [self.pickerPopover presentPopoverFromRect:sender.frame inView:self.firstView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
                datePicker.dateselectPopover=self.pickerPopover;
            }
        }
            self.timeState = kStartTime1;
            break;
        case 3:{
            if ([self.pickerPopover isPopoverVisible]) {
                [self.pickerPopover dismissPopoverAnimated:YES];
            } else {
                DateSelectController *datePicker=[self.storyboard instantiateViewControllerWithIdentifier:@"datePicker"];
                datePicker.delegate=self;
                datePicker.pickerType=2;
                [datePicker showdate:self.timeEnd2.text];
                self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
                [self.pickerPopover presentPopoverFromRect:sender.frame inView:self.firstView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
                datePicker.dateselectPopover=self.pickerPopover;
            }
        }
            self.timeState = kEndTime1;
            break;
        case 4:{
            CaseInfoPickerViewController *acPicker=[self.storyboard instantiateViewControllerWithIdentifier:@"CaseInfoPicker"];
            acPicker.pickerType=0;
            acPicker.delegate=self;
            self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:acPicker];
            [self.pickerPopover setPopoverContentSize:CGSizeMake(140, 264)];
            [acPicker.tableView setFrame:CGRectMake(0, 0, 140, 264)];
            if([(UITextField*)sender tag] == 4){
                self.isWeatherFirstOrWeatherSecond = true;
                [self.pickerPopover presentPopoverFromRect:[(UITextField*)sender frame] inView:self.firstView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
            }else{
                self.isWeatherFirstOrWeatherSecond = false;
                [self.pickerPopover presentPopoverFromRect:[(UITextField*)sender frame] inView:self.secondView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
            }
            
            acPicker.pickerPopover=self.pickerPopover;
        }
            break;
        case 9:
            break;
        case 10:{
            if ([self.pickerPopover isPopoverVisible]) {
                [self.pickerPopover dismissPopoverAnimated:YES];
            } else {
                DateSelectController *datePicker=[self.storyboard instantiateViewControllerWithIdentifier:@"datePicker"];
                datePicker.delegate=self;
                datePicker.pickerType=2;
                [datePicker showdate:self.timeStart2.text];
                self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
               [self.pickerPopover presentPopoverFromRect:sender.frame inView:self.secondView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
                datePicker.dateselectPopover=self.pickerPopover;
            }
        }
            self.timeState = kStartTime2;
            break;
        case 11:{
            if ([self.pickerPopover isPopoverVisible]) {
                [self.pickerPopover dismissPopoverAnimated:YES];
            } else {
                DateSelectController *datePicker=[self.storyboard instantiateViewControllerWithIdentifier:@"datePicker"];
                datePicker.delegate=self;
                datePicker.pickerType=2;
                [datePicker showdate:self.timeEnd2.text];
                self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
               [self.pickerPopover presentPopoverFromRect:sender.frame inView:self.secondView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
                datePicker.dateselectPopover=self.pickerPopover;
            }
        }
            self.timeState = kEndTime2;
            break;
        case 12:{
            CaseInfoPickerViewController *acPicker=[self.storyboard instantiateViewControllerWithIdentifier:@"CaseInfoPicker"];
            acPicker.pickerType=0;
            acPicker.delegate=self;
            self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:acPicker];
            [self.pickerPopover setPopoverContentSize:CGSizeMake(140, 264)];
            [acPicker.tableView setFrame:CGRectMake(0, 0, 140, 264)];
            if([(UITextField*)sender tag] == 4){
                self.isWeatherFirstOrWeatherSecond = true;
                [self.pickerPopover presentPopoverFromRect:[(UITextField*)sender frame] inView:self.firstView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
            }else{
                self.isWeatherFirstOrWeatherSecond = false;
                [self.pickerPopover presentPopoverFromRect:[(UITextField*)sender frame] inView:self.secondView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
            }
            
            acPicker.pickerPopover=self.pickerPopover;
        }
            break;
        case 17:
            break;
        default:
            break;
    }
}



- (void)setDate:(NSString *)date{

    switch (self.timeState) {
        case kInspectionDate:{
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setLocale:[NSLocale currentLocale]];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *temp=[dateFormatter dateFromString:date];
            [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
            NSString *dateString=[dateFormatter stringFromDate:temp];
            self.inspectionDate.text=dateString;
        }            
            break;
        case kStartTime1:{
            self.timeStart1.text=date;
        }
            break;
        case kEndTime1:{
            self.timeEnd1.text=date;
        }
            break;
        case kStartTime2:{
            self.timeStart2.text=date;
        }
            break;
        case kEndTime2:{
            self.timeEnd2.text=date;
        }
            break;
    }
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag==1 || textField.tag==2 || textField.tag == 4 || textField.tag == 12 || textField.tag == 11 || textField.tag == 3 || textField.tag == 9 || textField.tag == 10 || textField.tag == 17) {
        return NO;
    } else {
        return YES;
    }
}


//键盘出现和消失时，变动ScrollContent的contentSize;
-(void)keyboardWillShow:(NSNotification *)aNotification{
    for ( id view in self.secondView.subviews) {
        if ([view isFirstResponder]) {
            if ([view tag] >= 10) {
                [self.scrollContent setContentOffset:CGPointMake(0, 300) animated:YES];
            }
        }
    }
}

-(void)keyboardWillHide:(NSNotification *)aNotification{
    [self.scrollContent setContentOffset:CGPointMake(0, 0) animated:YES];
}





- (IBAction)userSelect:(UITextField *)sender {
    if ((self.touchTextTag == sender.tag) && ([self.pickerPopover isPopoverVisible])) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        self.touchTextTag=sender.tag;
        UserPickerViewController *acPicker=[[UserPickerViewController alloc] init];
        acPicker.delegate=self;
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:acPicker];
        [self.pickerPopover setPopoverContentSize:CGSizeMake(140, 200)];
        if(sender.tag == 9){
            [self.pickerPopover presentPopoverFromRect:sender.frame inView:self.firstView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }else{
            [self.pickerPopover presentPopoverFromRect:sender.frame inView:self.secondView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
        acPicker.pickerPopover=self.pickerPopover;
    }
}

- (IBAction)toAttachmentView:(id)sender {
    if(self.constructionID == nil || [self.constructionID isEmpty]){
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择一条物料检查记录" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
        return;
    }
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    AttachmentViewController *next = [board instantiateViewControllerWithIdentifier:@"AttachmentViewController"];
    [next setValue:self.constructionID forKey:@"constructionId"];
    [self.navigationController pushViewController:next animated:YES];
}



- (void)setUser:(NSString *)name andUserID:(NSString *)userID{
    [(UITextField *)[self.view viewWithTag:self.touchTextTag] setText:name];
}
-(void)setWeather:(NSString *)textWeather{
    if(self.isWeatherFirstOrWeatherSecond){
        self.weather1.text = textWeather;
    }else{
        self.weather2.text = textWeather;
    }
}

//传递给附件界面
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    id page2 = segue.destinationViewController;
    
    //将值透过Storyboard Segue带给页面2的string变数
    [page2 setValue:self.constructionID forKey:@"constructionId"];
}

//检查案件基本信息是否为空
-(BOOL)checkInspectionConstructionInfo{
    NSString *message = nil;
    //检查案号
    if([self.inspectionDate.text isEmpty]){
        message = @"请选择巡查日期";
    }else if([self.timeStart1.text isEmpty] || [self.timeEnd1.text isEmpty]){
		message = @"请选择检查时间";
    }else if([self.weather1.text isEmpty]){
		message = @"请选择天气";
	}else if([self.textStartKM1.text isEmpty] || [self.textStartM1.text isEmpty] || [self.textEndKM1.text isEmpty] || [self.textEndM1.text isEmpty]){
		message = @"请填写完整桩号";
	}else if([self.inspectionor1.text isEmpty]){
		message = @"请填写巡查人员";
	}
    
    if(message != nil){
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
        return NO;
    }
    return  YES;
}

- (NSURL *)toFullPDFWithPath:(NSString *)filePath{
    if (![filePath isEmpty]) {
        [self LoadPaperSettings:inspectionConstructionTable];
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawStaticTable:inspectionConstructionTable];
        [self drawDateTable:@"InspectionConstructionTable" withDataModel:[[InspectionConstruction inspectionConstructionInfoForID:self.constructionID]objectAtIndex:0] ];
        UIGraphicsEndPDFContext();
        return [NSURL fileURLWithPath:filePath];
    } else {
        return nil;
    }
}
- (NSURL *)toFormedPDFWithPath:(NSString *)filePath{
    if (![filePath isEmpty]) {
        [self LoadPaperSettings:inspectionConstructionTable];
        NSString *formatFilePath = [NSString stringWithFormat:@"%@.format.pdf", filePath];
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(formatFilePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawDateTable:@"InspectionConstructionTable" withDataModel:[[InspectionConstruction inspectionConstructionInfoForID:self.constructionID]objectAtIndex:0] ];
        UIGraphicsEndPDFContext();
        return [NSURL fileURLWithPath:filePath];
    } else {
        return nil;
    }
}
-(NSString *)docPathFromFileName{
    NSArray *arrayPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[arrayPaths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:inspectionConstruction];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf",self.constructionID]];
}
- (IBAction)toPrintView:(id)sender {
    if(self.constructionID == nil || [self.constructionID isEmpty]){
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择一条物料检查记录" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
        return;
    }
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    InspectionConstructionPDFViewController *next = [board instantiateViewControllerWithIdentifier:@"InspectionConstructionPDFViewController"];
    NSLog(@"%@",[self docPathFromFileName]);
   
    NSString *docPath = [self docPathFromFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:docPath]) {
        [self toFullPDFWithPath:[self docPathFromFileName]];
    }
    if (pdfFileURL == nil) {
        pdfFileURL = [NSURL fileURLWithPath:[self docPathFromFileName]];
    }
    [next setValue:[self docPathFromFileName] forKey:@"pdfFilePath"];
    [next setValue:self forKey:@"delegate"];
    [self.navigationController pushViewController:next animated:YES];
}


- (NSURL *)pdfFormatFileURL{
    if (pdfFormatFileURL == nil) {
        pdfFormatFileURL = [self toFormedPDFWithPath:[self docPathFromFileName]];
    }
    return pdfFormatFileURL;
}



-(void)selectFirstRow:(NSIndexPath *)indexPath{
    //当UITableView没有内容的时候，选择第一行会报错
    if([self.constructionList count]> 0){
        if (!indexPath) {
            indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        }
        [self performSelector:@selector(selectRowAtIndexPath:)
                   withObject:indexPath
                   afterDelay:0];
    }else{
        [self btnAddNew:nil];
    }
}
- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath {
     [self tableView:tableCloseList didSelectRowAtIndexPath:indexPath];
}
@end
