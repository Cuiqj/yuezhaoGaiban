//
//  XKSPInfoController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBXML.h"

@interface XKSPInfoController : UIViewController<UITableViewDataSource,UITableViewDelegate,WebServiceReturnString>
@property (weak, nonatomic) IBOutlet UILabel *lableAppNo;
@property (nonatomic,weak) id delegate;
-(void)showInfo:(NSString *)appno;
@property (weak, nonatomic) IBOutlet UITextField *txtAppno;
@property (nonatomic,strong)NSString *appno;
@property (weak, nonatomic) IBOutlet UITableView *tbView;

@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,strong) NSMutableArray *detaildata;

-(void)loadData;

@end
