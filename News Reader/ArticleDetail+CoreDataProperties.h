//
//  ArticleDetail+CoreDataProperties.h
//  News Reader
//
//  Created by sathiyamoorthy N on 23/04/20.
//  Copyright © 2020 sathiyamoorthy N. All rights reserved.
//
//

#import "ArticleDetail.h"


NS_ASSUME_NONNULL_BEGIN

@interface ArticleDetail (CoreDataProperties)

+ (NSFetchRequest<ArticleDetail *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *author;
@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSString *descriptions;
@property (nullable, nonatomic, copy) NSDate *publishedAt;
@property (nullable, nonatomic, copy) NSString *publisher;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *url;
@property (nullable, nonatomic, copy) NSString *urlToImage;
@property (nullable, nonatomic, copy) NSData *imageData;
@property (nullable, nonatomic, copy) NSData *websiteData;

@end

NS_ASSUME_NONNULL_END
