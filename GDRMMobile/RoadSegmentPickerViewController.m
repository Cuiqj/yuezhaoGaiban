//
//  RoadSegmentPickerViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-9-19.
//
//

#import "RoadSegmentPickerViewController.h"
#import "Systype.h"

@interface RoadSegmentPickerViewController ()
@property (nonatomic,retain) NSArray *data;
@end

@implementation RoadSegmentPickerViewController
@synthesize data = _data;
@synthesize pickerPopover = _pickerPopover;
@synthesize pickerState = _pickerState;

- (void)viewWillAppear:(BOOL)animated{
    switch (self.pickerState) {
        case kRoadSegment:
            self.data=[RoadSegment allRoadSegments];
            break;
        case kRoadSide:
            self.data=[Systype typeValueForCodeName:@"方向"];
            break;
        case kRoadPlace:
            self.data=[Systype typeValueForCodeName:@"位置"];
            break;
        default:
            break;
    }
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setData:nil];
    [self setPickerPopover:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (self.pickerState==kRoadSegment) {
        cell.textLabel.text=[[self.data objectAtIndex:indexPath.row] valueForKey:@"name"];
    } else {
        cell.textLabel.text=[self.data objectAtIndex:indexPath.row];
    }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.pickerState) {
        case kRoadSegment:
            [self.delegate setRoadSegment:[[self.data objectAtIndex:indexPath.row] valueForKey:@"myid"] roadName:[RoadSegment roadNameFromSegment:[[self.data objectAtIndex:indexPath.row] valueForKey:@"myid"]]];
            break;
        case kRoadPlace:
            [self.delegate setRoadPlace:[self.data objectAtIndex:indexPath.row]];
            break;
        case kRoadSide:
            [self.delegate setRoadSide:[self.data objectAtIndex:indexPath.row]];
            break;
        default:
            break;
    }
    [self.pickerPopover dismissPopoverAnimated:YES];
}

@end
