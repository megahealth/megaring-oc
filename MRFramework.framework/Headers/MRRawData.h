//
//  MRRawData.h
//  MRFramework
//
//  Created by Ulric on 26/8/2021.
//  Copyright © 2021 Superman. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MRRawData : NSObject

@property (assign) int red;
@property (assign) int infrared;

/// Added in 5.0 series firmware
@property (assign) int ambient;




@end

NS_ASSUME_NONNULL_END
