//
//  Project.m
//  GDRMMobile
//
//  Created by Sniper One on 12-11-15.
//
//

#import "Project.h"


@implementation Project

@dynamic inite_node_id;
@dynamic inituser_account;
@dynamic myid;
@dynamic process_id;
@dynamic process_name;
@dynamic start_time;
@dynamic isuploaded;

- (NSString *) signStr{
    if (![self.myid isEmpty]) {
        return [NSString stringWithFormat:@"myid == %@", self.myid];
    }else{
        return @"";
    }
}

@end
