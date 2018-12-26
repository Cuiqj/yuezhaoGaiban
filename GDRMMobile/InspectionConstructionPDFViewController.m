//
//  InspectionConstructionPDFViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 14-9-9.
//
//

#import "InspectionConstructionPDFViewController.h"
@interface InspectionConstructionPDFViewController ()

@end

@implementation InspectionConstructionPDFViewController
@synthesize pdfFilePath;
@synthesize delegate;
@synthesize selectedPDFType;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"蓝底主按钮" ofType:@"png"];
    UIImage *buttonImage=[[UIImage imageWithContentsOfFile:imagePath] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [self.uiButtonPrintFull setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.uiButtonPrintForm setBackgroundImage:buttonImage forState:UIControlStateNormal];
    
    [super viewDidLoad];
    [self.pdfView.layer setCornerRadius:4.0f];
    [self.pdfView.layer setMasksToBounds:YES];
    [self.pdfView loadRequest:[NSURLRequest requestWithURL: [NSURL fileURLWithPath:self.pdfFilePath]]];
    [self.pdfView setScalesPageToFit:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPdfView:nil];
	[self setUiButtonDeleteDoc:nil];
	[self setUiButtonPrintForm:nil];
	[self setUiButtonPrintFull:nil];
    [super viewDidUnload];
}
- (IBAction)btnPrintForm:(id)sender {
}

- (IBAction)btnPrintFull:(id)sender {
}

- (IBAction)btnDeleteDoc:(id)sender {
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"警告" message:@"将删除当前文书并返回构造物信息页面，是否继续?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.pdfFilePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:self.pdfFilePath error:nil];
            delegate.pdfFileURL = nil;
        }
        NSString *formatFilePath = [NSString stringWithFormat:@"%@.format.pdf", self.pdfFilePath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:formatFilePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:formatFilePath error:nil];
            delegate.pdfFormatFileURL = nil;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//套打
-(IBAction)btnPrintFormedPDF:(id)sender{
    [self printPDF:PDFWithoutTable withSender:sender];
}

//普通表格全打印
-(IBAction)btnPrintFullPDF:(id)sender{
    [self printPDF:PDFWithTable withSender:sender];
}

- (void) printPDF:(PDFType)fileType withSender:(id)sender{
    NSURL *file = nil;
    if (fileType == PDFWithTable) {
        file = delegate.pdfFileURL;
    }else{
        file = delegate.pdfFormatFileURL;
    }
    if (file != nil) {
        self.selectedPDFType = fileType;
        if ([UIPrintInteractionController isPrintingAvailable]) {
            UIPrintInteractionController * printer=[UIPrintInteractionController sharedPrintController];
            if ([UIPrintInteractionController canPrintURL:file]) {
                [printer setDelegate:self];
                UIPrintInfo *printInfo=[UIPrintInfo printInfo];
                printInfo.jobName=self.pdfFilePath;
                printInfo.outputType=UIPrintInfoOutputPhoto;
                printInfo.orientation = UIPrintInfoOrientationPortrait;
                printInfo.duplex = UIPrintInfoDuplexNone;

                printer.printInfo=printInfo;
                printer.printingItem=file;
                
                //测试PDF转图片打印用
                //[self imagesFromPDFURL:file];
                
                void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
                ^(UIPrintInteractionController *printController, BOOL completed, NSError *error ) {
                    if (!completed && error) {
                        NSLog(@"Printing could not complete because of error: %@", [error localizedDescription]);
                    }
                };
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    [printer presentFromRect:[sender frame] inView:self.view animated:YES completionHandler:completionHandler];
                } else {
                    [printer presentAnimated:YES completionHandler:completionHandler];
                }
            } else {
                NSLog(@"AirPrinter can NOT print the given file");
            }
        } else {
            NSLog(@"AirPrinter NOT Available");
        }
    }
}

#pragma mark - UIPrintInteractionControllerDelegate
- (UIPrintPaper *)printInteractionController:(UIPrintInteractionController *)printInteractionController choosePaper:(NSArray *)paperList
{
    NSURL *pdfURL;
    if (self.selectedPDFType == PDFWithoutTable) {
        pdfURL = delegate.pdfFormatFileURL;
    } else if (self.selectedPDFType == PDFWithTable) {
        pdfURL = delegate.pdfFileURL;
    }
    
    CGRect pdfFrame = [self frameOfPDFWithURL:pdfURL];
    
    UIPrintPaper *bestPaper = nil;
    bestPaper = [UIPrintPaper bestPaperForPageSize:pdfFrame.size withPapersFromArray:paperList];
    
    return bestPaper;
}



- (CGRect)frameOfPDFWithURL:(NSURL *)url
{
    CGRect pdfFrame = CGRectNull;
    CGPDFDocumentRef pdfDocument = CGPDFDocumentCreateWithURL((__bridge CFURLRef)url);
    CGPDFPageRef pdfPage = CGPDFDocumentGetPage(pdfDocument, 1); //页码数从1开始
    CGPDFDictionaryRef pdfDictionary = CGPDFPageGetDictionary(pdfPage);
    CGPDFArrayRef pdfBoxArray;
    if (CGPDFDictionaryGetArray(pdfDictionary, "MediaBox", &pdfBoxArray)) {
        NSInteger pdfBoxArrayCount = CGPDFArrayGetCount(pdfBoxArray);
        CGPDFReal pageCoords[4] = {};
        BOOL allCoordsOK = YES;
        for (int i = 0; i < pdfBoxArrayCount; i++) {
            CGPDFObjectRef pdfRectObj;
            if (CGPDFArrayGetObject(pdfBoxArray, i, &pdfRectObj)) {
                CGPDFReal pageCoord;
                if (CGPDFObjectGetValue(pdfRectObj, kCGPDFObjectTypeReal, &pageCoord)) {
                    pageCoords[i] = pageCoord;
                } else {
                    allCoordsOK = NO;
                    break;
                }
            }  else {
                allCoordsOK = NO;
                break;
            }
        }
        
        if (allCoordsOK) {
            // 左下角x: pageCoords[0]      左下角y: pageCoords[1]
            // 右上角x: pageCoords[2]      右上角y: pageCoords[3]
            // 左下角为原点
            pdfFrame = CGRectMake(pageCoords[0], pageCoords[1], pageCoords[2], pageCoords[3]);
        }
    }
    
    CGPDFDocumentRelease(pdfDocument);
    return pdfFrame;
}
@end
