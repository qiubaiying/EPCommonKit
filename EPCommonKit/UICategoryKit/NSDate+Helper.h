//
// NSDate+Helper.h
//
// Created by Billy Gray on 2/26/09.
// Copyright (c) 2009, 2010, ZETETIC LLC
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
//     * Neither the name of the ZETETIC LLC nor the
//       names of its contributors may be used to endorse or promote products
//       derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY ZETETIC LLC ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL ZETETIC LLC BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


#import <Foundation/Foundation.h>

@interface NSDate (Helper)

/**
 *  时间转换
 *
 *  @param timeSince1970 1970标准时间
 *
 *  @return 2001标准时间
 */
+ (NSTimeInterval)timeSinceReferenceWithTimeSince1970:(NSTimeInterval)timeSince1970;

//获取年月日如:19871127.
- (NSString *)getFormatYearMonthDay;

//返回当前月一共有几周(可能为4,5,6)
- (int )getWeekNumOfMonth;
//该日期是该年的第几周
- (int )getWeekOfYear;
//返回day天后的日期(若day为负数,则为|day|天前的日期)
- (NSDate *)dateAfterDay:(int)day;
//month个月后的日期
- (NSDate *)dateafterMonth:(int)month;
//获取日
- (NSUInteger)getDay;
//获取月
- (NSUInteger)getMonth;
//获取年
- (NSUInteger)getYear;
//获取小时
- (int )getHour;
//获取分钟
- (int)getMinute;
//获取日
- (NSString *)getDayString;
//获取月
- (NSString *)getMonthString;
//获取小时
- (NSString *)getHourString;
//获取分钟
- (NSString *)getMinuteString;
- (int )getHour:(NSDate *)date;
- (int)getMinute:(NSDate *)date;

- (NSUInteger)daysAgo;
//午夜时间距今几天
- (NSUInteger)daysAgoAgainstMidnight;
- (NSString *)stringDaysAgo;
- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag;
//返回一周的第几天(周末为第一天)
- (NSUInteger)weekday;

//转为NSString类型的
+ (NSDate *)dateFromString:(NSString *)string;
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)string;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed;

- (NSString *)string;
- (NSString *)chString;
- (NSString *)stringWithFormat:(NSString *)format;
- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;

//返回该月的第一天
- (NSDate *)beginningOfMonth;
//返回周日的的开始时间
- (NSDate *)beginningOfWeek;
//返回当前天的年月日.
- (NSDate *)beginningOfDay;
//返回当前周的周末
- (NSDate *)endOfWeek;
//该月的最后一天
- (NSDate *)endOfMonth;

+ (NSString *)dateFormatString;
+ (NSString *)timeFormatString;
+ (NSString *)timestampFormatString;
+ (NSString *)dbFormatString;
+ (NSString *)chFormatString;

//字符串转为日期
+ (NSDate *)getDateFromString:(NSString *)stringDate withFormatter:(NSString *)formatter;
//日期转为字符串
+ (NSString *)getStringFromDate:(NSDate *)date withFormatter:(NSString *)formatter;
//时间戳转为字符串
+ (NSString *)stringFromTimeInterval:(NSString *)timeInterval withFormatter:(NSString *)formatter;


@end
