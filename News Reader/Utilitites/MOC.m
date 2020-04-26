//
//  MOC.m
//  News Reader
//
//  Created by sathiyamoorthy N on 23/04/20.
//  Copyright © 2020 sathiyamoorthy N. All rights reserved.
//

#import "MOC.h"

@interface MOC()
@property(strong, nonatomic) NSManagedObjectContext *masterManagedObjectContext;
@property(strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property(strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@property(readonly, copy) NSDictionary *managedObjectModelEntities;
@end


@implementation MOC

@synthesize masterManagedObjectContext = _masterManagedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


#pragma mark -Sigleton method
+ (MOC *)sharedInstance {
    static dispatch_once_t once;
    static MOC *dataBaseDAOObject;
    dispatch_once(&once, ^{
        dataBaseDAOObject = [[self alloc] init];
    });
    return dataBaseDAOObject;
}

#pragma mark -class initialization method
- (id)init {
    self = [super init];
    return self;
}

#pragma mark -Public methods
- (NSManagedObjectContext *)masterManagedObjectContext {
    if (_masterManagedObjectContext) {
        return _masterManagedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _masterManagedObjectContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_masterManagedObjectContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
        [_masterManagedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _masterManagedObjectContext;
}


- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"News_Reader" withExtension:@"momd"];
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [applicationDocumentsDirectory URLByAppendingPathComponent:@"News_Reader.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark -
#pragma mark Helper Methods
- (void)saveManagedObjectContext {
    NSError *error = nil;
    
    if (![self.masterManagedObjectContext save:&error]) {
        if (error) {
            NSLog(@"Unable to save changes.");
            NSLog(@"%@, %@", error, error.localizedDescription);
        }
    }
}

- (void)clearDataOlderThan:(NSDate*)date tableName:(NSString*)tableName withSuccess:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:tableName];
    [fetchRequest setIncludesPropertyValues:NO];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"publishedAt < %@", date];
    [fetchRequest setPredicate:predicate];
    NSError *error;
    NSArray *fetchedObjects = [_masterManagedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *object in fetchedObjects) {
        [_masterManagedObjectContext deleteObject:object];
    }
    
    error = nil;
    [_masterManagedObjectContext save:&error];
    successBlock(@"success");
}

@end
