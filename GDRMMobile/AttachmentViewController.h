//
//  AttachmentViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 14-8-21.
//
//

#import <UIKit/UIKit.h>

@interface AttachmentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *photo_name;
@property (weak, nonatomic) IBOutlet UITextView *remark;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (copy, nonatomic) NSString *constructionId;
@property (weak, nonatomic) IBOutlet UITableView *tableCloseList;
- (IBAction)btnAddNew:(UIButton *)sender;
- (IBAction)btnSave:(UIButton *)sender;

- (IBAction)btnImageFromCamera:(id)sender;
- (IBAction)btnImageFromLibrary:(id)sender;
@end

