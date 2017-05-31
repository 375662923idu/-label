//
//  IDULabelUtilities.m
//  tmp3
//
//  Created by idu on 2017/5/26.
//  Copyright © 2017年 idu. All rights reserved.
//

#import "IDULabelUtilities.h"

NSString * const kIDUImageAttributeName                       = @"kIDUImageAttributeName";
NSString * const kIDUImageName                                = @"kIDUImageName";
NSString * const kIDUImageHeight                              = @"kIDUImageHeight";
NSString * const kIDUImageWidth                               = @"kIDUImageWidth";
NSString * const kIDUImageLineVerticalAlignment               = @"kIDUImageLineVerticalAlignment";

NSString * const kIDULinkAttributesName                       = @"kIDULinkAttributesName";
NSString * const kIDUActiveLinkAttributesName                 = @"kIDUActiveLinkAttributesName";
NSString * const kIDUIsLinkAttributesName                     = @"kIDUIsLinkAttributesName";
NSString * const kIDULinkRangeAttributesName                  = @"kIDULinkRangeAttributesName";
NSString * const kIDULinkParameterAttributesName              = @"kIDULinkParameterAttributesName";
NSString * const kIDUClickLinkBlockAttributesName             = @"kIDUClickLinkBlockAttributesName";
NSString * const kIDULongPressBlockAttributesName             = @"kIDULongPressBlockAttributesName";
NSString * const kIDULinkNeedRedrawnAttributesName            = @"kIDULinkNeedRedrawnAttributesName";

//插入图片 占位符
NSString * const kAddImagePlaceholderString                  = @" ";

void RunDelegateDeallocCallback(void * refCon) {
    
}

//获取图片高度
CGFloat RunDelegateGetAscentCallback(void * refCon) {
    return [(NSNumber *)[(__bridge NSDictionary *)refCon objectForKey:kIDUImageHeight] floatValue];
}

CGFloat RunDelegateGetDescentCallback(void * refCon) {
    return 0;
}
//获取图片宽度
CGFloat RunDelegateGetWidthCallback(void * refCon) {
    return [(NSNumber *)[(__bridge NSDictionary *)refCon objectForKey:kIDUImageWidth] floatValue];
}

@implementation IDULabelUtilities

+ (NSMutableAttributedString *)configureLinkAttributedString:(NSAttributedString *)attrStr
                                                addImageName:(NSString *)imageName
                                                   imageSize:(CGSize)size
                                                     atIndex:(NSUInteger)loc
                                           verticalAlignment:(IDULabelVerticalAlignment)verticalAlignment
                                              linkAttributes:(NSDictionary *)linkAttributes
                                        activeLinkAttributes:(NSDictionary *)activeLinkAttributes
                                                   parameter:(id)parameter
                                              clickLinkBlock:(IDULabelLinkModelBlock)clickLinkBlock
                                              longPressBlock:(IDULabelLinkModelBlock)longPressBlock
                                                      islink:(BOOL)isLink
{
    NSParameterAssert((loc <= attrStr.length) && (!IDULabelIsNull(imageName) && imageName.length != 0));
        
    NSDictionary *imgInfoDic = @{kIDUImageName:imageName,
                                 kIDUImageWidth:@(size.width),
                                 kIDUImageHeight:@(size.height),
                                 kIDUImageLineVerticalAlignment:@(verticalAlignment)};
    
    //创建CTRunDelegateRef并设置回调函数
    CTRunDelegateCallbacks imageCallbacks;
    imageCallbacks.version = kCTRunDelegateVersion1;
    imageCallbacks.dealloc = RunDelegateDeallocCallback;
    imageCallbacks.getWidth = RunDelegateGetWidthCallback;
    imageCallbacks.getAscent = RunDelegateGetAscentCallback;
    imageCallbacks.getDescent = RunDelegateGetDescentCallback;
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&imageCallbacks, (__bridge void *)imgInfoDic);
    
    //插入图片 空白占位符
    NSMutableString *imgPlaceholderStr = [[NSMutableString alloc]initWithCapacity:3];
    [imgPlaceholderStr appendString:kAddImagePlaceholderString];
    NSRange imgRange = NSMakeRange(0, imgPlaceholderStr.length);
    NSMutableAttributedString *imageAttributedString = [[NSMutableAttributedString alloc] initWithString:imgPlaceholderStr];
    [imageAttributedString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range:imgRange];
    [imageAttributedString addAttribute:kIDUImageAttributeName value:imgInfoDic range:imgRange];
    
    if (!IDULabelIsNull(linkAttributes) && linkAttributes.count > 0) {
        [imageAttributedString addAttribute:kIDULinkAttributesName value:linkAttributes range:imgRange];
    }
    if (!IDULabelIsNull(activeLinkAttributes) && activeLinkAttributes.count > 0) {
        [imageAttributedString addAttribute:kIDUActiveLinkAttributesName value:activeLinkAttributes range:imgRange];
    }
    if (!IDULabelIsNull(parameter)) {
        [imageAttributedString addAttribute:kIDULinkParameterAttributesName value:parameter range:imgRange];
    }
    if (!IDULabelIsNull(clickLinkBlock)) {
        [imageAttributedString addAttribute:kIDUClickLinkBlockAttributesName value:clickLinkBlock range:imgRange];
    }
    if (!IDULabelIsNull(longPressBlock)) {
        [imageAttributedString addAttribute:kIDULongPressBlockAttributesName value:longPressBlock range:imgRange];
    }
    if (isLink) {
        [imageAttributedString addAttribute:kIDUIsLinkAttributesName value:@(YES) range:imgRange];
    }else{
        [imageAttributedString addAttribute:kIDUIsLinkAttributesName value:@(NO) range:imgRange];
    }
    NSRange range = NSMakeRange(loc, imgPlaceholderStr.length);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithAttributedString:attrStr];
    
    /* 设置默认换行模式为：NSLineBreakByCharWrapping
     * 当Label的宽度不够显示内容或图片的时候就自动换行, 不自动换行, 部分图片将会看不见
     */
    NSRange attributedStringRange = NSMakeRange(0, attributedString.length);
    NSDictionary *dic = nil;
    if (attributedStringRange.length > 0) {
        dic = [attributedString attributesAtIndex:0 effectiveRange:&attributedStringRange];
    }
    NSMutableParagraphStyle *paragraph = dic[NSParagraphStyleAttributeName];
    if (IDULabelIsNull(paragraph)) {
        paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByCharWrapping;
    }
    
    [attributedString insertAttributedString:imageAttributedString atIndex:range.location];
    if (!IDULabelIsNull(paragraph)) {
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, attributedString.length)];
    }
    CFRelease(runDelegate);
    
    return attributedString;
}

+ (NSMutableAttributedString *)configureLinkAttributedString:(NSAttributedString *)attrStr
                                                     atRange:(NSRange)range
                                              linkAttributes:(NSDictionary *)linkAttributes
                                        activeLinkAttributes:(NSDictionary *)activeLinkAttributes
                                                   parameter:(id)parameter
                                              clickLinkBlock:(IDULabelLinkModelBlock)clickLinkBlock
                                              longPressBlock:(IDULabelLinkModelBlock)longPressBlock
                                                      islink:(BOOL)isLink
{
    NSParameterAssert(attrStr.length > 0);
    NSParameterAssert((range.location + range.length) <= attrStr.length);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithAttributedString:attrStr];
    UIFont *linkFont = nil;
    UIFont *activeLinkFont = nil;
    if (!IDULabelIsNull(linkAttributes) && linkAttributes.count > 0) {
        linkFont = linkAttributes[NSFontAttributeName];
        [attributedString addAttribute:kIDULinkAttributesName value:linkAttributes range:range];
    }
    if (!IDULabelIsNull(activeLinkAttributes) && activeLinkAttributes.count > 0) {
        activeLinkFont = activeLinkAttributes[NSFontAttributeName];
        [attributedString addAttribute:kIDUActiveLinkAttributesName value:activeLinkAttributes range:range];
    }
    //正常状态跟点击高亮状态下字体大小不同，标记需要重绘
    if ((linkFont && activeLinkFont) && (![linkFont.fontName isEqualToString:activeLinkFont.fontName] || linkFont.pointSize != activeLinkFont.pointSize)) {
        [attributedString addAttribute:kIDULinkNeedRedrawnAttributesName value:@(YES) range:range];
    }else{
        [attributedString addAttribute:kIDULinkNeedRedrawnAttributesName value:@(NO) range:range];
    }
    if (!IDULabelIsNull(parameter)) {
        [attributedString addAttribute:kIDULinkParameterAttributesName value:parameter range:range];
    }
    if (!IDULabelIsNull(clickLinkBlock)) {
        [attributedString addAttribute:kIDUClickLinkBlockAttributesName value:clickLinkBlock range:range];
    }
    if (!IDULabelIsNull(longPressBlock)) {
        [attributedString addAttribute:kIDULongPressBlockAttributesName value:longPressBlock range:range];
    }
    if (isLink) {
        [attributedString addAttribute:kIDUIsLinkAttributesName value:@(YES) range:range];
    }else{
        [attributedString addAttribute:kIDUIsLinkAttributesName value:@(NO) range:range];
    }
    return attributedString;
}

+ (NSMutableAttributedString *)configureLinkAttributedString:(NSAttributedString *)attrStr
                                                  withString:(NSString *)withString
                                            sameStringEnable:(BOOL)sameStringEnable
                                              linkAttributes:(NSDictionary *)linkAttributes
                                        activeLinkAttributes:(NSDictionary *)activeLinkAttributes
                                                   parameter:(id)parameter
                                              clickLinkBlock:(IDULabelLinkModelBlock)clickLinkBlock
                                              longPressBlock:(IDULabelLinkModelBlock)longPressBlock
                                                      islink:(BOOL)isLink
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithAttributedString:attrStr];
    if (!sameStringEnable) {
        NSRange range = [self getFirstRangeWithString:withString inAttString:attrStr];
        if (range.location != NSNotFound) {
            attributedString = [self configureLinkAttributedString:attributedString atRange:range linkAttributes:linkAttributes activeLinkAttributes:activeLinkAttributes parameter:parameter clickLinkBlock:clickLinkBlock longPressBlock:longPressBlock islink:isLink];
        }
    }else{
        NSArray *rangeAry = [self getRangeArrayWithString:withString inAttString:attrStr];
        if (rangeAry.count > 0) {
            for (NSString *strRange in rangeAry) {
                attributedString = [self configureLinkAttributedString:attributedString atRange:NSRangeFromString(strRange) linkAttributes:linkAttributes activeLinkAttributes:activeLinkAttributes parameter:parameter clickLinkBlock:clickLinkBlock longPressBlock:longPressBlock islink:isLink];
            }
        }
    }
    return attributedString;
}

#pragma mark -

+ (NSRange)getFirstRangeWithString:(NSString *)withString inAttString:(NSAttributedString *)attString {
    NSRange range = [attString.string rangeOfString:withString];
    if (range.location == NSNotFound) {
        return range;
    }
//    NSAttributedString *str = [attString attributedSubstringFromRange:range];
//    if (![withAttString isEqualToAttributedString:str]) {
//        range = NSMakeRange(NSNotFound, 0);
//    }
    return range;
}

+ (NSArray <NSString *>*)getRangeArrayWithString:(NSString *)withString inAttString:(NSAttributedString *)attString {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:3];
    NSArray *strRanges = [self getRangeArrayWithString:withString inString:attString.string lastRange:NSMakeRange(0, 0) rangeArray:[NSMutableArray array]];
    
//    if (strRanges.count > 0) {
//        for (NSString *rangeStr in strRanges) {
//            NSRange range = NSRangeFromString(rangeStr);
//            NSAttributedString *str = [attString attributedSubstringFromRange:range];
//            if ([withAttString isEqualToAttributedString:str]) {
//                [array addObject:rangeStr];
//            }
//        }
//    }
    [array addObjectsFromArray:strRanges];
    
    return array;
}

/**
 *  遍历string，获取withString在string中的所有NSRange数组
 *
 *  @param withString 需要匹配的string
 *  @param string     string文本
 *  @param lastRange  withString上一次出现的NSRange值，初始为NSMakeRange(0, 0)
 *  @param array      初始NSRange数组
 *
 *  @return           返回最后的NSRange数组
 */
+ (NSArray <NSString *>*)getRangeArrayWithString:(NSString *)withString
                                        inString:(NSString *)string
                                       lastRange:(NSRange)lastRange
                                      rangeArray:(NSMutableArray *)array
{
    NSRange range = [string rangeOfString:withString];
    if (range.location == NSNotFound){
        return array;
    }else{
        NSRange curRange = NSMakeRange(lastRange.location+lastRange.length+range.location, range.length);
        [array addObject:NSStringFromRange(curRange)];
        NSString *tempString = [string substringFromIndex:(range.location+range.length)];
        [self getRangeArrayWithString:withString inString:tempString lastRange:curRange rangeArray:array];
        return array;
    }
}

@end



@implementation IDUGlyphRunStrokeItem

- (id)copyWithZone:(NSZone *)zone {
    IDUGlyphRunStrokeItem *item = [[[self class] allocWithZone:zone] init];
    item.strokeColor = [self.strokeColor copyWithZone:zone];
    item.fillColor = self.fillColor;
    item.lineWidth = self.lineWidth;
    item.runBounds = self.runBounds;
    item.locBounds = self.locBounds;
    item.cornerRadius = self.cornerRadius;
    item.activeFillColor = self.activeFillColor;
    item.activeStrokeColor = self.activeStrokeColor;
    item.imageName = self.imageName;
    item.isImage = self.isImage;
    item.range = self.range;
    item.parameter = self.parameter;
    item.linkBlock = self.linkBlock;
    item.longPressBlock = self.longPressBlock;
    item.isLink = self.isLink;
    item.needRedrawn = self.needRedrawn;
    return item;
}

@end
