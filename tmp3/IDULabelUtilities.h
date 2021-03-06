//
//  IDULabelUtilities.h
//  tmp3
//
//  Created by idu on 2017/5/26.
//  Copyright © 2017年 idu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "IDULabel.h"

#define IDULabelIsNull(a) ((a)==nil || (a)==NULL || (NSNull *)(a)==[NSNull null])

extern NSString * const kIDUImageAttributeName;
extern NSString * const kIDUImageName;
extern NSString * const kIDUImageHeight;
extern NSString * const kIDUImageWidth;
extern NSString * const kIDUImageLineVerticalAlignment;

extern NSString * const kIDULinkAttributesName;
extern NSString * const kIDUActiveLinkAttributesName;
extern NSString * const kIDUIsLinkAttributesName;
extern NSString * const kIDULinkRangeAttributesName;
extern NSString * const kIDULinkParameterAttributesName;
extern NSString * const kIDUClickLinkBlockAttributesName;
extern NSString * const kIDULongPressBlockAttributesName;
extern NSString * const kIDULinkNeedRedrawnAttributesName;



/**
 IDULabel工具类，提供NSMutableAttributedString封装方法
 */
@interface IDULabelUtilities : NSObject

/**
 在指定位置插入图片，图片是点击的链点！！！
 
 @param attrStr 需要插入图片的NSAttributedString
 @param imageName 图片名称
 @param size 图片大小
 @param loc 图片插入位置
 @param verticalAlignment 图片所在行，图片与文字在垂直方向的对齐方式（只针对当前行）
 @param linkAttributes 图片链点属性
 @param activeLinkAttributes 点击状态下的图片链点属性
 @param parameter 链点自定义参数
 @param clickLinkBlock 链点点击回调
 @param longPressBlock 长按点击链点回调
 
 @return 插入图片后的NSMutableAttributedString
 */
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
                                                      islink:(BOOL)isLink;

/**
 根据指定NSRange配置富文本，指定NSRange文本为可点击链点！！！
 
 @param attrStr NSAttributedString源
 @param range 指定NSRange
 @param linkAttributes 链点文本属性
 @param activeLinkAttributes 点击状态下的链点文本属性
 @param parameter 链点自定义参数
 @param clickLinkBlock 链点点击回调
 @param longPressBlock 长按点击链点回调
 
 @return 返回新的NSMutableAttributedString
 */
+ (NSMutableAttributedString *)configureLinkAttributedString:(NSAttributedString *)attrStr
                                                     atRange:(NSRange)range
                                              linkAttributes:(NSDictionary *)linkAttributes
                                        activeLinkAttributes:(NSDictionary *)activeLinkAttributes
                                                   parameter:(id)parameter
                                              clickLinkBlock:(IDULabelLinkModelBlock)clickLinkBlock
                                              longPressBlock:(IDULabelLinkModelBlock)longPressBlock
                                                      islink:(BOOL)isLink;


/**
 对文本中跟withString相同的文字配置富文本，指定的文字为可点击链点！！！
 
 @param attrStr NSAttributedString源
 @param withString 需要设置的文本
 @param sameStringEnable 文本中所有与withAttString的文字是否同步设置属性，sameStringEnable=NO 时取文本中首次匹配的String
 @param linkAttributes 链点文本属性
 @param activeLinkAttributes 点击状态下的链点文本属性
 @param parameter 链点自定义参数
 @param clickLinkBlock 链点点击回调
 @param longPressBlock 长按点击链点回调
 
 @return 返回新的NSMutableAttributedString
 */
+ (NSMutableAttributedString *)configureLinkAttributedString:(NSAttributedString *)attrStr
                                                  withString:(NSString *)withString
                                            sameStringEnable:(BOOL)sameStringEnable
                                              linkAttributes:(NSDictionary *)linkAttributes
                                        activeLinkAttributes:(NSDictionary *)activeLinkAttributes
                                                   parameter:(id)parameter
                                              clickLinkBlock:(IDULabelLinkModelBlock)clickLinkBlock
                                              longPressBlock:(IDULabelLinkModelBlock)longPressBlock
                                                      islink:(BOOL)isLink;
@end

/**
 响应点击以及指定区域绘制边框线辅助类
 */
@interface IDUGlyphRunStrokeItem : NSObject

@property (nonatomic, strong) UIColor *fillColor;//填充背景色
@property (nonatomic, strong) UIColor *strokeColor;//描边边框色
@property (nonatomic, strong) UIColor *activeFillColor;//点击选中时候的填充背景色
@property (nonatomic, strong) UIColor *activeStrokeColor;//点击选中时候的描边边框色
@property (nonatomic, assign) CGFloat lineWidth;//描边边框大小
@property (nonatomic, assign) CGFloat cornerRadius;//描边圆角
@property (nonatomic, assign) CGRect runBounds;//描边区域在系统坐标下的rect（原点在左下角）
@property (nonatomic, assign) CGRect locBounds;//描边区域在屏幕坐标下的rect（原点在左上角）
@property (nonatomic, copy) NSString *imageName;//插入图片名称
@property (nonatomic, assign) BOOL isImage;//插入图片
@property (nonatomic, assign) NSRange range;//链点在文本中的range
@property (nonatomic, strong) id parameter;//链点自定义参数
@property (nonatomic, copy) IDULabelLinkModelBlock linkBlock;//点击链点回调
@property (nonatomic, copy) IDULabelLinkModelBlock longPressBlock;//长按点击链点回调

//判断是否为点击链点
@property (nonatomic, assign) BOOL isLink;
//标记点击该链点是否需要重绘文本
@property (nonatomic, assign) BOOL needRedrawn;


@end
