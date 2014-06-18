//
//  SnowplowEventStore.h
//  Snowplow
//
//  Copyright (c) 2013-2014 Snowplow Analytics Ltd. All rights reserved.
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
//  Authors: Jonathan Almeida
//  Copyright: Copyright (c) 2013-2014 Snowplow Analytics Ltd
//  License: Apache License Version 2.0
//

#import "SnowplowEventStore.h"
#import "SnowplowPayload.h"
#import "SnowplowUtils.h"
#import <FMDB.h>

@implementation SnowplowEventStore {
    @private
    NSString *      _dbPath;
    NSString *      _queryCreateTable;
    NSString *      _querySelectAll;
    NSString *      _queryInsertEvent;
    NSString *      _querySelectId;
    NSString *      _appId;
    FMDatabase *    _db;
}

- (id) init {
    self = [super init];
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    _dbPath = [libraryPath stringByAppendingPathComponent:@"snowplowEvents.sqlite"];
    if(self){
        _db = [FMDatabase databaseWithPath:_dbPath];
        _appId = [SnowplowUtils getAppId];
        
        _queryCreateTable   = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' (id INTEGER PRIMARY KEY AUTOINCREMENT, eventData BLOB, pending INTEGER, dateCreated TIMESTAMP DEFAULT CURRENT_TIMESTAMP)", _appId];
        _querySelectAll     = [NSString stringWithFormat:@"SELECT * FROM '%@'", _appId];
        _querySelectId      = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE ID=?", _appId];
        _queryInsertEvent   = [NSString stringWithFormat:@"INSERT INTO '%@' (eventData, pending) VALUES (?, 0)", _appId];

        
        if([_db open]) {
            NSLog(@"db description: %@", [_db databasePath]);
        } else {
            NSLog(@"Shit happened");
        }
        [_db close];
    }
    return self;
}

- (void) setAppId:(NSString *)appId {
    _appId = appId;
}

- (NSString *) getAppId {
    return _appId;
}

- (BOOL) createTableWithBundleId:(NSString *)bundleId {
    if([_db open]) {
        // Create table if not exists
        return [_db executeStatements:_queryCreateTable];
    } else {
        return false;
    }
}

- (BOOL) insertEvent:(SnowplowPayload *)payload {
    if([_db open]) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:[payload getPayload] options:0 error:nil];
        return [_db executeUpdate:_queryInsertEvent, [data bytes]];
    } else {
        return false;
    }
}

- (void) getTable {
    if([_db open]) {
        FMResultSet *s = [_db executeQuery:_querySelectAll];
        while ([s next]) {
            int index = [s intForColumn:@"ID"];
            NSData * data =[s dataForColumn:@"eventData"];
            NSDate * date = [s dateForColumn:@"dateCreated"];
            NSLog(@"Item: %d %@ %@", index, date, data);
        }
    }
}

// Should never be used realistically
- (BOOL) getEventWithId:(NSNumber*) id {
    if([_db open]) {
        FMResultSet *s = [_db executeQuery:_querySelectId, id];
        while ([s next]) {
            int index = [s intForColumn:@"ID"];
            NSData * data =[s dataForColumn:@"eventData"];
            NSDate * date = [s dateForColumn:@"dateCreated"];
            NSLog(@"Item: %d %@ %@", index, date, data);
        }
        return true;
    } else {
        return false;
    }
}

- (NSDictionary *) getAllEvents {
    NSDictionary *res;
    if([_db open]) {
        FMResultSet *s = [_db executeQuery:_querySelectAll];
        while ([s next]) {
            int index = [s intForColumn:@"ID"];
            NSData * data =[s dataForColumn:@"eventData"];
            NSDate * date = [s dateForColumn:@"dateCreated"];
            NSLog(@"Item: %d %@ %@", index, date, data);
        }
    }
    return res;
}

@end
