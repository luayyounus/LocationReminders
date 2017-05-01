//
//  ViewController.m
//  LocationReminders
//
//  Created by Luay Younus on 5/1/17.
//  Copyright © 2017 Luay Younus. All rights reserved.
//

#import "ViewController.h"

@import Parse;
@import MapKit;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //Create an object class on Heroku Dashboard (Server)
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    
    testObject[@"testName"] = @"Adam Wallraff";
    
    [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Success saving test object!");
        } else {
            NSLog(@"There was a problem saving. Save Error: %@", error.localizedDescription);
        }
    }];
    
    
    //Make a Query to that same object
    PFQuery *query = [PFQuery queryWithClassName:@"TestObject"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error){
            NSLog(@"%@", error.localizedDescription);
        } else {
            NSLog(@"Query Results %@", objects);
        }
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
