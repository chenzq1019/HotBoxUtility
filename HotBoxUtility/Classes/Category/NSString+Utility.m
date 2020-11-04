//
//  NSString+StringUtility.m
//
//
//  Created by eachnet on 11/30/12.
//  Copyright (c) 2012 HotBox. All rights reserved.
//

#import "NSString+Utility.h"
#import <CommonCrypto/CommonDigest.h>
#import "UIImage+Extension.h"
#import "NSData+Base64.h"
#import "UIColor+ColorUtility.h"

#define  REG_EMAIL      @"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*"
#define  REG_MOBILE     @"^(1)\\d{10}$"
#define  REG_Unicode    @"\\p{Cf}"

@implementation NSString (Utility)

+ (NSString *)isNullToString:(id)string{
    if ([string isEqual:@"NULL"]
        || [string isKindOfClass:[NSNull class]]
        || [string isEqual:[NSNull null]]
        || [string isEqual:NULL]
        || [[string class] isSubclassOfClass:[NSNull class]]
        || string == nil
        || string == NULL
        || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0
        || [string isEqualToString:@"<null>"]
        || [string isEqualToString:@"(null)"])
    {
        return @"";
    }else
    {
        return (NSString *)string;
    }
}

- (NSString *) stringFromMD5{
    
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (int)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

+ (NSString *)HMACMD5WithKey:(NSString *)key andData:(NSString *)data {
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    const unsigned int blockSize = 64;
    char ipad[blockSize], opad[blockSize], keypad[blockSize];
    unsigned int keyLen = (int)strlen(cKey);
    CC_MD5_CTX ctxt;
    if(keyLen > blockSize) {
        //CC_MD5(cKey, keyLen, keypad);
        CC_MD5_Init(&ctxt);
        CC_MD5_Update(&ctxt, cKey, keyLen);
        CC_MD5_Final((unsigned char *)keypad, &ctxt);
        keyLen = CC_MD5_DIGEST_LENGTH;
    } else {
        memcpy(keypad, cKey, keyLen);
    }
    memset(ipad, 0x36, blockSize);
    memset(opad, 0x5c, blockSize);
    
    int i;
    for(i = 0; i < keyLen; i++) {
        ipad[i] ^= keypad[i];
        opad[i] ^= keypad[i];
    }
    
    CC_MD5_Init(&ctxt);
    CC_MD5_Update(&ctxt, ipad, blockSize);
    CC_MD5_Update(&ctxt, cData, strlen(cData));
    unsigned char md5[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(md5, &ctxt);
    
    CC_MD5_Init(&ctxt);
    CC_MD5_Update(&ctxt, opad, blockSize);
    CC_MD5_Update(&ctxt, md5, CC_MD5_DIGEST_LENGTH);
    CC_MD5_Final(md5, &ctxt);
    
    const unsigned int hex_len = CC_MD5_DIGEST_LENGTH*2+2;
    char hex[hex_len];
    for(i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        snprintf(&hex[i*2], hex_len-i*2, "%02x", md5[i]);
    }
    
    NSData *HMAC = [[NSData alloc] initWithBytes:hex length:strlen(hex)];
    NSString* temp =  [[NSString alloc] initWithData:HMAC encoding:NSUTF8StringEncoding];
    temp = [temp uppercaseString];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@"" ];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@"" ];
    HMAC = [temp dataUsingEncoding:NSASCIIStringEncoding];
    
    NSString *hash = [HMAC base64EncodedString];
    return hash;
}


- (NSString*) urlEncodedString {
    
    CFStringRef encodedCFString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                          (__bridge CFStringRef) self,
                                                                          nil,
                                                                          CFSTR("?!@#$^&%*+,:;='\"`<>()[]{}/\\| "),
                                                                          kCFStringEncodingUTF8);
    
    NSString *encodedString = [[NSString alloc] initWithString:(__bridge_transfer NSString*) encodedCFString];
    
    if(!encodedString)
        encodedString = @"";
    
    return encodedString;
}

- (NSString*) urlDecodedString {
    
    CFStringRef decodedCFString = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                          (__bridge CFStringRef) self,
                                                                                          CFSTR(""),
                                                                                          kCFStringEncodingUTF8);
    
    // We need to replace "+" with " " because the CF method above doesn't do it
    NSString *decodedString = [[NSString alloc] initWithString:(__bridge_transfer NSString*) decodedCFString];
    return (!decodedString) ? @"" :decodedString;
}

- (NSString *)removeUnicodeString{
    return [self stringByReplacingOccurrencesOfString:REG_Unicode withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
}

+(BOOL)isEmail:(NSString *)input{
    return  [input isValidateByRegex:REG_EMAIL];
}

+(BOOL)isMobileNum:(NSString *)input{
    return [input isValidateByRegex:REG_MOBILE];
}

+ (BOOL)isIDNumber:(NSString *)input{
    //判断位数
    if ([input length] < 15 ||[input length] > 18) {
        return NO;
    }
    
    NSString * carid = [NSString stringWithString:input];
    long lSumQT =0;
    //加权因子
    int R[] ={7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
    //校验码
    unsigned char sChecker[11]={'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};
    
    //将15位身份证号转换成18位
    
    NSMutableString *mString = [NSMutableString stringWithString:input];
    if ([input length] == 15) {
        
        
        [mString insertString:@"19" atIndex:6];
        
        long p = 0;
        const char *pid = [mString UTF8String];
        for (int i=0; i<=16; i++)
        {
            p += (pid[i]-48) * R[i];
        }
        
        int o = p%11;
        NSString *string_content = [NSString stringWithFormat:@"%c",sChecker[o]];
        [mString insertString:string_content atIndex:[mString length]];
        carid = mString;
        
    }
    
    //判断地区码
    NSString * sProvince = [NSString stringWithFormat:@"%@", [carid substringToIndex:2]];
    
    if (![self isAreaCode:sProvince]) {
        return NO;
    }
    
    //判断年月日是否有效
    
    //年份
    int strYear = [[carid substringWithRange:NSMakeRange(6, 4)] intValue];
    //月份
    int strMonth = [[carid substringWithRange:NSMakeRange(10, 2)] intValue];
    //日
    int strDay = [[carid substringWithRange:NSMakeRange(12, 2)] intValue];
    
    
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeZone:localZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 12:01:01",strYear,strMonth,strDay]];
    if (date == nil) {
        
        return NO;
    }
    
    const char *PaperId  = [carid UTF8String];
    
    //检验长度
    if( 18 != strlen(PaperId)) {
        
        return NO;
    }
    
    //校验数字
    for (int i=0; i<18; i++)
    {
        if ( !isdigit(PaperId[i]) && !(('X' == PaperId[i] || 'x' == PaperId[i]) && 17 == i) )
        {
            return NO;
        }
    }
    //验证最末的校验码
    for (int i=0; i<=16; i++)
    {
        lSumQT += (PaperId[i]-48) * R[i];
    }
    if (sChecker[lSumQT%11] != PaperId[17] )
    {
        return NO;
    }
    
    return YES;
}
+ (BOOL)isAreaCode:(NSString *)province {
    NSArray *pArr = @[
                      
                      @11,//北京市|110000，
                      
                      @12,//天津市|120000，
                      
                      @13,//河北省|130000，
                      
                      @14,//山西省|140000，
                      
                      @15,//内蒙古自治区|150000，
                      
                      @21,//辽宁省|210000，
                      
                      @22,//吉林省|220000，
                      
                      @23,//黑龙江省|230000，
                      
                      @31,//上海市|310000，
                      
                      @32,//江苏省|320000，
                      
                      @33,//浙江省|330000，
                      
                      @34,//安徽省|340000，
                      
                      @35,//福建省|350000，
                      
                      @36,//江西省|360000，
                      
                      @37,//山东省|370000，
                      
                      @41,//河南省|410000，
                      
                      @42,//湖北省|420000，
                      
                      @43,//湖南省|430000，
                      
                      @44,//广东省|440000，
                      
                      @45,//广西壮族自治区|450000，
                      
                      @46,//海南省|460000，
                      
                      @50,//重庆市|500000，
                      
                      @51,//四川省|510000，
                      
                      @52,//贵州省|520000，
                      
                      @53,//云南省|530000，
                      
                      @54,//西藏自治区|540000，
                      
                      @61,//陕西省|610000，
                      
                      @62,//甘肃省|620000，
                      
                      @63,//青海省|630000，
                      
                      @64,//宁夏回族自治区|640000，
                      
                      @65,//新疆维吾尔自治区|650000，
                      
                      @71,//台湾省（886)|710000,
                      
                      @81,//香港特别行政区（852)|810000，
                      
                      @82,//澳门特别行政区（853)|820000
                      
                      @91,//国外
                      ];
    int a = 0;
    for (int i = 0; i<pArr.count; i++) {
        NSString * pr = [NSString stringWithFormat:@"%@", pArr[i]];
        if ([pr isEqualToString:province]) {
            a ++;
        }
    }
    if (a == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)isValidateByRegex:(NSString *)regex {
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:self];
}

+ (int)calc_charsetNum:(NSString *)str{
    
    unsigned result = 0;
    const char *tchar = [str UTF8String];
    if (NULL == tchar) {
        return result;
    }
    result = (int)strlen(tchar);
    return result;
}

+ (int)convertToInt:(NSString *)str
{
    int strlength   =   0;
    char *  p   =   (char *)[str cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0; i < [str lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++)
    {
        if (*p)
        {
            p++;
            strlength++;
        }
        else
        {
            p++;
        }
    }
    return strlength;
}


- (NSArray *)allURLs
{
    NSMutableArray * array = [NSMutableArray array];
    
    NSInteger stringIndex = 0;
    while ( stringIndex < self.length )
    {
        NSRange searchRange = NSMakeRange(stringIndex, self.length - stringIndex);
        NSRange httpRange = [self rangeOfString:@"http://" options:NSCaseInsensitiveSearch range:searchRange];
        NSRange httpsRange = [self rangeOfString:@"https://" options:NSCaseInsensitiveSearch range:searchRange];
        
        NSRange startRange;
        if ( httpRange.location == NSNotFound )
        {
            startRange = httpsRange;
        }
        else if ( httpsRange.location == NSNotFound )
        {
            startRange = httpRange;
        }
        else
        {
            startRange = (httpRange.location < httpsRange.location) ? httpRange : httpsRange;
        }
        
        if (startRange.location == NSNotFound)
        {
            break;
        }
        else
        {
            NSRange beforeRange = NSMakeRange( searchRange.location, startRange.location - searchRange.location );
            if ( beforeRange.length )
            {
                //                NSString * text = [string substringWithRange:beforeRange];
                //                [array addObject:text];
            }
            
            NSRange subSearchRange = NSMakeRange(startRange.location, self.length - startRange.location);
            NSRange endRange = [self rangeOfString:@" " options:NSCaseInsensitiveSearch range:subSearchRange];
            if ( endRange.location == NSNotFound)
            {
                NSString * url = [self substringWithRange:subSearchRange];
                [array addObject:url];
                break;
            }
            else
            {
                NSRange URLRange = NSMakeRange(startRange.location, endRange.location - startRange.location);
                NSString * url = [self substringWithRange:URLRange];
                [array addObject:url];
                
                stringIndex = endRange.location;
            }
        }
    }
    
    return array;
}

- (NSString *)queryStringFromDictionary:(NSDictionary *)dict
{
    NSMutableArray * pairs = [NSMutableArray array];
    for ( NSString * key in [dict keyEnumerator] )
    {
        if ( !([[dict valueForKey:key] isKindOfClass:[NSString class]]) )
        {
            continue;
        }
        
        NSString * value = [dict objectForKey:key];
        NSString * urlEncoding = [value urlEncodedString];
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, urlEncoding]];
    }
    
    return [pairs componentsJoinedByString:@"&"];
}

- (NSString *)urlByAppendingDict:(NSDictionary *)params
{
    NSURL * parsedURL = [NSURL URLWithString:self];
    NSString * queryPrefix = parsedURL.query ? @"&" : @"?";
    NSString * query = [self queryStringFromDictionary:params];
    return [NSString stringWithFormat:@"%@%@%@", self, queryPrefix, query];
}

- (NSString *)queryStringFromArray:(NSArray *)array
{
    NSMutableArray *pairs = [NSMutableArray array];
    
    for ( NSUInteger i = 0; i < [array count]; i += 2 )
    {
        NSObject * obj1 = [array objectAtIndex:i];
        NSObject * obj2 = [array objectAtIndex:i + 1];
        
        NSString * key = nil;
        NSString * value = nil;
        
        if ( [obj1 isKindOfClass:[NSNumber class]] )
        {
            key = [(NSNumber *)obj1 stringValue];
        }
        else if ( [obj1 isKindOfClass:[NSString class]] )
        {
            key = (NSString *)obj1;
        }
        else
        {
            continue;
        }
        
        if ( [obj2 isKindOfClass:[NSNumber class]] )
        {
            value = [(NSNumber *)obj2 stringValue];
        }
        else if ( [obj1 isKindOfClass:[NSString class]] )
        {
            value = (NSString *)obj2;
        }
        else
        {
            continue;
        }
        
        NSString * urlEncoding = [value urlDecodedString];
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, urlEncoding]];
    }
    
    return [pairs componentsJoinedByString:@"&"];
}

- (NSString *)urlByAppendingArray:(NSArray *)params
{
    NSURL * parsedURL = [NSURL URLWithString:self];
    NSString * queryPrefix = parsedURL.query ? @"&" : @"?";
    NSString * query = [self queryStringFromArray:params];
    return [NSString stringWithFormat:@"%@%@%@", self, queryPrefix, query];
}

- (NSString *)urlByAppendingKeyValues:(id)first, ...
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    va_list args;
    va_start( args, first );
    
    for ( ;; )
    {
        NSObject<NSCopying> * key = [dict count] ? va_arg( args, NSObject * ) : first;
        if ( nil == key )
            break;
        
        NSObject * value = va_arg( args, NSObject * );
        if ( nil == value )
            break;
        
        [dict setObject:value forKey:key];
    }
    
    return [self urlByAppendingDict:dict];
}

- (NSString *)queryStringFromKeyValues:(id)first, ...
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    va_list args;
    va_start( args, first );
    
    for ( ;; )
    {
        NSObject<NSCopying> * key = [dict count] ? va_arg( args, NSObject * ) : first;
        if ( nil == key )
            break;
        
        NSObject * value = va_arg( args, NSObject * );
        if ( nil == value )
            break;
        
        [dict setObject:value forKey:key];
    }
    
    return [self queryStringFromDictionary:dict];
}


//手机马赛克
+(NSString*) mosaicMobilePhone:(NSString*) mobilePhone{
    
    //判断是否正常手机
    if (mobilePhone.length==11) {
        //隐藏中间四位
        NSString * newPhone=[NSString stringWithFormat:@"%@****%@",[mobilePhone substringToIndex:3],[mobilePhone substringFromIndex:7]];
        
        return  newPhone;
    }
    
    return  mobilePhone;
}


+(NSString *) mosaicString:(NSString *) string{
    if (string.length>1) {
        
        NSString * firstStr=[string substringToIndex:1];
        NSString * secdStr=@"***";
        NSString * lastStr=[string substringFromIndex:string.length-1];
        NSString * moasicString=[NSString stringWithFormat:@"%@%@%@",firstStr,secdStr,lastStr];
        return moasicString;
    }else{
        return [NSString stringWithFormat:@"%@***",string];
    }
}

//把一部分字符串替换成星号
+(NSString *)replaceStringWithAsterisk:(NSString *)originalStr startLocation:(NSInteger)startLocation lenght:(NSInteger)lenght

{
    
    NSString *newStr = originalStr;
    
    for (int i = 0; i < lenght; i++) {
        
        NSRange range = NSMakeRange(startLocation, 1);
        
        newStr = [newStr stringByReplacingCharactersInRange:range withString:@"*"];
        
        startLocation ++;
        
    }
    
    return newStr;
    
}

+ (UIImage *) tranforImageWithTargetText:(NSString *) targetText  withColor:(UIColor *)color{
    UILabel * label3 = ({
        UILabel * label = [UILabel new];
        label.text      = targetText;
        label.textColor = [UIColor whiteColor];
        label.font      = [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:10]};
        CGSize labelsize ;
        labelsize= [targetText boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        label.backgroundColor = color;
        [label setFrame:CGRectMake(0, 0, labelsize.width, 16)];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 3.5;
        label;
    });
    return [UIImage makeImageWithView:label3];
}
+ (UIImage *) tranforImageWithTargetText2:(NSString *) targetText  withColor:(UIColor *)color{
    UILabel * label3 = ({
        UILabel * label = [UILabel new];
        label.text      = targetText;
        if (color) {
            label.textColor = color;
            label.layer.borderColor = color.CGColor;
        }else{
            label.textColor = [UIColor convertHexToRGB:@"FF8610"];
            label.layer.borderColor = [UIColor convertHexToRGB:@"FF8610"].CGColor;
        }
        
        label.font      = [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:10]};
        CGSize labelsize ;
        labelsize= [targetText boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        label.backgroundColor = [UIColor whiteColor];
        [label setFrame:CGRectMake(0, 0, labelsize.width+8, 16)];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 3.5;
        label.layer.borderWidth = 0.5;
        
        label;
    });
    return [UIImage makeImageWithView:label3];
}

+ (NSMutableAttributedString *) transforAttributeWithString:(NSString *)targetStr Appends:(NSArray *) appends withPostion:(CGFloat)postion{
    NSMutableAttributedString *result=[[NSMutableAttributedString alloc] initWithString:targetStr];
    if (postion==0) {//0表示从字符串头插入标签，非0表示从尾部插入标签
        appends = [[[[appends copy] reverseObjectEnumerator] allObjects] mutableCopy];
    }
    for (int i = 0; i < [appends count]; i ++) {
        NSString * labelString;
        NSArray * contentArr = [[appends objectAtIndex:i] componentsSeparatedByString:@"#"];
        UIColor * labelColor;
        if ([contentArr count] ==2) {
            labelString =[NSString stringWithFormat:@"%@ ",[contentArr objectAtIndex:0]];
            labelColor=[UIColor convertHexToRGB:[contentArr objectAtIndex:1]];
        }
        else{
            labelString =[NSString stringWithFormat:@"%@ ",[appends objectAtIndex:i]];
            labelColor=[UIColor redColor];
        }
        
        UIImage * labelImage=[NSString tranforImageWithTargetText2:labelString withColor:labelColor];
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = labelImage;                                  //设置图片源
        textAttachment.bounds = CGRectMake(0, -3, labelImage.size.width, 16);//设置图片位置和大小
        NSAttributedString *attrStr = [NSAttributedString attributedStringWithAttachment: textAttachment];
        NSMutableAttributedString *spaceString = [[NSMutableAttributedString alloc] initWithString:@" "];
        CGFloat insertposition=postion==0?0:result.length;
        [result insertAttributedString:spaceString atIndex: insertposition];
        [result insertAttributedString: attrStr atIndex: insertposition];
    }
    return result;
}

//获取NSString的CGSize;
+ (CGSize) getSizeOfString:(NSString *)targetStr withFont:(UIFont*) font andMaxWidth:(CGFloat) maxWidth{
    CGFloat height=0.0;
    CGFloat width=0.0;
    if (targetStr.length<=0) {
        return CGSizeMake(width, height);
    }
    NSArray * strArrar=[targetStr componentsSeparatedByString:@"\n"];
    if (strArrar.count>0) {
        for (int i=0; i<strArrar.count; i++) {
            NSString * string=strArrar[i];
            NSDictionary * attridic=@{NSFontAttributeName:font};
            CGSize size=[string boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attridic context:nil].size;
            height+=size.height;
            if (width<size.width) {
                width=size.width;
            }
        }
    }else{
        NSDictionary * attridic=@{NSFontAttributeName:font};
        CGSize size=[targetStr boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attridic context:nil].size;
        return size;
    }
    
    return CGSizeMake(width, height);
}

- (NSMutableAttributedString *)setSubStrings:(NSArray *)subStrings showWithColor:(UIColor *)color{
    
    NSMutableAttributedString * result=[[NSMutableAttributedString alloc] initWithString:self];
    for (NSString * subStr in subStrings) {
        NSRange redRange = NSMakeRange([self rangeOfString:subStr].location, [self rangeOfString:subStr].length);
        [result addAttribute:NSForegroundColorAttributeName value:color range:redRange];
    }
    return result;
}


- (BOOL)stringRangeOfString:(NSString *)subString{
    if ([self rangeOfString:subString].location == NSNotFound) {
        
        return NO;
        
    } else {
        
        return YES;
        
    }
}

#pragma mark - NSDate
+ (NSString *)stringToDate:(NSString *)input OldDateFormat:(NSString *)oldDate NewDateFormat:(NSString *)newDate
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [inputFormatter setDateFormat:oldDate];
    NSDate* inputDate = [inputFormatter dateFromString:input];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:newDate];
    NSString *str = [outputFormatter stringFromDate:inputDate];
    
    return str;
}


//日期转字符串格式4
+(NSString*)dateToStringWithFormat:(NSDate*)date format:(NSString *) _format{
    //得到毫秒
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    //[dateFormatter setDateFormat:@"hh:mm:ss"]
    [dateFormatter setDateFormat:_format];//@"yyyy-MM-dd hh:mm:ss"
    //NSLog(@"Date%@", [dateFormatter stringFromDate:[NSDate date]]);
    NSString *currentdt = [dateFormatter stringFromDate:date];
    return currentdt;
}

@end

@implementation NSString (JsonString)

+(NSString *) jsonStringWithString:(NSString *) string{
    return [NSString stringWithFormat:@"\"%@\"",
            [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]
            ];
}

+(NSString *) jsonStringWithArray:(NSArray *)array{
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array) {
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"]"];
    return reString;
}

+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary{
    NSArray *keys = [dictionary allKeys];
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    for (int i=0; i<[keys count]; i++) {
        NSString *name = [keys objectAtIndex:i];
        id valueObj = [dictionary objectForKey:name];
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if (value) {
            [keyValues addObject:[NSString stringWithFormat:@"\"%@\":%@",name,value]];
        }
    }
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
    return reString;
}

+(NSString *) jsonStringWithObject:(id) object{
    NSString *value = nil;
    if (!object) {
        return value;
    }
    if ([object isKindOfClass:[NSString class]]) {
        value = [NSString jsonStringWithString:object];
    }else if([object isKindOfClass:[NSDictionary class]]){
        value = [NSString jsonStringWithDictionary:object];
    }else if([object isKindOfClass:[NSArray class]]){
        value = [NSString jsonStringWithArray:object];
    }
    return value;
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end
