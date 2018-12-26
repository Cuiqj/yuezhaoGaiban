//
//  AttachmentViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 14-8-21.
//
//

#import "AttachmentViewController.h"
#import "AttachmentCell.h"
#import "CasePhoto.h"
#import "MMProgressHUD.h"

@interface AttachmentViewController ()
@property (retain, nonatomic) NSMutableArray *photos;
@property (copy, nonatomic) NSString *casePhotoId;
@property (nonatomic,retain) UIPopoverController *caseInfoPickerpopover;
//照片路径
@property (nonatomic,retain) NSString *photoPath;
@end

@implementation AttachmentViewController
@synthesize constructionId;
@synthesize tableCloseList;
@synthesize caseInfoPickerpopover=_caseInfoPickerpopover;
@synthesize photoView;
- (void)viewDidLoad
{
    if(self.constructionId != nil){
        self.photos = [[CasePhoto casePhotos:self.constructionId]mutableCopy];
    }
    
    
    self.remark.layer.borderColor = [UIColor grayColor].CGColor;
    self.remark.layer.borderWidth =1.0;
    self.remark.layer.cornerRadius =5.0;
    

    [super viewDidLoad];
}
- (void)viewDidAppear:(BOOL)animated{
    //当UITableView没有内容的时候，选择第一行会报错
    if([self.photos count]> 0){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self tableView:tableCloseList didSelectRowAtIndexPath:indexPath];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [self setPhoto_name:nil];
    [self setRemark:nil];
    [self setPhotoView:nil];
    [super viewDidUnload];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AttachmentCell";
    AttachmentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    CasePhoto *casePhotoInfo=[self.photos objectAtIndex:indexPath.row];
    cell.textLabel.text=casePhotoInfo.photo_name;
    cell.textLabel.backgroundColor=[UIColor clearColor];

    
    cell.detailTextLabel.text=[NSString stringWithFormat:@"备注:%@",casePhotoInfo.remark] ;
    cell.detailTextLabel.backgroundColor=[UIColor clearColor];
    cell.textLabel.backgroundColor=[UIColor clearColor];
    if (casePhotoInfo.isuploaded.boolValue) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self.photos count] == 0){
        [self btnAddNew:nil];
        return;
    }
    if(indexPath.row >= [self.photos count]){
        [self selectFirstRow:nil];
        return;
    }
    id obj=[self.photos objectAtIndex:indexPath.row];
    if(obj){
        [self selectFirstRow:indexPath];
    }else{
        [self selectFirstRow:nil];
    }
}
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        id obj=[self.photos objectAtIndex:indexPath.row];
        BOOL isPromulgated=[[obj isuploaded] boolValue];
        if (isPromulgated) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"删除失败" message:@"已上传信息，不能直接删除" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [alert show];
        } else {
            NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
            [context deleteObject:obj];
            [self.photos removeObject:obj];
            
            //删除对应的图片
            CasePhoto *casePhoto = (CasePhoto *)obj;
            NSArray *pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentPath=[pathArray objectAtIndex:0];
            NSString *photoPath=[NSString stringWithFormat:@"InspectionConstruction/%@",casePhoto.proveinfo_id];
            photoPath=[documentPath stringByAppendingPathComponent:photoPath];
            [[NSFileManager defaultManager]removeItemAtPath:[photoPath stringByAppendingPathComponent:casePhoto.photo_name] error:nil];
            
            
            [[AppDelegate App] saveContext];
            
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            
            
        }
    }
}
- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self tableView:self.tableCloseList  didSelectRowAtIndexPath:indexPath];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CasePhoto *casePhotoInfo=[self.photos objectAtIndex:indexPath.row];
    self.casePhotoId=casePhotoInfo.myid;
    self.photo_name.text = casePhotoInfo.photo_name;
    self.remark.text = casePhotoInfo.remark;
    [self loadCasePhoto:self.constructionId photoName:casePhotoInfo.photo_name];
   
    //所有控制表格中行高亮的代码都只在这里
    [self.tableCloseList deselectRowAtIndexPath:[self.tableCloseList indexPathForSelectedRow] animated:YES];
    [self.tableCloseList selectRowAtIndexPath:indexPath animated:nil scrollPosition:nil];

    
}
- (IBAction)btnSave:(UIButton *)sender{
    if(self.casePhotoId != nil && ![self.casePhotoId isEmpty]){
        CasePhoto *casePhoto=[CasePhoto casePhotoById:self.casePhotoId];
        casePhoto.remark = self.remark.text;
    }else{
        CasePhoto *newPhoto = [CasePhoto newDataObjectWithEntityName:@"CasePhoto"];
        newPhoto.remark = self.remark.text;
    }
    [[AppDelegate App] saveContext];
     self.photos = [[CasePhoto casePhotos:self.constructionId]mutableCopy];
    [self.tableCloseList reloadData];
}

#pragma mark - Photo
- (IBAction)btnImageFromCamera:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self pickPhoto:UIImagePickerControllerSourceTypeCamera];
    }
}

- (IBAction)btnImageFromLibrary:(id)sender {
    [self pickPhoto:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)pickPhoto:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.delegate=self;
    picker.sourceType=sourceType;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        [self presentModalViewController:picker animated:YES];
    } else if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:picker];
        self.caseInfoPickerpopover = popover;
        CGRect infoCenter=CGRectMake(self.view.center.x-5, self.view.center.y-5, 10, 10);
        [self.caseInfoPickerpopover presentPopoverFromRect:infoCenter  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    if (![self.constructionId isEmpty]) {
        dispatch_queue_t myqueue=dispatch_queue_create("AttachmentPhotoSave", nil);
        //因为是异步操作，所以加上HUB
        [MMProgressHUD setDisplayStyle:MMProgressHUDDisplayStylePlain];
        [MMProgressHUD showWithTitle:@"正在保存图片，请稍等" status:nil];
        dispatch_async(myqueue, ^(void){
            UIImage *photo=[info objectForKey:UIImagePickerControllerOriginalImage];
            if ([self.photoPath isEmpty] || self.photoPath == nil) {
                NSArray *pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentPath=[pathArray objectAtIndex:0];
                NSString *photoPath=[NSString stringWithFormat:@"InspectionConstruction/%@",self.constructionId];
                self.photoPath=[documentPath stringByAppendingPathComponent:photoPath];
            }
            if (![[NSFileManager defaultManager] fileExistsAtPath:self.photoPath]) {
                [[NSFileManager defaultManager] createDirectoryAtPath:self.photoPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            NSString *photoName = [NSString randomID];
            NSString *filePath=[self.photoPath stringByAppendingPathComponent:photoName];
            NSData *photoData=UIImageJPEGRepresentation(photo, 0.8);
            if(self.casePhotoId != nil && ![self.casePhotoId isEmpty]){
                CasePhoto *casePhoto=[CasePhoto casePhotoById:self.casePhotoId];
                casePhoto.proveinfo_id = self.constructionId;
                [[NSFileManager defaultManager]removeItemAtPath:[self.photoPath stringByAppendingPathComponent:casePhoto.photo_name] error:nil];
                casePhoto.photo_name = photoName;
                dispatch_async(dispatch_get_main_queue(), ^{
                    casePhoto.remark = self.remark.text;
                });
            }else{
                CasePhoto *newPhoto = [CasePhoto newDataObjectWithEntityName:@"CasePhoto"];
                newPhoto.proveinfo_id = self.constructionId;
                newPhoto.photo_name = photoName;
                self.casePhotoId = newPhoto.myid;
                dispatch_async(dispatch_get_main_queue(), ^{
                    newPhoto.remark = self.remark.text;
                });
            }
            [[AppDelegate App] saveContext];
            if ([photoData writeToFile:filePath atomically:YES]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.photos = [[CasePhoto casePhotos:self.constructionId]mutableCopy];
                    [self.tableCloseList reloadData];
                    
                    for (NSInteger i = 0; i < [self.photos count]; i++) {
                        CasePhoto *photo = [self.photos objectAtIndex:i];
                        if([photo.myid isEqualToString:self.casePhotoId]){
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                            [self tableView:tableCloseList didSelectRowAtIndexPath:indexPath];
                        }
                    }
                    
                });
            }
           
        });
//        dispatch_release(myqueue);
    }
    if ([self.caseInfoPickerpopover isPopoverVisible]) {
        [self.caseInfoPickerpopover dismissPopoverAnimated:YES];
    } else {
        [picker dismissModalViewControllerAnimated:YES];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    if ([self.caseInfoPickerpopover isPopoverVisible]) {
        [self.caseInfoPickerpopover dismissPopoverAnimated:YES];
    } else {
        [picker dismissModalViewControllerAnimated:YES];
    }
}
//载入对应的照片
- (void)loadCasePhoto:(NSString *)proveinfoId photoName:(NSString*)photoName{
    NSArray *pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath=[pathArray objectAtIndex:0];
    NSString *photoPath=[NSString stringWithFormat:@"InspectionConstruction/%@",proveinfoId];
    self.photoPath=[documentPath stringByAppendingPathComponent:photoPath];
    NSString *filePath=[self.photoPath stringByAppendingPathComponent:photoName];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    self.photoView.image = image;
    [MMProgressHUD dismiss];
}
- (IBAction)btnAddNew:(UIButton *)sender {
    self.photos = [[CasePhoto casePhotos:self.constructionId]mutableCopy];
    if([self.photos count] >= 6){
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"只能添加最多6个附件" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
        return;
    }
    self.photo_name.text = @"";
    self.photoView.image = nil;
    self.remark.text = @"";
    self.casePhotoId=@"";
    [self.tableCloseList deselectRowAtIndexPath:[self.tableCloseList indexPathForSelectedRow] animated:YES];
}

-(void)selectFirstRow:(NSIndexPath *)indexPath{
    //当UITableView没有内容的时候，选择第一行会报错
    if([self.photos count]> 0){
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
@end
