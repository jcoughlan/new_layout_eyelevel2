//
//  MapViewController.m
//  EyeLevel
//
//  Created by Apple on 15/11/2011.
//  Copyright (c) 2011 Fluid Pixel. All rights reserved.
//

#import "MapViewController.h"
#import "UIVideoCaptureViewController.h"

#import "EyeLevelAsset.h"
#import "EyeLevelUserLocation.h"

#import "CLLocationCoordinate2D+OSGB.h"


@interface MapViewController (Private)
- (void) searchAutocompleteEntriesWithSubstring:(NSString *)substring;
- (void) zoomToAsset:(EyeLevelAsset*) asset;
@end

@implementation MapViewController
@synthesize mapView;
@synthesize autoCompleteTableView;
@synthesize searchView;
@synthesize searchField;
@synthesize lockButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        m_AutoCompleteAssets = [[NSMutableArray alloc] init];
        m_ARView = [[UIVideoCaptureViewController alloc] initWithNibName:@"UIVideoCaptureView" bundle:nil];
        m_UserLocation = [[EyeLevelUserLocation alloc] init];
        m_UserLocation.delegate = self;
        
    }
    return self;
}

-(void) dealloc
{
    self.autoCompleteTableView = nil;
    self.mapView = nil;
    self.searchView = nil;
    
    [m_AutoCompleteAssets release];
    [m_ARView release];
    
    [_mapSwitchButton release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [EyeLevelAssetManager sharedInstance].delegate = self;
    [[EyeLevelAssetManager sharedInstance] loadAssets];
    
    self.mapView.delegate = self;
	self.mapView.showsUserLocation = YES;
    
    //default to Hybrid Map
    self.mapView.mapType = MKMapTypeHybrid;
    
    //hide the map switch button (may need it in the future)?
    self.mapSwitchButton.hidden = YES;
    
    [self.mapView addAnnotation:m_UserLocation];
    
    //hide live/manual button
    self.lockButton.hidden = YES;
    
    m_InitialisedInitialZoom = NO;
    m_InternetFailed = NO;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.autoCompleteTableView = nil;
    self.mapView = nil;
    self.searchView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark - Private Methods
- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring
{
    // Put anything that starts with this substring into the autocompleteUrls array
    // The items in this array is what will show up in the table view
    [m_AutoCompleteAssets removeAllObjects];
    
    for(EyeLevelAsset *asset in [[EyeLevelAssetManager sharedInstance] getAssets])
    {
        NSRange substringRange = [asset.title rangeOfString:substring options:NSCaseInsensitiveSearch];
        if (substringRange.location == 0)
        {
            [m_AutoCompleteAssets addObject:asset];
            NSLog(@"adding%@", asset.title);
        }
    }
    
    if( [m_AutoCompleteAssets count] > 0 )
    {
        self.autoCompleteTableView.hidden = NO;
    }
    else
    {
        self.autoCompleteTableView.hidden = YES;
    }
    
    [self.autoCompleteTableView reloadData];
}

- (void) zoomToAsset:(EyeLevelAsset*) asset
{
    [self.mapView setCenterCoordinate:asset.coordinate animated:YES];
    
    MKCoordinateRegion region;
    region.center = asset.coordinate;
    
    MKCoordinateSpan span;
    span.latitudeDelta  = 0.001; // Change these values to change the zoom
    span.longitudeDelta = 0.001;
    region.span = span;
    
    
    [self.mapView setRegion:region animated:YES];
    [self.mapView selectAnnotation:asset animated:YES];
}


#pragma mark - EyeLevelUserLocation Delegate Methods
-(void) eyeLevelUserLocation:(EyeLevelUserLocation*)userLocation didUpdateToLocation:(CLLocation*)location
{
    
    self.lockButton.selected = userLocation.manualPositioning;
    [m_ARView eyeLevelUserLocation:userLocation didUpdateToLocation:location];
}

#pragma mark - EyeLevelAssetManagerDelegate Methods
-(void) onAssetLoaded:(EyeLevelAsset*)asset
{
    [mapView addAnnotation: asset];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [m_AutoCompleteAssets count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   	UITableViewCell *cell = [self.autoCompleteTableView dequeueReusableCellWithIdentifier:@"mapViewAutoCompleteCell"];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"mapViewAutoCompleteCell"] autorelease];
    }
    
    cell.textLabel.text = [(EyeLevelAsset*)[m_AutoCompleteAssets objectAtIndex:indexPath.row] title];
    return cell;
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    [self searchAutocompleteEntriesWithSubstring:substring];
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EyeLevelAsset* selectedAsset = [m_AutoCompleteAssets objectAtIndex:indexPath.row];
    
    [self hideSearchMechanism:self];
    [self zoomToAsset:selectedAsset];
}


#pragma mark - MKMapViewDelegate's


// mapView:viewForAnnotation: provides the view for each annotation.
// This method may be called for all or some of the added annotations.
// For MapKit provided annotations (eg. MKUserLocation) return nil to use the MapKit provided annotation view.

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if( [annotation isKindOfClass: [EyeLevelUserLocation class]] )
	{
        //attempt to re-use old pin views.
		MKAnnotationView* pinView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"mapViewUserAnnotation"];
        
        if( !pinView )
        {
            pinView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"mapViewUserAnnotation"] autorelease];
        }
        
        pinView.canShowCallout = NO;
        pinView.annotation = annotation;
        
        pinView.image = [UIImage imageNamed:@"location_free.png"];
		pinView.hidden = !self.lockButton.selected;
        pinView.draggable = YES;
		
		NSLog(@"Created Manual User annotation view");
		
        return pinView;
    }
    else if( [annotation isKindOfClass: [EyeLevelAsset class]] )
    {
        NSLog(@"about to add annotation");
        //attempt to re-use old pin views.
		MKAnnotationView* pinView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"mapViewAnnotation"];
        
        if( !pinView )
        {
            pinView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"mapViewAnnotation"] autorelease];
        }
        
        
        pinView.annotation = annotation;
        if([((EyeLevelAsset*)annotation) getModelForModelNum:0] == nil)
        {
            pinView.image = [UIImage imageNamed:@"pin_corner.png"];
            pinView.canShowCallout = NO;
            pinView.enabled = NO;
        }
        else
        {
            pinView.image = [UIImage imageNamed:@"pin.png"];
            pinView.centerOffset = CGPointMake(0, -21);
            pinView.canShowCallout = YES;
            
            if( ((EyeLevelAsset*)annotation).thumbnailPath )
            {
                UIImageView* thumbnailImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:((EyeLevelAsset*)annotation).thumbnailPath]];
                [thumbnailImageView setFrame: CGRectMake(0, 0, 30, 30)];
                pinView.leftCalloutAccessoryView = thumbnailImageView;
                [thumbnailImageView release];
            }
        }
		NSLog(@"Created EyeLevelAsset annotation view");
		
        return pinView;
    }
    
    NSLog(@"Created User annotation view");
    return nil;
}


// mapView:didAddAnnotationViews: is called after the annotation views have been added and positioned in the map.
// The delegate can implement this method to animate the adding of the annotations views.
// Use the current positions of the annotation views as the destinations of the animation.
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{}

// mapView:annotationView:calloutAccessoryControlTapped: is called when the user taps on left & right callout accessory UIControls.
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    if(m_InternetFailed == NO)
    {
        [[[[UIAlertView alloc] initWithTitle: @"Error"
                                     message: @"Cannot display map, this is probably because you haven't got an Internet connection."
                                    delegate: nil
                           cancelButtonTitle: @"Dismiss"
                           otherButtonTitles: nil] autorelease] show];
        m_InternetFailed = YES;
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if( [view.annotation isKindOfClass: [EyeLevelAsset class]] )
    {
        //  view.image = [UIImage imageNamed:@"pin_highlight.png"];
        // [view setDragState:MKAnnotationViewDragStateDragging animated:NO];
        //       NSLog(@"our map marker");
    }
	else if( [view.annotation isKindOfClass:[MKUserLocation class]] )
	{
        if(  m_UserLocation.manualPositioning == YES )
        {
            NSLog(@"selected manual pin");
            m_UserLocation.manualPositioning = NO;
            self.lockButton.selected = NO;
            
            MKAnnotationView* manualUserLocation = [self.mapView viewForAnnotation:m_UserLocation];
            MKAnnotationView* standardUserLocation = [self.mapView viewForAnnotation:self.mapView.userLocation];
            
            manualUserLocation.hidden = YES;
            //when switching to manual, give it the auto pin location
            m_UserLocation.coordinate = self.mapView.userLocation.coordinate;
            
            standardUserLocation.hidden = NO;
            manualUserLocation.selected = NO;
            standardUserLocation.selected = YES;
        }
        else
        {
            NSLog(@"selected auto pin");
            m_UserLocation.manualPositioning = YES;
            MKAnnotationView* manualUserLocation = [self.mapView viewForAnnotation:m_UserLocation];
            MKAnnotationView* standardUserLocation = [self.mapView viewForAnnotation:self.mapView.userLocation];
            manualUserLocation.hidden = NO;
            
            //when switching to manual, give it the auto pin location
            m_UserLocation.coordinate = self.mapView.userLocation.coordinate;
            
            standardUserLocation.hidden = YES;
            manualUserLocation.selected = YES;
            standardUserLocation.selected = NO;
        }
        
        // CLLocationCoordinate2D center = self.mapView.centerCoordinate;
        //self.mapView.centerCoordinate = center;
    }
    else
    {
        NSLog(@"neither of them selected");
    }
    
}


- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView
{
    
}

- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView
{
    
}

- (void)mapView:(MKMapView *)mapView2 didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    NSLog(@"did update user location: %f and %f", mapView.userLocation.coordinate.longitude, mapView.userLocation.coordinate.latitude);
    if(m_InitialisedInitialZoom == NO && mapView.userLocation.location.horizontalAccuracy < 100 && mapView.userLocation.location.horizontalAccuracy > 0)
    {
        MKCoordinateRegion region;
        //region.center = mapView.userLocation;
        region.center = mapView.userLocation.coordinate;
        MKCoordinateSpan span;
        span.latitudeDelta  = 0.01; // Change these values to change the zoom
        span.longitudeDelta = 0.01;
        region.span = span;
        
        [self.mapView setRegion:region animated:YES];
        
        m_InitialisedInitialZoom = YES;
    }
}
- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    
}

/*
 - (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
 {
 
 }
 */

// Called after the provided overlay views have been added and positioned in the map.
- (void)mapView:(MKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews
{
    
}

#pragma mark - IBActions

- (IBAction) lockButtonPressed:(id)sender
{
    if( self.lockButton.selected )
    {
        m_UserLocation.manualPositioning = NO;
        self.lockButton.selected = NO;
		
		MKAnnotationView* manualUserLocation = [self.mapView viewForAnnotation:m_UserLocation];
		MKAnnotationView* standardUserLocation = [self.mapView viewForAnnotation:self.mapView.userLocation];
		
		manualUserLocation.hidden = YES;
		standardUserLocation.hidden = NO;
    }
    else
    {
        m_UserLocation.manualPositioning = YES;
        self.lockButton.selected = YES;
		
		MKAnnotationView* manualUserLocation = [self.mapView viewForAnnotation:m_UserLocation];
		MKAnnotationView* standardUserLocation = [self.mapView viewForAnnotation:self.mapView.userLocation];
        
		manualUserLocation.hidden = NO;
		standardUserLocation.hidden = YES;
    }
    
    CLLocationCoordinate2D center = mapView.centerCoordinate;
    mapView.centerCoordinate = center;
}

- (IBAction) showSearchMechanism:(id)sender
{
    self.searchView.hidden = NO;
}

- (IBAction) hideSearchMechanism:(id)sender
{
    self.searchView.hidden = YES;
    [self.searchField resignFirstResponder];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSLog(@"Yes Button");
        
        // stop requesting location updates
  //  m_UserLocation.
        // send user to AR view
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration: 1];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:YES];
        [self.navigationController pushViewController:m_ARView animated:NO];
        [m_ARView resetCameraAnimation];
        [UIView commitAnimations];
    }
    else
    {
        NSLog(@"No Button");
        // Any action can be performed here
    }
}

-(IBAction)cameraButtonPressed:(id)sender
{
    //ask user if they are sure they want to use this location
    UIAlertView* alert = [[UIAlertView alloc] init];
    [alert setTitle:@"Confirm Location"];
    [alert setMessage:@"Are you sure you want to use this location?"];
    [alert addButtonWithTitle:@"Yes"];
    [alert addButtonWithTitle:@"No"];
    [alert setDelegate:self];
    [alert show];
    [alert release];
    
}

-(IBAction)mapModeButtonPressed:(id)sender
{
    UIButton* button = (UIButton*) sender;
    if( button.selected )
    {
        self.mapView.mapType = MKMapTypeStandard;
        button.selected = false;
    }
    else
    {
        self.mapView.mapType = MKMapTypeHybrid;
        button.selected = true;
    }
}


@end
