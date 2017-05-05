//
//  HomeViewController.m
//  LocationReminders
//
//  Created by Luay Younus on 5/1/17.
//  Copyright © 2017 Luay Younus. All rights reserved.
//

#import "HomeViewController.h"
#import "AddReminderViewController.h"
#import "LocationController.h"
#import "Reminder.h"

@import Parse;
@import MapKit;
@import ParseUI;

@interface HomeViewController()<LocationControllerDelegate,MKMapViewDelegate,PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property(weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[LocationController shared] requestPermission];
    [LocationController shared].delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reminderSavedToParse:) name:@"ReminderSavedToParse" object:nil];
    
    [PFUser logOut];
    
    if (![PFUser currentUser]) {
        PFLogInViewController *loginViewController = [[PFLogInViewController alloc]init];
        
        loginViewController.delegate = self;
        loginViewController.signUpController.delegate = self;
        loginViewController.logInView.logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LocationRemindersLogo.png"]];
        [loginViewController.logInView.logo setContentMode:UIViewContentModeScaleAspectFit];
        loginViewController.fields = PFLogInFieldsLogInButton | PFLogInFieldsSignUpButton | PFLogInFieldsUsernameAndPassword | PFLogInFieldsDismissButton;
        
        [self presentViewController:loginViewController animated:YES completion:nil];
    }
}

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [self fetchQuery];
}


-(void)reminderSavedToParse:(id)sender{
    NSLog(@"Do some stuff since our new reminder was saved!");
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"AddReminderViewController"] && [sender isKindOfClass:[MKAnnotationView class]]) {
        MKAnnotationView *annotationView = (MKAnnotationView *) sender;
        
        AddReminderViewController *newReminderViewController = (AddReminderViewController *)segue.destinationViewController;
        
        newReminderViewController.coordinate = annotationView.annotation.coordinate;
        newReminderViewController.annotationTitle = annotationView.annotation.title;
        newReminderViewController.title = annotationView.annotation.title;
        
        __weak typeof(self) bruce = self;
        
        newReminderViewController.completion = ^(MKCircle *circle){
            __strong typeof (bruce) hulk = bruce;
            
            [hulk.mapView removeAnnotation:annotationView.annotation];
            [hulk.mapView addOverlay:circle];
        };
    }
}

-(void)fetchQuery{
    PFQuery *query = [PFQuery queryWithClassName:@"Reminder"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            for (Reminder *reminder in objects) {
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(reminder.location.latitude, reminder.location.longitude);
                MKCircle *circle = [MKCircle circleWithCenterCoordinate:coordinate radius:[reminder.reminderRadius doubleValue]];
                [self.mapView addOverlay:circle];
            }
        }
    }];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ReminderSavedToParse" object:nil];
}

- (IBAction)locationsButtonPressed:(id)sender {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(47.6566674, -122.351096);
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 500.0, 500.0);
    
    [self.mapView setRegion:region animated:YES];
    
    MKPointAnnotation *pinLoc = [[MKPointAnnotation alloc]init];
    
    if (self.mapView.annotations.count > 0) {
        [self.mapView removeAnnotations:self.mapView.annotations];
    }

    pinLoc.coordinate = coordinate;
    [self.mapView addAnnotation:pinLoc];
    
}

- (IBAction)userLongPressed:(UILongPressGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint touchPoint = [sender locationInView:self.mapView];
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        
        MKPointAnnotation *newPoint = [[MKPointAnnotation alloc]init];
        
        newPoint.coordinate = coordinate;
        newPoint.title = @"New Reminder";
        
        if (self.mapView.annotations.count > 0) {
            [self.mapView removeAnnotations:self.mapView.annotations];
        }
        [self.mapView addAnnotation:newPoint];
    }
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass: [MKUserLocation class]]) {
        return nil;
    }
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"annotationView"];
    
    annotationView.annotation = annotation;
    
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"annotationView"];
    }
    
    annotationView.canShowCallout = YES;
    annotationView.animatesDrop = YES;
    [self randomPinColor:annotationView];
    
    UIButton *rightCalloutAccessory = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    UIButton *leftCalloutAccessory = [UIButton buttonWithType:UIButtonTypeContactAdd];
    
    annotationView.rightCalloutAccessoryView = rightCalloutAccessory;
    annotationView.leftCalloutAccessoryView = leftCalloutAccessory;
    
    
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    [self performSegueWithIdentifier:@"AddReminderViewController" sender:view];

}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    MKCircleRenderer *renderer = [[MKCircleRenderer alloc]initWithCircle:overlay];
    
    renderer.strokeColor = [UIColor blueColor];
    renderer.fillColor = [UIColor redColor];
    renderer.alpha = 0.25;
    
    return renderer;
}

- (void)locationControllerUpdatedLocation:(CLLocation *)location{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500.0, 500.0);
    
    [self.mapView setRegion:region animated:YES];
}


-(void)bookmarkingTheLocation:(CLLocation *)location{
    if (!_bookmarkedLocations){
        _bookmarkedLocations = [[NSMutableArray alloc]init];
        
    }

}

#pragma mark - Random Color for Pin
-(void)randomPinColor:(MKPinAnnotationView *)annotationView{
    CGFloat red = arc4random() % 255/255.0;
    CGFloat green = arc4random() % 255/255.0;
    CGFloat blue = arc4random() % 255/255.0;
    UIColor *randomPinColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    annotationView.pinTintColor = randomPinColor;
}

@end
