//
//  LocationPresetsViewController.m
//  LocationReminders
//
//  Created by Luay Younus on 5/2/17.
//  Copyright © 2017 Luay Younus. All rights reserved.
//

#import "LocationPresetsViewController.h"
#import "LocationController.h"
#import "HomeViewController.h"

@interface LocationPresetsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LocationPresetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[LocationController shared]allLocations]count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
//    CLLocation *location = [[[LocationController shared]allLocations] objectAtIndex:indexPath.row];
//    cell.textLabel.text = location.
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [self performSegueWithIdentifier:SOME IDENTIFIER sender:nil];
}

@end
