

#import "BPReportViewController.h"
#import "BPReportView.h"
#import "BPReportViewModel.h"
#import <MRFramework/MRFramework.h>

@interface BPReportViewController ()
@property (nonatomic, strong) MRBPReport *report;
@property (strong, nonatomic) IBOutlet BPReportView *_view;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *shareItem;
@property (nonatomic, strong) UIActivityViewController *activityVC;

@end

@implementation BPReportViewController

- (instancetype)initWithReport:(MRBPReport *)report {
    if (self = [super init]) {
        self.report = report;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =  @"Blood pressure report details";
//    NSLocalizedString(MHReportDetail, nil);
    [self loadReport];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self._view.model.ecg = self.report.ecg;
    [self._view updateEcg];
}

- (void)loadReport {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.report.startTime];
    self._view.model.date = localizedStringFromDate(date, @"yyyyMMMMd");
    self._view.model.pr = [NSString stringWithFormat:@"%d", self.report.avgPr];
    self._view.model.sbp = [NSString stringWithFormat:@"%.1f", self.report.SBP];
    self._view.model.dbp = [NSString stringWithFormat:@"%.1f", self.report.DBP];
    [self._view updateData];

    
////    parse ecg :
//    NSNumber * sbp = [[NSUserDefaults standardUserDefaults]objectForKey:@"UserID_SBP"];
//
//    NSNumber * dbp = [[NSUserDefaults standardUserDefaults]objectForKey:@"UserId_DBP"];
//
//    NSLog(@"sbp------%@------dbp-------%@",sbp,dbp);
//    [MRApi parseBPData:self.report.data time:self.parseTime caliSBP:sbp.doubleValue caliDBP:dbp.doubleValue block:^(MRBPReport *report, NSError *error) {
//
//// ***   or  in  viewDidAppear: open notes.
//        self._view.model.ecg = report.ecg;
//        [self._view updateEcg];
//
//    }];

}

- (IBAction)shareClicked:(UIBarButtonItem *)sender {

    
}




@end
