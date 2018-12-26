//
//  InspectionConstructionViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 14-8-18.
//
//

#import <UIKit/UIKit.h>
#import "InspectionConstructionViewController.h"
#import "InspectionConstruction.h"
#import "DateSelectController.h"
#import "UserPickerViewController.h"
#import "CaseInfoPickerViewController.h"
#import "CasePrintViewController.h"

@interface InspectionConstructionViewController : CasePrintViewController<UserPickerDelegate,DatetimePickerHandler,UITextFieldDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,CaseIDHandler>
@property (weak, nonatomic) IBOutlet UIButton *uiBtnSave;
@property (weak, nonatomic) IBOutlet UITableView *tableCloseList;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollContent;
@property (weak, nonatomic) IBOutlet UITextField *inspectionDate;
@property (weak, nonatomic) IBOutlet UITextField *timeStart1;
@property (weak, nonatomic) IBOutlet UITextField *timeEnd1;
@property (weak, nonatomic) IBOutlet UITextField *weather1;
@property (weak, nonatomic) IBOutlet UITextField *textStartKM1;
@property (weak, nonatomic) IBOutlet UITextField *textStartM1;
@property (weak, nonatomic) IBOutlet UITextField *textEndKM1;
@property (weak, nonatomic) IBOutlet UITextField *textEndM1;
@property (weak, nonatomic) IBOutlet UITextField *inspectionor1;

@property (weak, nonatomic) IBOutlet UITextField *timeStart2;
@property (weak, nonatomic) IBOutlet UITextField *timeEnd2;
@property (weak, nonatomic) IBOutlet UITextField *weather2;
@property (weak, nonatomic) IBOutlet UITextField *textStartKM2;
@property (weak, nonatomic) IBOutlet UITextField *textStartM2;
@property (weak, nonatomic) IBOutlet UITextField *textEndKM2;
@property (weak, nonatomic) IBOutlet UITextField *textEndM2;
@property (weak, nonatomic) IBOutlet UITextField *inspectionor2;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (retain, nonatomic) NSURL *pdfFormatFileURL;
@property (retain, nonatomic) NSURL *pdfFileURL;
- (IBAction)btnAddNew:(UIButton *)sender;
- (IBAction)btnSave:(UIButton *)sender;
- (IBAction)textTouch:(UITextField *)sender;
- (IBAction)userSelect:(UITextField *)sender;
- (IBAction)toAttachmentView:(id)sender;
- (IBAction)toPrintView:(id)sender;
@end

