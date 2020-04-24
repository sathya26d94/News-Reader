//
//  SyncEngine.m
//  News Reader
//
//  Created by sathiyamoorthy N on 23/04/20.
//  Copyright © 2020 sathiyamoorthy N. All rights reserved.
//

#import "SyncEngine.h"
#import "ArticleDetail.h"

@implementation SyncEngine

#pragma mark -Sigleton method
+ (SyncEngine *)sharedInstance {
    static dispatch_once_t once;
    static SyncEngine *syncObject;
    dispatch_once(&once, ^{
        syncObject = [[self alloc] init];
    });
    return syncObject;
}

#pragma mark -class initialization method
- (id)init {
    self = [super init];
    return self;
}

- (void)fetchFilesAsynchronouslyWithURL:(NSString*)urlString withSuccess:(SuccessBlock)successBlock{
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *encodedUrlAsString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:set];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithURL:[NSURL URLWithString:encodedUrlAsString]
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                NSLog(@"RESPONSE: %@",response);
                NSLog(@"DATA: %@",data);
                if (!error) {
                    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                        NSError *jsonError;
                        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                        if (jsonError) {
                            NSLog(@"Json Error");
                        } else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                successBlock(jsonResponse);
                            });
                        }
                    }  else {
                        NSLog(@"web service returning a error");
                    }
                } else {
                    NSLog(@"error : %@", error.description);
                }
            }] resume];
}

- (void)saveArticles:(id)data withSuccess:(SuccessBlock)successBlock {
    if (![[data valueForKey:@"status"] isEqualToString:@"ok"] ) {
        return;
    }
//    return;
    NSArray *dataArray = [data valueForKey:@"articles"];
    [[MOC sharedInstance] batchDeleteForTable:@"ArticleDetail" forPredicate:nil inManagedContext:[[MOC sharedInstance]masterManagedObjectContext] withSuccess:^(id responseObjects) {

        for (NSDictionary* dict in dataArray) {
            ArticleDetail *article=[NSEntityDescription insertNewObjectForEntityForName:@"ArticleDetail" inManagedObjectContext: [[MOC sharedInstance] masterManagedObjectContext]];
            if ([dict[@"author"] isKindOfClass:[NSString class]])
                article.author = [dict valueForKey:@"author"];
            else
                article.author = @"";
            article.title = [dict valueForKey:@"title"];
            article.descriptions = [dict valueForKey:@"description"];
            article.url = [dict valueForKey:@"url"];
            article.urlToImage = [dict valueForKey:@"urlToImage"];
            
            NSString *dateString =  dict[@"publishedAt"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
            NSDate *date = [dateFormatter dateFromString:dateString];
            article.publishedAt = date;
            
            if ([dict[@"content"] isKindOfClass:[NSString class]])
                article.content = [dict valueForKey:@"content"];
            else
                article.content = @"";
            article.publisher = dict[@"publisher"];
            [[MOC sharedInstance] saveManagedObjectContext];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            successBlock(@"Success");
        });
    } failure:^(NSString *failureReason) {
        
    }];
}

@end