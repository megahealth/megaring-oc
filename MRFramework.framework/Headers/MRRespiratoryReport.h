//
//  MRRespiratoryReport.h
//  MRFramework
//
//  Created by mjz on 2023/11/24.
//  Copyright © 2023 Superman. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MRRespiratoryReport : NSObject

@property (nonatomic, strong) NSArray <NSNumber *>*breathrate;
@property (nonatomic, assign) int start_time;
@property (nonatomic, assign) int length_br;
@property (nonatomic, assign) float max_br;
@property (nonatomic, assign) float min_br;
@property (nonatomic, assign) float avg_br;

@end

