//
//  AddReminderViewController.m
//  LocationReminders
//
//  Created by Luay Younus on 5/2/17.
//  Copyright © 2017 Luay Younus. All rights reserved.
//

#import "AddReminderViewController.h"
#import "Reminder.h"
#import "LocationController.h"

@import MapKit;

@interface AddReminderViewController ()
@property (weak, nonatomic) IBOutlet UITextField *locationNameTextField;
@property (weak, nonatomic) IBOutlet UISlider *radiusSlider;
@property (weak, nonatomic) IBOutlet UIButton *saveLocationButtonPressed;
@property (strong, nonatomic) NSNumber *radius;

@end

@implementation AddReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self styling];
}

- (IBAction)radiusSliderValueChanged:(id)sender {
    NSNumber *radiusNumber = [NSNumber numberWithInteger:self.radiusSlider.value];
    self.radius = radiusNumber;
}

- (IBAction)saveLocation:(UIButton *)sender {
    
    Reminder *newReminder = [Reminder object];
    newReminder.name = self.locationNameTextField.text;
    newReminder.location = [PFGeoPoint geoPointWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
    newReminder.reminderRadius = [NSNumber numberWithFloat: self.radiusSlider.value];
    
    [newReminder saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
        NSLog(@"Save Reminder Successful:%i - Error: %@",succeeded,error.localizedDescription);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ReminderSavedToParse" object:nil];
        
        NSLog(@"Coordinates: %f,%f",self.coordinate.latitude,self.coordinate.longitude);
        
        if (self.completion) {
            MKCircle *circle = [MKCircle circleWithCenterCoordinate:self.coordinate radius:self.radiusSlider.value];
            
            if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
                CLCircularRegion *region = [[CLCircularRegion alloc]initWithCenter:self.coordinate radius:self.radiusSlider.value identifier:newReminder.name];
                [[LocationController shared]startMonitoringForRegion:region];
            }
            self.completion(circle);
        }
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)styling{
    UIView *LineView=[[UIView alloc]initWithFrame:CGRectMake(0, 130 , self.view.frame.size.width, 2)];
    [LineView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:LineView];
}



@end
