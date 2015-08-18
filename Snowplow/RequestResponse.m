//
//  RequestResponse.m
//  Snowplow
//
//  Copyright (c) 2013-2015 Snowplow Analytics Ltd. All rights reserved.
//
//  This program is licensed to you under the Apache License Version 2.0,
//  and you may not use this file except in compliance with the Apache License
//  Version 2.0. You may obtain a copy of the Apache License Version 2.0 at
//  http://www.apache.org/licenses/LICENSE-2.0.
//
//  Unless required by applicable law or agreed to in writing,
//  software distributed under the Apache License Version 2.0 is distributed on
//  an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
//  express or implied. See the Apache License Version 2.0 for the specific
//  language governing permissions and limitations there under.
//
//  Authors: Joshua Beemster
//  Copyright: Copyright (c) 2013-2015 Snowplow Analytics Ltd
//  License: Apache License Version 2.0
//

#import "Snowplow.h"
#import "RequestResponse.h"

@interface RequestResponse()

@property (nonatomic) BOOL isSuccess;
@property (nonatomic, weak) NSArray *indexArray;

@end

@implementation RequestResponse

- (id) initWithBool:(BOOL)success withIndex:(NSArray *)index {
    self = [super init];
    if (self) {
        _isSuccess = success;
        _indexArray = index;
    }
    return self;
}

- (BOOL) getSuccess {
    return _isSuccess;
}

- (NSArray *) getIndexArray {
    return _indexArray;
}

@end
