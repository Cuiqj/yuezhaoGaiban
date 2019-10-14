//
//  AppDelegate.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-2-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import "OrgInfo.h"
#import "UserInfo.h"
#import "UploadRecord.h"
#import "InspectionConstruction.h"
#import "LCNetworking.h"
@implementation AppDelegate

@synthesize window = _window;
@synthesize serverAddress=_serverAddress;
@synthesize fileAddress=_fileAddress;
@synthesize operationQueue=_operationQueue;

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (void)dealloc {
    [self setWindow:nil];
    [self setServerAddress:nil];
    [self setFileAddress:nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initServer];
    return YES;
}

// applicationWillTerminate: saves changes in the application's managed object context before
// the application terminates.
//
- (void)applicationWillTerminate:(UIApplication *)application {
//    程序关闭 会调用这个方法
    [self saveContext];
}

- (void)applicationWillResignActive:(UIApplication *)application{
//    退出    不活跃
//    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    // 获取完整路径
//    NSString *documentsPath = [path objectAtIndex:0];
//    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"newsTest.plist"];
//    //创建数据
//    NSMutableDictionary *newsDict = [NSMutableDictionary dictionary];
//    //赋值
//    [newsDict setObject:@"zhangsan" forKey:@"name"];
//    [newsDict setObject:@"12" forKey:@"age"];
//    [newsDict setObject:@"man" forKey:@"sex"];
//    //写入
//    [newsDict writeToFile:plistPath atomically:YES];
    [self saveContext];
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    UploadRecord *uploadCheck = [[UploadRecord alloc] init];
    [uploadCheck asyncDel];
//    [self hasUpdateVersion];
}
- (void)hasUpdateVersion{
    __weak typeof(self)weakself = self;
    NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
    NSString *currentBulidVersion = infoDic[@"CFBundleVersion"];
    //蒲公英的apikey，appkey
    NSDictionary *paramDic = @{@"_api_key":@"d98734ffcbcb99a86ff217e63c46ecfe",@"appKey":@"b5993ef24112dc7cd48ce084a4cc289e"};
    [self loadUpdateWithDic:paramDic success:^(id response) {
        NSLog(@"更新信息");
        if ([currentBulidVersion integerValue] < [response[@"data"][@"buildVersionNo"]integerValue]) {
            //如果当前手机安装app的版本号不是蒲公英上最新打包的版本号，则提示更新
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"版本更新" message:@"检测到新版本,是否更新?\n更新之前请上传数据，以防数据丢失！"  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [ac addAction:cancelAction];
            UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //                NSURL *url = [NSURL URLWithString:response[@"data"][@"buildShortcutUrl"]];
                //                [[UIApplication sharedApplication] openURL:url];
                //                data =     {
                //                    buildBuildVersion = 2;
                //                    buildHaveNewVersion = 1;
                //                    buildShortcutUrl = "https://www.pgyer.com/HbOA";
                //                    buildUpdateDescription = "\U6700\U65b0\U7248\U672c\U6d4b\U8bd5";
                //                    buildVersion = 2018092901;
                //                    buildVersionNo = 2018092901;
                //                    downloadURL = "itms-services://?action=download-manifest&url=https://www.pgyer.com/app/plist/e649cd191f07632c94c628774b91f0d5/update/s.plist";
                //                };
                NSURL *url = [NSURL URLWithString:response[@"data"][@"downloadURL"]];
                [[UIApplication sharedApplication] openURL:url];
            }];
            [ac addAction:doneAction];
            [weakself.window.rootViewController presentViewController:ac animated:YES completion:nil];
        }
        else if ([currentBulidVersion integerValue] >=[response[@"data"][@"buildVersionNo"]integerValue]){
            
        }
    }];
}
- (void)loadUpdateWithDic:(NSDictionary *)dic success:(void(^)(id response))success {
    [LCNetworking PostWithURL:@"https://www.pgyer.com/apiv2/app/check" Params:dic success:^(NSDictionary *responseObject) {
        NSLog(@"POST_success____%@", responseObject);
        success(responseObject);
    } failure:^(NSString *error) {
        NSLog(@"POST_failure____%@", error);
    }];
}

-(void)initServer{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    NSString *plistFileName = @"Settings.plist";
    NSString *plistlibraryPath = [libraryDirectory stringByAppendingPathComponent:plistFileName];
    NSFileManager *manager=[NSFileManager defaultManager];
    if (![manager fileExistsAtPath:plistlibraryPath]) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
        [manager copyItemAtPath:plistPath toPath:plistlibraryPath error:nil];
    }
    NSPropertyListFormat format;  
    NSString *errorDesc = nil;  
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistlibraryPath];
    NSDictionary *settings = (NSDictionary *)[NSPropertyListSerialization
                                          propertyListFromData:plistXML  
                                          mutabilityOption:NSPropertyListMutableContainersAndLeaves  
                                          format:&format  
                                          errorDescription:&errorDesc];  
    if (!settings) {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);  
    }
    NSDictionary *temp=[settings objectForKey:@"Server Settings"];
    self.serverAddress = [temp objectForKey:@"server address"];
    self.fileAddress = [temp objectForKey:@"file address"];
    self.projectDictionary = [settings objectForKey:@"Projectname"];

    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory=[paths objectAtIndex:0];
    NSString *casePhotoDirectory=[documentDirectory stringByAppendingPathComponent:@"CasePhoto"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:casePhotoDirectory isDirectory:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:casePhotoDirectory withIntermediateDirectories:NO attributes:nil error:nil];
    }

}

+ (AppDelegate *)App{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{        
        if (__persistentStoreCoordinator != nil) {
            return __persistentStoreCoordinator;
        }
        
        NSURL *storeUrl = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
        
        // handle db upgrade
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        
        NSError *error = nil;
        __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
        if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
            // Handle error
        }
        
        return __persistentStoreCoordinator;

}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


-(void)clearEntityForName:(NSString *)entityName{
    NSError *error=nil;
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setPredicate:nil];
    [fetchRequest setEntity:entity];
    [fetchRequest setIncludesPropertyValues:NO];
    NSArray *mutableFetchResults=[self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *tableinfo in mutableFetchResults){
        [self.managedObjectContext deleteObject:tableinfo];
    }
    [[AppDelegate App] saveContext];
}

-(void)createOrgInfo:(NSString *)myid   
          belongtoid:(NSString *)belongtoid 
             orgname:(NSString *)orgname
        orgshortname:(NSString *)orgshortname
           orderdesc:(NSString *)orderdesc{
    NSManagedObject *usermodel=[NSEntityDescription insertNewObjectForEntityForName:@"OrgInfo" inManagedObjectContext:self.managedObjectContext];
    [usermodel setValue:myid forKey:@"myid"];
    [usermodel setValue:belongtoid forKey:@"belongtoid"];
    [usermodel setValue:orgname forKey:@"orgname"];
    [usermodel setValue:orgshortname forKey:@"orgshortname"];
    [usermodel setValue:orderdesc forKey:@"orderdesc"];
    NSError *error=nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }

}
-(void)createUserInfo:(NSString *)myid   
                orgid:(NSString *)orgid 
              account:(NSString *)account
             username:(NSString *)username{
    NSManagedObject *usermodel=[NSEntityDescription insertNewObjectForEntityForName:@"UserInfo" inManagedObjectContext:self.managedObjectContext];
    [usermodel setValue:myid forKey:@"myid"];
    [usermodel setValue:orgid forKey:@"orgid"];
    [usermodel setValue:account forKey:@"account"];
    [usermodel setValue:username forKey:@"username"];
    NSError *error=nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
}

-(NSString *)getUserName:(NSString *)account{
    NSError *error=nil;
    NSFetchRequest *fetchRequest =[[NSFetchRequest alloc]init];
    NSEntityDescription *entry=[NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entry];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"account == %@",account];
    [fetchRequest setPredicate:predicate];
    NSMutableArray *mutableFetchResults=[[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if (mutableFetchResults.count>0){
        UserInfo *userinfo=[mutableFetchResults objectAtIndex:0];
        NSString *username=userinfo.username;
        NSString *orgname=[self getOrgName:userinfo.organization_id];
        NSString *result=[NSString stringWithFormat:@"%@/%@",orgname,username];
        return result;        
    }else{
        return @"";
    } 
}

-(NSMutableArray *)getIconInfoByType:(NSString *)iconType{
    NSError *error=nil;
    NSFetchRequest *fetchRequest =[[NSFetchRequest alloc]init];
    NSEntityDescription *entry=[NSEntityDescription entityForName:@"IconModels" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entry];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"icontype == %@",iconType];
    NSSortDescriptor *iconNameSortDescriptor=[[NSSortDescriptor alloc] initWithKey:@"iconname" ascending:YES];
    NSArray *sortDescriptor=[NSArray arrayWithObjects:iconNameSortDescriptor,nil];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sortDescriptor];
    [fetchRequest setPredicate:predicate];
    NSMutableArray *mutableFetchResults=[[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    return mutableFetchResults;
}

-(NSMutableArray *)getIconInfoByName:(NSString *)iconName{
    NSError *error=nil;
    NSFetchRequest *fetchRequest =[[NSFetchRequest alloc]init];
    NSEntityDescription *entry=[NSEntityDescription entityForName:@"IconModels" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entry];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"iconname == %@",iconName];
    [fetchRequest setPredicate:predicate];
    return [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
}

-(NSMutableArray *)getAllOrgInfo:(NSString *)belongtoid{
    NSError *error=nil;
    NSFetchRequest *fetchRequest =[[NSFetchRequest alloc]init];
    NSEntityDescription *entry=[NSEntityDescription entityForName:@"OrgInfo" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entry];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"belongtoid == %@",belongtoid];
    NSSortDescriptor *orgnameSortDescriptor=[[NSSortDescriptor alloc] initWithKey:@"orgname" ascending:YES selector:@selector(localizedCompare:)];
    NSArray *sortDescriptor=[NSArray arrayWithObjects:orgnameSortDescriptor,nil];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sortDescriptor];
    return [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
}

-(NSString *)getOrgName:(NSString *)orgid{
    NSError *error=nil;
    NSFetchRequest *fetchRequest =[[NSFetchRequest alloc]init];
    NSEntityDescription *entry=[NSEntityDescription entityForName:@"OrgInfo" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entry];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"myid == %@",orgid];
    [fetchRequest setPredicate:predicate];
    NSMutableArray *mutableFetchResults=[[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if (mutableFetchResults.count>0){
        OrgInfo *org=[mutableFetchResults objectAtIndex:0];
        NSString *orgshortname=org.orgshortname;
        return orgshortname;
    }else{
        return @"";
    }
}


@end
