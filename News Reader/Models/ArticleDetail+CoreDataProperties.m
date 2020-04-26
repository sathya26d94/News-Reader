//
//  ArticleDetail+CoreDataProperties.m
//  News Reader
//
//  Created by sathiyamoorthy N on 23/04/20.
//  Copyright © 2020 sathiyamoorthy N. All rights reserved.
//
//

#import "ArticleDetail+CoreDataProperties.h"

@implementation ArticleDetail (CoreDataProperties)

+ (NSFetchRequest<ArticleDetail *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ArticleDetail"];
}

@dynamic author;
@dynamic content;
@dynamic descriptions;
@dynamic publishedAt;
@dynamic publisher;
@dynamic title;
@dynamic url;
@dynamic urlToImage;
@dynamic websiteData;
@end
