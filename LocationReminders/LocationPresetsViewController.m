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
@property(strong,nonatomic) NSMutableArray *allBookmarks;

@end

@implementation LocationPresetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    _allBookmarks = [[NSMutableArray alloc]init];
    
    CLLocation *location1 = [[CLLocation alloc]initWithLatitude:47.6201451 longitude:-122.3298646];
    LocationBookmarks *newBookmark1 = [[LocationBookmarks alloc]initBookmarkLocationWithName:@"Location 1" andLocation:location1];
    CLLocation *location2 = [[CLLocation alloc]initWithLatitude:47.6201451 longitude:-122.3298646];
    LocationBookmarks *newBookmark2 = [[LocationBookmarks alloc]initBookmarkLocationWithName:@"Location 2" andLocation:location2];
    
    [self.allBookmarks addObject:newBookmark1];
    [self.allBookmarks addObject:newBookmark2];
    NSLog(@"Bookmarks: %@",self.allBookmarks);
    
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!_allBookmarks){
        return 0;
    }
    return self.allBookmarks.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    LocationBookmarks* bookmark = [self.allBookmarks objectAtIndex:indexPath.row];
    
    cell.textLabel.text = bookmark.name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (IBAction)closeBookmarksTable:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
