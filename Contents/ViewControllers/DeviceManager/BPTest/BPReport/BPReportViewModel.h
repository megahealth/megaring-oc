//
//  BPReportViewModel.h
//  BHealth
//
//  Created by Ulric on 15/11/2021.
//  Copyright © 2021 zhaoguan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BPReportViewModel : NSObject

@property (nonatomic, copy) NSString *date;

@property (nonatomic, copy) NSString *pr;

@property (nonatomic, copy) NSString *sbp;

@property (nonatomic, copy) NSString *dbp;

@property (nonatomic, strong) NSArray *ecg;



@end

NS_ASSUME_NONNULL_END
