//
//  MRDailyReport.h
//  MRFramework
//
//  Created by Ulric on 27/11/2021.
//  Copyright © 2021 Superman. All rights reserved.
//

#import <MRFramework/MRFramework.h>



@interface MRDailyReport : NSObject

@property (nonatomic, assign) int startTime;

@property (nonatomic, assign) int endTime;


/// steps between startTime and endTime
@property (nonatomic, assign) int steps;

// ten times the Celsius degree.
@property (nonatomic, assign) int temperature;

// algorithm version
@property (nonatomic, assign) int algVer;





@end


