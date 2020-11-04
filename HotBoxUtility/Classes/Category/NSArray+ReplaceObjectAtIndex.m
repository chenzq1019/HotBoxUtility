//
//  NSArray+ReplaceObjectAtIndex.m
//  QDReaderAppStore
//
//  Created by ChenJie on 13-7-29.
//
//

#import "NSArray+ReplaceObjectAtIndex.h"

@implementation NSArray (ReplaceObjectAtIndex)
- (id)objectAt:(NSUInteger)index{

    {
        @synchronized(self){
            NSUInteger count =[self count];
            if (index < count) {
                return [self objectAtIndex:index];
            }
            return nil;
        }
    }
}
@end
