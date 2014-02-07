//
//  NSDate+Extras.m
//
//  Copyright (c) 2014 LAFOSCA STUDIO S.L.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "NSDate+Extras.h"

@implementation NSDate (Extras)

+ (NSDate *) dateFromString:(NSString *)dateString format:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc]
                                 initWithLocaleIdentifier:@"en_US_POSIX"] ;
    [dateFormatter setLocale:enUSPOSIXLocale];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    //        [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
    if (format){
        [dateFormatter setDateFormat:format];
    }
    else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss +0000"];
    }
    return [dateFormatter dateFromString:dateString];
    
}

+ (NSDate *) dateFromString:(NSString *)dateString
{
    NSDate *dateToReturn;
    
    dateToReturn = [self dateFromString:dateString format:@"yyyy-MM-dd HH:mm:ss +0000"];
    if (dateToReturn) return dateToReturn;
    
    dateToReturn = [self dateFromString:dateString format:@"yyyy-MM-dd"];
    if (dateToReturn) return dateToReturn;

    dateToReturn = [self dateFromString:dateString format:@"eee, dd MMM yyyy HH:mm:ss ZZZZ"];
    if (dateToReturn) return dateToReturn;
    
    dateToReturn = [self dateFromString:dateString format:@"eee MMM dd yyyy"];
    if (dateToReturn) return dateToReturn;
    
    dateToReturn = [self dateFromString:dateString format:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
    if (dateToReturn) return dateToReturn;
    
    dateToReturn = [self dateFromString:dateString format:@"eee MMM dd, yyyy hh:mm"];
    if (dateToReturn) return dateToReturn;
    
    return nil;
}

+ (NSString *) getTodayDateAsString
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *today = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"Today: %@",today);
    return today;
}

- (NSString *) dateStringwithFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *today = [dateFormatter stringFromDate:self];
    return today;
}

- (BOOL) overdue {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *today = [NSDate date];
    NSDateComponents *todayComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSTimeZoneCalendarUnit) fromDate:today];
    if ([self compare:[calendar dateFromComponents:todayComponents]] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}

@end
