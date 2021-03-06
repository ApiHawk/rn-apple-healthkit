#import "RCTAppleHealthKit+Methods_Vitals.h"
#import "RCTAppleHealthKit+Queries.h"
#import "RCTAppleHealthKit+Utils.h"

@implementation RCTAppleHealthKit (Methods_Vitals)


- (void)vitals_getHeartRateSamples:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback
{
    HKQuantityType *heartRateType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];

    HKUnit *count = [HKUnit countUnit];
    HKUnit *minute = [HKUnit minuteUnit];

    HKUnit *unit = [RCTAppleHealthKit hkUnitFromOptions:input key:@"unit" withDefault:[count unitDividedByUnit:minute]];
    NSUInteger limit = [RCTAppleHealthKit uintFromOptions:input key:@"limit" withDefault:HKObjectQueryNoLimit];
    BOOL ascending = [RCTAppleHealthKit boolFromOptions:input key:@"ascending" withDefault:false];
    NSDate *startDate = [RCTAppleHealthKit dateFromOptions:input key:@"startDate" withDefault:nil];
    NSDate *endDate = [RCTAppleHealthKit dateFromOptions:input key:@"endDate" withDefault:[NSDate date]];
    if(startDate == nil){
        callback(@[RCTMakeError(@"startDate is required in options", nil, nil)]);
        return;
    }
    NSPredicate * predicate = [RCTAppleHealthKit predicateForSamplesBetweenDates:startDate endDate:endDate];

    [self fetchQuantitySamplesOfType:heartRateType
                                unit:unit
                           predicate:predicate
                           ascending:ascending
                               limit:limit
                          completion:^(NSArray *results, NSError *error) {
        if(results){
            callback(@[[NSNull null], results]);
            return;
        } else {
            NSLog(@"error getting heart rate samples: %@", error);
            callback(@[RCTMakeError(@"error getting heart rate samples", nil, nil)]);
            return;
        }
    }];
}

- (void)vitals_saveHeartRate:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback
{
    // parse the sample values from the function arguments
    double value = [RCTAppleHealthKit doubleFromOptions:input key:@"value" withDefault:(double)0];
    BOOL hasArrhythmia = [RCTAppleHealthKit boolFromOptions:input key:@"hasArrhythmia" withDefault:NO];
    NSDate *dateCreated = [RCTAppleHealthKit dateFromOptions:input key:@"date" withDefault:[NSDate date]];
    NSString *syncId = [RCTAppleHealthKit stringFromOptions:input key:@"syncId" withDefault:[[NSUUID UUID] UUIDString]];
    
    HKQuantityType *heartRateType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
    HKUnit *unit = [HKUnit unitFromString:@"count/min"];

    HKQuantity *quantity = [HKQuantity quantityWithUnit:unit doubleValue:(double)value];
    NSDictionary *metadata = @{
        @"Arrhythmia": hasArrhythmia ? @"YES" : @"NO",
        @"HKMetadataKeySyncIdentifier": syncId,
        @"HKMetadataKeySyncVersion": @1
    };
    HKQuantitySample *sample = [HKQuantitySample quantitySampleWithType:heartRateType quantity:quantity startDate:dateCreated endDate:dateCreated metadata: metadata];
    
    [self.healthStore saveObject:sample withCompletion:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            callback(@[[NSNull null], [sample copy]]);
        } else {
            NSLog(@"error saving heart rate sample: %@", error);
            callback(@[RCTMakeError(@"error saving heart rate sample", nil, nil)]);
            return;
        }
    }];
}

- (void)vitals_getBodyTemperatureSamples:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback
{
    HKQuantityType *bodyTemperatureType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature];

    HKUnit *unit = [RCTAppleHealthKit hkUnitFromOptions:input key:@"unit" withDefault:[HKUnit degreeCelsiusUnit]];
    NSUInteger limit = [RCTAppleHealthKit uintFromOptions:input key:@"limit" withDefault:HKObjectQueryNoLimit];
    BOOL ascending = [RCTAppleHealthKit boolFromOptions:input key:@"ascending" withDefault:false];
    NSDate *startDate = [RCTAppleHealthKit dateFromOptions:input key:@"startDate" withDefault:nil];
    NSDate *endDate = [RCTAppleHealthKit dateFromOptions:input key:@"endDate" withDefault:[NSDate date]];
    if(startDate == nil){
        callback(@[RCTMakeError(@"startDate is required in options", nil, nil)]);
        return;
    }
    NSPredicate * predicate = [RCTAppleHealthKit predicateForSamplesBetweenDates:startDate endDate:endDate];

    [self fetchQuantitySamplesOfType:bodyTemperatureType
                                unit:unit
                           predicate:predicate
                           ascending:ascending
                               limit:limit
                          completion:^(NSArray *results, NSError *error) {
        if(results){
            callback(@[[NSNull null], results]);
            return;
        } else {
            NSLog(@"error getting body temperature samples: %@", error);
            callback(@[RCTMakeError(@"error getting body temperature samples", nil, nil)]);
            return;
        }
    }];
}


- (void)vitals_getBloodPressureSamples:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback
{
    HKCorrelationType *bloodPressureCorrelationType = [HKCorrelationType correlationTypeForIdentifier:HKCorrelationTypeIdentifierBloodPressure];
    HKQuantityType *systolicType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic];
    HKQuantityType *diastolicType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic];

    HKUnit *unit = [RCTAppleHealthKit hkUnitFromOptions:input key:@"unit" withDefault:[HKUnit millimeterOfMercuryUnit]];
    NSUInteger limit = [RCTAppleHealthKit uintFromOptions:input key:@"limit" withDefault:HKObjectQueryNoLimit];
    BOOL ascending = [RCTAppleHealthKit boolFromOptions:input key:@"ascending" withDefault:false];
    NSDate *startDate = [RCTAppleHealthKit dateFromOptions:input key:@"startDate" withDefault:nil];
    NSDate *endDate = [RCTAppleHealthKit dateFromOptions:input key:@"endDate" withDefault:[NSDate date]];
    if(startDate == nil){
        callback(@[RCTMakeError(@"startDate is required in options", nil, nil)]);
        return;
    }
    NSPredicate * predicate = [RCTAppleHealthKit predicateForSamplesBetweenDates:startDate endDate:endDate];

    [self fetchCorrelationSamplesOfType:bloodPressureCorrelationType
                                   unit:unit
                           predicate:predicate
                           ascending:ascending
                               limit:limit
                          completion:^(NSArray *results, NSError *error) {
        if(results){
            NSMutableArray *data = [NSMutableArray arrayWithCapacity:1];

            for (NSDictionary *sample in results) {
                HKCorrelation *bloodPressureValues = [sample valueForKey:@"correlation"];
                HKQuantitySample *bloodPressureSystolicValue = [bloodPressureValues objectsForType:systolicType].anyObject;
                HKQuantitySample *bloodPressureDiastolicValue = [bloodPressureValues objectsForType:diastolicType].anyObject;

                NSDictionary *elem = @{
                    @"id": [sample valueForKey: @"id"],
                    @"systolic": @([bloodPressureSystolicValue.quantity doubleValueForUnit:unit]),
                    @"diastolic": @([bloodPressureDiastolicValue.quantity doubleValueForUnit:unit]),
                    @"startDate": [sample valueForKey:@"startDate"],
                    @"endDate": [sample valueForKey:@"endDate"],
                    @"metadata": [sample objectForKey:@"metadata"],
                    @"source": [sample objectForKey:@"source"]
                };

                [data addObject:elem];
            }

            callback(@[[NSNull null], data]);
            return;
        } else {
            NSLog(@"error getting blood pressure samples: %@", error);
            callback(@[RCTMakeError(@"error getting blood pressure samples", nil, nil)]);
            return;
        }
    }];
}

-(void)vitals_saveBloodPressure:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback
{
    NSDate *dateCreated = [RCTAppleHealthKit dateFromOptions:input key:@"date" withDefault:[NSDate date]];
    NSString *syncId = [RCTAppleHealthKit stringFromOptions:input key:@"syncId" withDefault:[[NSUUID UUID] UUIDString]];

    // parse the systolic and diastolic value from the function arguments
    NSUInteger systolicValue = [RCTAppleHealthKit uintFromOptions:input key:@"sys" withDefault:120];
    NSUInteger diastolicValue = [RCTAppleHealthKit uintFromOptions:input key:@"dia" withDefault:80];
    
    // parse sample metadata
    NSDictionary *locationMetadata = [input objectForKey:@"location"];
    BOOL isTakingMedications = [RCTAppleHealthKit boolFromOptions:input key:@"isTakingMedications" withDefault:NO];
    NSString *hand = [RCTAppleHealthKit stringFromOptions:input key:@"hand" withDefault:@"left"];

    // define the HealthKit types and units
    HKCorrelationType *bloodPressureCorrelationType = [HKCorrelationType correlationTypeForIdentifier:HKCorrelationTypeIdentifierBloodPressure];
    HKUnit *unit = [HKUnit millimeterOfMercuryUnit];

    // create the systolic sample
    HKQuantityType *systolicType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic];
    HKQuantity *systolicQuantity = [HKQuantity quantityWithUnit:unit doubleValue:(double) systolicValue];
    HKQuantitySample *systolicSample = [HKQuantitySample quantitySampleWithType:systolicType quantity:systolicQuantity startDate:dateCreated endDate:dateCreated];

    // create the diastolic sample
    HKQuantityType *diastolicType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic];
    HKQuantity *diastolicQuantity = [HKQuantity quantityWithUnit:unit doubleValue:(double) diastolicValue];
    HKQuantitySample *diastolicSample = [HKQuantitySample quantitySampleWithType:diastolicType quantity:diastolicQuantity startDate:dateCreated endDate:dateCreated];

    NSMutableDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary: @{
        @"HKMetadataKeySyncIdentifier": syncId,
        @"HKMetadataKeySyncVersion": @1,
        @"Hand": hand,
        @"IsTakingMedications": isTakingMedications ? @"YES" : @"NO"
    }];

    // add location metadata if present
    if (locationMetadata != (id)[NSNull null] && [locationMetadata valueForKey:@"latitude"] > 0 && [locationMetadata valueForKey:@"longitude"] > 0) {
        [metadata setValue:[locationMetadata valueForKey:@"latitude"] forKey:@"Latitude"];
        [metadata setValue:[locationMetadata valueForKey:@"longitude"] forKey:@"Longitude"];
    }

    // combine the systolic and diastolic samples into a correlation sample
    HKCorrelation *bloodPressureCorrelation = [HKCorrelation correlationWithType:bloodPressureCorrelationType startDate:dateCreated endDate:dateCreated objects: [NSSet setWithObjects:systolicSample, diastolicSample, nil] metadata:metadata];

    [self.healthStore saveObject:bloodPressureCorrelation withCompletion: ^(BOOL success, NSError *error) {
        if (success) {
             callback(@[[NSNull null], [bloodPressureCorrelation copy]]);
        } else {
            NSLog(@"error saving blood pressure sample: %@", error);
            callback(@[RCTMakeError(@"error saving blood pressure sample", nil, nil)]);
            return;
        }
    }];
}

- (void)vitals_deleteBloodPressureSample:(NSString *)sampleId callback:(RCTResponseSenderBlock)callback
{
    if ([sampleId length] == 0) {
        return callback(@[[NSNull null], @FALSE]);
    }

    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString: sampleId];
    NSPredicate *predicate = [HKQuery predicateForObjectWithUUID:uuid];
    HKCorrelationType *type = [HKCorrelationType correlationTypeForIdentifier:HKCorrelationTypeIdentifierBloodPressure];

    HKCorrelationQuery *query = [[HKCorrelationQuery alloc]
                                 initWithType:type
                                 predicate:predicate
                                 samplePredicates:nil
                                 completion:^(HKCorrelationQuery *query, NSArray *correlations, NSError *error) {
        if (correlations == nil) {
            return callback(@[[NSNull null], @FALSE]);
        }

        HKSample *sample = correlations[0];
        if (sample) {
            [self.healthStore deleteObject:sample withCompletion:^(BOOL success, NSError * _Nullable error) {
                if (error) {
                     return callback(@[[NSNull null], @FALSE]);
                }

                // find the corresponding heart rate sample (if any)
                // * allow one second more for the end date to account for possible millisecond mismatches
                NSDate *start = [sample startDate];
                NSDate *end = [[NSDate alloc] initWithTimeInterval: 1 sinceDate:start];
                NSPredicate *heartRatePredicate = [HKQuery predicateForSamplesWithStartDate:start
                                                                                    endDate:end
                                                                                options:HKQueryOptionStrictStartDate];
                HKQuantityType *heartRateType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];

                HKSampleQuery *heartRateQuery = [[HKSampleQuery alloc] initWithSampleType:heartRateType predicate:heartRatePredicate limit:1 sortDescriptors:nil resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"Could not query for heart rate sample. %@", error);
                        return;
                    }

                    if (!results || [results count] == 0) {
                        NSLog(@"Could not find corresponding heart rate sample.");
                        return;
                    }

                    HKSample *heartRateSample = results[0];
   
                    // delete the corresponding heart rate sample
                    [self.healthStore deleteObject:heartRateSample withCompletion:^(BOOL success, NSError * _Nullable error) {
                        if (error) {
                            NSLog(@"Error while trying to delete heart rate sample. %@", error);
                            return;
                        }

                        if (!success) {
                            NSLog(@"Deleting of heart rate sample failed.");
                            return;
                        }

                        return;
                    }];
                }];
                [self.healthStore executeQuery:heartRateQuery];

                return callback(@[[NSNull null], @(success)]);
            }];
        } else {
            return callback(@[[NSNull null], @FALSE]);
        }
    }];

    [self.healthStore executeQuery:query];
}


- (void)vitals_getRespiratoryRateSamples:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback
{
    HKQuantityType *respiratoryRateType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierRespiratoryRate];

    HKUnit *count = [HKUnit countUnit];
    HKUnit *minute = [HKUnit minuteUnit];

    HKUnit *unit = [RCTAppleHealthKit hkUnitFromOptions:input key:@"unit" withDefault:[count unitDividedByUnit:minute]];
    NSUInteger limit = [RCTAppleHealthKit uintFromOptions:input key:@"limit" withDefault:HKObjectQueryNoLimit];
    BOOL ascending = [RCTAppleHealthKit boolFromOptions:input key:@"ascending" withDefault:false];
    NSDate *startDate = [RCTAppleHealthKit dateFromOptions:input key:@"startDate" withDefault:nil];
    NSDate *endDate = [RCTAppleHealthKit dateFromOptions:input key:@"endDate" withDefault:[NSDate date]];
    if(startDate == nil){
        callback(@[RCTMakeError(@"startDate is required in options", nil, nil)]);
        return;
    }
    NSPredicate * predicate = [RCTAppleHealthKit predicateForSamplesBetweenDates:startDate endDate:endDate];

    [self fetchQuantitySamplesOfType:respiratoryRateType
                                unit:unit
                           predicate:predicate
                           ascending:ascending
                               limit:limit
                          completion:^(NSArray *results, NSError *error) {
        if(results){
            callback(@[[NSNull null], results]);
            return;
        } else {
            NSLog(@"error getting respiratory rate samples: %@", error);
            callback(@[RCTMakeError(@"error getting respiratory rate samples", nil, nil)]);
            return;
        }
    }];
}

@end
