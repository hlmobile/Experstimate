//
//  CalendarViewController.m
//  Vizume
//
//  Created by devmania on 5/10/13.
//
//

#import "CalendarViewController.h"

@interface CalendarViewController ()

@end

@implementation CalendarViewController
@synthesize tag;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if( self )
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [datePicker setDate:[NSDate date] animated:YES];
    [UIView appearanceWhenContainedIn:[UITableView class], [UIDatePicker class], nil].backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    datePicker.backgroundColor = [UIColor blackColor];
}

- (void)dealloc
{
    [datePicker release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [datePicker release];
    datePicker = nil;
    [super viewDidUnload];
}

#pragma mark - Event
- (IBAction)onPresent:(id)sender
{
    if( self.delegate != nil )
    {
        if( [self.delegate respondsToSelector:@selector(presentClickedByCalendarViewController:)] )
            [self.delegate presentClickedByCalendarViewController:self];
    }
}

- (IBAction)onEmpty:(id)sender
{
    if( self.delegate != nil )
    {
        if( [self.delegate respondsToSelector:@selector(emptyClickedByCalendarViewController:)] )
            [self.delegate emptyClickedByCalendarViewController:self];
    }
}

- (void)datePickerValueChanged:(id)sender
{
    if( self.delegate != nil )
    {
        if( [self.delegate respondsToSelector:@selector(calendarViewController:setDate:)] )
            [self.delegate calendarViewController:self setDate:datePicker.date];
    }
}

@end