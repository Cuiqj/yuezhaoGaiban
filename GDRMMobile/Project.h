//
//  Project.h
//  GDRMMobile
//
//  Created by Sniper One on 12-11-15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseManageObject.h"

@interface Project : BaseManageObject

@property (nonatomic, retain) NSString * inite_node_id;
@property (nonatomic, retain) NSString * inituser_account;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * process_id;
@property (nonatomic, retain) NSString * process_name;
@property (nonatomic, retain) NSDate * start_time;
@property (nonatomic, retain) NSNumber * isuploaded;

@end
