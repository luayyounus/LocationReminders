//
//  AddReminderViewController.m
//  LocationReminders
//
//  Created by Luay Younus on 5/2/17.
//  Copyright © 2017 Luay Younus. All rights reserved.
//

#import "AddReminderViewController.h"
#import "Reminder.h"

@import MapKit;

@interface AddReminderViewController ()
@property (weak, nonatomic) IBOutlet UITextField *locationNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *radiusTextField;

@property (strong,nonatomic) NSString *locationName;
@property (strong,nonatomic) NSNumber *locationRadius;

@end

@implementation AddReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Reminder *newReminder = [Reminder object];
    
    newReminder.name = self.annotationTitle;
    newReminder.location = [PFGeoPoint geoPointWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
    
    [newReminder saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        self.locationName = self.locationNameTextField.text;
        self.locationRadius = (NSNumber *)self.radiusTextField.text;
    
        NSLog(@"Save Reminder Successful:%i - Error: %@",succeeded,error.localizedDescription);
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ReminderSavedToParse" object:nil];
        
        NSLog(@"Annotation Title: %@",self.annotationTitle);
        NSLog(@"Coordinates: %f,%f",self.coordinate.latitude,self.coordinate.longitude);
        
        if (self.completion) {
            NSNumber *radius = (NSNumber *)self.radiusTextField.text;
            MKCircle *circle = [MKCircle circleWithCenterCoordinate:self.coordinate radius:radius.floatValue];
            
            self.completion(circle);
            
        }
        [self.navigationController popViewControllerAnimated:YES];

    }];
    
    //drawing a single line
    [self styling];
}

-(void)styling{
    UIView *LineView=[[UIView alloc]initWithFrame:CGRectMake(0, 130 , self.view.frame.size.width, 2)];
    [LineView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:LineView];
}


@end
