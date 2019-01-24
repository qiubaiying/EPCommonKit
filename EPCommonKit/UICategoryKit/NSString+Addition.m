//
//  NSString+Addition.m
//  BossmailQ
//
//  Created by Mac on 15/7/29.
//  Copyright (c) 2015年 zengxusheng. All rights reserved.
//

#import "NSString+Addition.h"
#import <CommonCrypto/CommonDigest.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreFoundation/CoreFoundation.h>
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <AdSupport/AdSupport.h>

#define HANZI_START 19968   // 汉字起始ascii码
#define HANZI_COUNT 20902   // 汉字数
#define SPACE_ASCII 32      // 空格ascii码

@implementation NSString (Addition)

//随机字符串
+ (NSString *)randomString
{
    char str[8];
    for (int i=0; i<8; i++)
    {
        int j = random() % 93 + 33;
        char c = j;
        str[i] = c;
    }
    NSString *ret = [[NSString alloc]initWithBytes:&str length:8 encoding:NSASCIIStringEncoding];
    return ret;
}

/*
 *  生成id,避免重复情况
 */
+ (unsigned long)createTransId
{
    @synchronized(self)
    {
        unsigned long retVal = 0;
        NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"kGlobleTransIdKey"];
        if (number)
        {
            retVal = [number unsignedLongValue] + 1;
        }
        else
        {
            retVal = [[[NSDate alloc] init] timeIntervalSince1970];
        }
        [[NSUserDefaults standardUserDefaults] setValue:@(retVal) forKey:@"kGlobleTransIdKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return retVal;
    }
}

//Build 对应的是 CFBundleVersion （内部标示，用以记录开发版本的，每次更新的时候都需要比上一次高 如：当前版本是11  下一次就要大于11 比如 12，13 ....10000）
+ (NSString *)getVersionBuild
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    return app_build;
}

//Version 对应的就是CFBundleShortVersionString （发布版本号 如当前上架版本为1.1.0  之后你更新的时候可以改为1.1.1）
+ (NSString *)getShortVersionBuild
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_build;
}

//判断是否时整形
- (BOOL)isPureInt;
{
    NSScanner* scan = [NSScanner scannerWithString:self]; 
    int val; 
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形
- (BOOL)isPureFloat;
{
    NSScanner* scan = [NSScanner scannerWithString:self]; 
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

//是否是纯数字
+ (BOOL)isNumText:(NSString *)str{
    [NSCharacterSet decimalDigitCharacterSet];
    if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]] trim].length >0) {
        return NO;
    }else{
        return YES;
    }
}

//判断只能含有中、英文和数字格式
- (BOOL)isContrainCEDStr
{
    NSInteger alength = [self length];
    for (int i = 0; i<alength; i++) {
        if (![[self substringWithRange:NSMakeRange(i, 1)] isContrainChineseStr])
        {
            char commitChar = [self characterAtIndex:i];
            if (commitChar<=47 || (commitChar>=58 && commitChar<=64) || (commitChar>=91 && commitChar<=96) || commitChar>=123){
                return NO;
            }
        }
    }
    return YES;
}

//分割 非标准字符
- (NSArray *)splitWithCharacters:(NSString*)str;
{
	// split on non-standard characters
	
	NSCharacterSet* seperator = [NSCharacterSet characterSetWithCharactersInString:str];
	
	NSArray* y = [self componentsSeparatedByCharactersInSet:seperator];
	
	return y;
}

//分割字符串
- (NSArray *)splitWithString:(NSString*)y;
{
	return [self componentsSeparatedByString:y];
}

//分割邮箱地址
- (NSArray *)seperateEmailAddress;
{
    NSArray *emails = [self splitWithString:@";"];
    emails = [emails filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSString *evaluatedObject, NSDictionary *bindings) {
        return ![NSString isNullString:evaluatedObject];
    }]];
    return emails;
}

//替换回车、换行、制表符 为空格
- (NSString *)stringByDeletingNewLines;
{
	NSString* y = [self stringByReplacingOccurrencesOfString:@"\t" withString:@" "];
	y = [y stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
	y = [y stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
	y = [y stringByReplacingOccurrencesOfString:@"\f" withString:@" "];
	return y;
}

//压缩空格
- (NSString *)compressWhiteSpace;
{
	//TODO(gabor): this is a hack! I'd love to have some regexp's in da house
	NSString* y = [self stringByReplacingOccurrencesOfString:@"\t" withString:@" "];
	y = [y stringByReplacingOccurrencesOfString:@"   " withString:@" "];
	y = [y stringByReplacingOccurrencesOfString:@"  " withString:@" "];
	y = [y stringByReplacingOccurrencesOfString:@"  " withString:@" "];
	return y;
}

//去掉首尾空白符
- (NSString *)trim;
{
	NSCharacterSet* seperator = [NSCharacterSet characterSetWithCharactersInString:@" \t\r\n\f"];
	
	NSString* y = [self stringByTrimmingCharactersInSet:seperator];
	
	return y;
}

/*
 * 判断指定字符串是否空字符串（都是'\n'、都是' '，这些都算空字符串）
 */
+ (BOOL)isNullString:(NSString *)string;
{
    if (string.length == 0)
    {
        return YES;
    }
    if (string == nil)
    {
        return true;
    }
    for (int i = 0; i < [string length]; ++i)
    {
        if ([string characterAtIndex:i] != '\n' && [string characterAtIndex:i] != ' ' && [string characterAtIndex:i] != '\r' && [string characterAtIndex:i] != '\t' && [string characterAtIndex:i] != '\f'
            //            && [content characterAtIndex:i] != '\u200b'
            )
        {
            return false;
        }
    }
    return true;
}

//判断中文
- (BOOL)isContrainChineseStr;
{
    NSString *regex = @".*[\u4e00-\u9fa5].*";
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![predicate1 evaluateWithObject:self])
    {
        return NO;
    }
    return YES;
}

//手机号码验证
+ (BOOL)checkPhoneNumInput:(NSString *)text
{
    NSString *Regex =@"(13[0-9]|14[0-9]|15[0-9]|17[0-9]|18[0-9]|19[0-9])\\d{8}";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [mobileTest evaluateWithObject:text];
}

//判断邮箱
+ (BOOL)validateEmail:(NSString *)candidate
{
    if (candidate.length==0) {
        return NO;
    }
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

//微信号判断 6—20个字母、数字、下划线和减号，必须以字母开头（不区分大小写）
+(BOOL)validateWeiXin:(NSString *)weixin
{
    NSString *weixinRegex = @"^[A-Za-z][A-Za-z0-9_-]{5,19}$";
    NSPredicate *weixinTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", weixinRegex];
    return [weixinTest evaluateWithObject:weixin];
}

//判断是否包含sub字符串
- (BOOL)isContainString:(NSString*)sub;
{
	//returns YES is string contains subString, False otherwise
	NSRange nsr = [self rangeOfString:sub];
	if(nsr.location == NSNotFound) {
		return NO;
	}
	
	return YES;
}

//去掉sub字符串
- (NSString *)stringByDeletingString:(NSString *)sub;
{
	return [self stringByReplacingOccurrencesOfString:sub withString:@""];
}

/*
 *  校验字符串的第一个可见字符是否为中文
 */
- (BOOL)isFirstLetterChinese
{
    if (self.length == 0)
    {
        return NO;
    }
    
    int firstLetter = 0;
    NSInteger len = self.length;
    for (int i = 0; i < len; i++)
    {
        firstLetter = [self characterAtIndex:i];
        if (   firstLetter == '\n'
            || firstLetter == '\r'
            || firstLetter == '\t'
            || firstLetter == '\f'
            || firstLetter == 8203
            )
        {
            firstLetter = 0;
            continue;
        }
        if (firstLetter > SPACE_ASCII) // 空格以上的显示字符
        {
            break;
        }
    }
    
    int index = firstLetter - HANZI_START;
    if (index >= 0 && index <= HANZI_COUNT)
    {
        return YES;
    }
    return NO;
}

#pragma -mark  MIME type

//根据后缀名生成mime type
+ (NSString *)MIMETypeWithFileExtension:(NSString *)extension;
{
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)extension, NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    if ((__bridge NSString *)MIMEType != nil)
    {
        return (NSString *)CFBridgingRelease(MIMEType);
    }
    else
    {
        return nil;
    }
}

//获取文件mime
+ (NSString*)fileMIMEType:(NSString *)file;
{
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[file pathExtension], NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    if ((__bridge NSString *)MIMEType != nil)
    {
        return (NSString *)CFBridgingRelease(MIMEType);
    }
    else
    {
        NSString *type = [self localFileMIMEType:file];
        if (type != nil)
        {
            return type;
        }
        return @"application/unknown";//未知类型
    }
}

+ (NSString *)localFileMIMEType:(NSString *)file;
{
    NSError *error = nil;
    NSString* fullPath = [file stringByExpandingTildeInPath];
    NSURL* fileUrl = [NSURL fileURLWithPath:fullPath];
    NSURLRequest* fileUrlRequest = [[NSURLRequest alloc] initWithURL:fileUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:.1];
    NSURLResponse* response = nil;
    [NSURLConnection sendSynchronousRequest:fileUrlRequest returningResponse:&response error:&error];
    return [response MIMEType];
}

//md5加密
- (NSString *)md5;
{
	const char *cStr = [self UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
	return [[NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
			] lowercaseString];
}

//获取MAC地址
+ (NSString *)getMACAddress
{
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    // NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return [outstring uppercaseString];
}

//获取文字高度
+ (CGSize) calTextSizeWithText:(NSString *) text font:(UIFont *) font maxSize:(CGSize) maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

// 十六进制转换为普通字符串的。
+ (NSString *)stringFromHexString:(NSString *)hexString {  //
    
    if (hexString.length > 0) {
        char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
        bzero(myBuffer, [hexString length] / 2 + 1);
        for (int i = 0; i < [hexString length] - 1; i += 2) {
            unsigned int anInt;
            NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
            NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
            [scanner scanHexInt:&anInt];
            myBuffer[i / 2] = (char)anInt;
        }
        NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
        return unicodeString;
    }else
        return @"";
    
//    NSLog(@"------字符串=======%@",unicodeString);
    
    
    
}


// 正常号转银行卡号 － 增加4位间的空格
-(NSString *)normalNumToBankNum
{
    NSString *tmpStr = [self bankNumToNormalNum];
    
    int size = (int)(tmpStr.length / 4);
    
    NSMutableArray *tmpStrArr = [[NSMutableArray alloc] init];
    for (int n = 0;n < size; n++)
    {
        [tmpStrArr addObject:[tmpStr substringWithRange:NSMakeRange(n*4, 4)]];
    }
    
    [tmpStrArr addObject:[tmpStr substringWithRange:NSMakeRange(size*4, (tmpStr.length % 4))]];
    
    tmpStr = [tmpStrArr componentsJoinedByString:@" "];
    
    return tmpStr;
}

+ (NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}



// 银行卡号转正常号 － 去除4位间的空格
-(NSString *)bankNumToNormalNum
{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

+ (NSString *)fileName
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyyMMddhhmmss";
    NSString *name = [format stringFromDate:[NSDate date]];
    
    return name;
}

+ (NSString *)getBidCashWithCashId:(int)cashId
{
    NSString *cash;
    switch (cashId) {
        case 1:
            cash = @"100-1000";
            break;
        case 2:
            cash = @"1000-5000";
            break;
        case 3:
           cash = @"5000-1万";
            break;
        case 4:
           cash = @"1万-3万";
            break;
        case 5:
            cash = @"3万-5万";
            break;
        case 11:
            cash = @"5万-10万";
            break;
        case 10:
            cash = @"10万以上";
            break;
            
        default:
            break;
    }
    return cash;
}
//获取当前日期
+(NSString *)getCurrentDate
{
//    NSDate *now = [SharePublicMethod getCurrentTime];
//    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
//    [dateformatter setDateFormat:@"yyyymmdd"];
//    NSString *currentDateStr = [dateformatter stringFromDate: now];
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMdd"];
    NSString *  morelocationString=[dateformatter stringFromDate:senddate];

    return morelocationString;
}

//pc 换行符 空格 替换 \n
+(NSString *)htmlStringTabToString:(NSString *)htmlStr
{
    htmlStr=[htmlStr stringByReplacingOccurrencesOfString :@"&nbsp;" withString:@" "];
    htmlStr=[htmlStr stringByReplacingOccurrencesOfString :@"<br />" withString:@"\n"];
    htmlStr=[htmlStr stringByReplacingOccurrencesOfString :@"<br/>" withString:@"\n"];
    htmlStr=[htmlStr stringByReplacingOccurrencesOfString :@"</p>" withString:@"\n"];
    return htmlStr;
}

@end
