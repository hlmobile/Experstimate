//
//  CalendarViewController.h
//  Vizume
//
//  Created by devmania on 5/10/13.
//
//

#import <UIKit/UIKit.h>


@protocol CalendarViewDelegate;
@interface CalendarViewController : UIViewController
{
    
    IBOutlet UIDatePicker *datePicker;
    
    NSInteger tag;
    id<CalendarViewDelegate> delegate;
}
@property ( assign ) NSInteger tag;
@property ( retain ) id<CalendarViewDelegate> delegate;

- (IBAction)onPresent:(id)sender;
- (IBAction)onEmpty:(id)sender;

@end


@protocol CalendarViewDelegate <NSObject>
@optional
- (void)presentClickedByCalendarViewController:(CalendarViewController *)controller;
- (void)emptyClickedByCalendarViewController:(CalendarViewController *)controller;
- (void)calendarViewController:(CalendarViewController *)controller setDate:(NSDate *)date;
@end