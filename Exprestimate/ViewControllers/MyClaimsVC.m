//
//  MyClaimsVC.m
//  Exprestimate
//
//  Created by devmania on 3/4/14.
//  Copyright (c) 2014 HybridClaims. All rights reserved.
//

#import "MyClaimsVC.h"
#import "CustomCell.h"
#import "MyCustomCell.h"
#import "KElement.h"
#import "ParserXML.h"
#import "ActivityIndicator.h"
#import "MyClaimDetailVC.h"
#import "SettingVC.h"
#import "WKPagesCollectionView.h"

#define kGetFormsURL    @"http://198.66.209.87/API/getForms.php"

@interface MyClaimsVC ()<WKPagesCollectionViewDataSource,WKPagesCollectionViewDelegate>
{
    WKPagesCollectionView* _collectionView;
}

@end

@implementation MyClaimsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.formsArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CustomCellReuseID"];
    
    _collectionView=[[[WKPagesCollectionView alloc] initWithPagesFlowLayoutAndFrame:CGRectMake(0.0f, 0.0f, self.drawingView.frame.size.width, self.drawingView.frame.size.height)] autorelease];
    _collectionView.dataSource=self;
    _collectionView.delegate=self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[WKPagesCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.drawingView addSubview:_collectionView];
    _collectionView.maskShow=YES;
    [self fetchData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) fetchData
{
    [self.formsArray removeAllObjects];
    NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
    NSString *udid = [oNSUUID UUIDString];
    
    NSURL *aUrl = [NSURL URLWithString:kGetFormsURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"*****com.hybridclaims.formboundary";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData * postBody = [NSMutableData data];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"UDID"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[udid dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:postBody];
    [request setValue:[NSString stringWithFormat:@"%d", [postBody length]] forHTTPHeaderField:@"Content-Length"];
    
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request
                                                                 delegate:self];
    
    self.maskView.hidden = NO;
    [[ActivityIndicator currentIndicator] displayActivity:@"Loading..."];
}

#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)response
{
    self.data = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)receivedData
{
    [self.data appendData:receivedData];
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    NSString * xml = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", xml);
    
    self.maskView.hidden = YES;
    [[ActivityIndicator currentIndicator] hide];
    
    KElement * rootElement = [ParserXML parse:xml];
    
    NSString *status = [rootElement getValueOfTag:@"status"];
    
    if( [status isEqualToString:@"ok"] )
    {
        NSArray* arrItems = ((KElement*)[rootElement.chld objectAtIndex:1]).chld;
        
        for(int k = 0;k<arrItems.count;k++)
        {
            NSArray* tempArrItems = ((KElement*)[arrItems objectAtIndex:k]).chld;
            
            NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
            
            for(int i = 0; i<tempArrItems.count; i++)
            {
                KElement* tmp = [tempArrItems objectAtIndex:i];
                [tempDict setObject:tmp.val forKey:tmp.tag];
            }
            
            [self.formsArray addObject:tempDict];
        }
        
        [self.tableView reloadData];
        [_collectionView reloadData];
    }
}

#pragma mark - UICollectionViewDataSource and UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.formsArray count];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //    NSLog(@"cellForItemAtIndexPath:%d",indexPath.row);
    static NSString* identity=@"cell";
    WKPagesCollectionViewCell* cell=(WKPagesCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identity forIndexPath:indexPath];
    cell.collectionView=collectionView;
    
    MyCustomCell *myCellView = [[MyCustomCell alloc] initWithNibName:@"MyCustomCell" bundle:nil];
    NSDictionary *aRecord = [self.formsArray objectAtIndex:indexPath.row];
    myCellView.strName = [aRecord objectForKey:@"Name"];
    myCellView.strClaimNo = [aRecord objectForKey:@"ClaimNumber"];
    myCellView.strDateSubmitted = [aRecord objectForKey:@"ReportDate"];
    myCellView.strDateofLoss = [aRecord objectForKey:@"DateofLoss"];
    
    [cell.cellContentView addSubview:myCellView.view];
    return cell;
}

-(void)collectionView:(WKPagesCollectionView*)collectionView didShownToHightlightAtIndexPath:(NSIndexPath*)indexPath
{
    [_collectionView dismissFromHightLightWithCompletion:^(BOOL finished) {
        NSLog(@"dismiss completed");
    }];
    MyClaimDetailVC *nextVC = [[MyClaimDetailVC alloc] initWithNibName:@"MyClaimDetailVC" bundle:nil];
    nextVC.aFormDic = [self.formsArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:nextVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.formsArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomCellReuseID";
    CustomCell *cell = (CustomCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.layer.cornerRadius = 5.0;
    cell.layer.borderColor = [UIColor colorWithRed:82.0/255 green:174.0/255 blue:206.0/255 alpha:1].CGColor;
    cell.layer.masksToBounds = YES;
    
    NSDictionary *aRecord = [self.formsArray objectAtIndex:indexPath.row];
    cell.itemName.text = [aRecord objectForKey:@"Name"];
    cell.itemClaimNO.text = [aRecord objectForKey:@"ClaimNumber"];
    cell.itemDateSubmitted.text = [aRecord objectForKey:@"ReportDate"];
    cell.itemDateofLoss.text = [aRecord objectForKey:@"DateofLoss"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyClaimDetailVC *nextVC = [[MyClaimDetailVC alloc] initWithNibName:@"MyClaimDetailVC" bundle:nil];
    nextVC.aFormDic = [self.formsArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onEmailUS:(id)sender {
    MFMailComposeViewController * controller = [[[MFMailComposeViewController alloc] init] autorelease];
    [controller.view setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]];
    
    if ( [MFMailComposeViewController canSendMail] ) {
        controller.mailComposeDelegate = self;
        [controller setSubject:@"Feedback"];
        [controller setToRecipients:[NSArray arrayWithObjects:@"support@hybridclaims.com",nil]];
        [self.navigationController presentViewController:controller animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    NSString * messageResult ;
	switch (result)
	{
		case MFMailComposeResultCancelled:
			messageResult = @"Mail canceled.";
			break;
		case MFMailComposeResultSaved:
			messageResult = @"Mail saved.";
			break;
		case MFMailComposeResultSent:
			messageResult = @"Mail sended.";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Email has been successfully sent." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
			break;
		case MFMailComposeResultFailed:
			messageResult = @"Mail failed.";
			break;
		default:
			messageResult = @"Mail don't send.";
			break;
	}
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onCallUS:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:9413095310"]];
}

- (IBAction)onSetting:(id)sender {
    SettingVC *nextVC = [[SettingVC alloc] initWithNibName:@"SettingVC" bundle:nil];
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (IBAction)onLogo:(id)sender {
    NSURL *myURL = [NSURL URLWithString:@"http://www.hybridclaims.com"];
    
    if( [[UIApplication sharedApplication] canOpenURL:myURL] )
        [[UIApplication sharedApplication] openURL:myURL];
}

- (void)dealloc {
    [_maskView release];
    [_drawingView release];
    [super dealloc];
}
@end
