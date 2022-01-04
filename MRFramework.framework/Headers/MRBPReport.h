//
//  MRBPReport.h
//  MRFramework
//
//  Created by Ulric on 27/11/2021.
//  Copyright © 2021 Superman. All rights reserved.
//

#import <MRFramework/MRFramework.h>

NS_ASSUME_NONNULL_BEGIN

@interface MRBPReport : MRReport


@property (nonatomic, assign) int data_type;
@property (nonatomic, assign) int protocol;
@property (nonatomic, assign) int frame_count;
@property (nonatomic, assign) int data_block_size;
@property (nonatomic, assign) uint8_t status;
@property (nonatomic, assign) uint8_t flag;

@property (nonatomic, strong) NSArray *ecg;



@end

NS_ASSUME_NONNULL_END
