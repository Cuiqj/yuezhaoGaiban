//
//  InspectionConstructionPDFViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 14-9-9.
//
//

#import <UIKit/UIKit.h>
#import "InspectionConstructionViewController.h"

typedef enum {
    PDFWithTable=0,
    PDFWithoutTable,
} PDFType;
@interface InspectionConstructionPDFViewController : UIViewController<UIPrintInteractionControllerDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *pdfView;
@property (weak, nonatomic) IBOutlet UIButton *uiButtonDeleteDoc;
@property (weak, nonatomic) IBOutlet UIButton *uiButtonPrintForm;
@property (weak, nonatomic) IBOutlet UIButton *uiButtonPrintFull;
@property (nonatomic,retain) NSString *pdfFilePath;
@property (nonatomic,weak) InspectionConstructionViewController *delegate;
@property (nonatomic) PDFType selectedPDFType;
-(IBAction)btnPrintFormedPDF:(id)sender;
-(IBAction)btnPrintFullPDF:(id)sender;
- (IBAction)btnDeleteDoc:(id)sender;

@end
