//
//  ViewController.m
//  tmp3
//
//  Created by idu on 2017/5/26.
//  Copyright © 2017年 idu. All rights reserved.
//


#import "ViewController.h"
#import "IDULabel.h"

#define UIRGBColor(r,g,b,a) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a])
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ViewController ()<UITextFieldDelegate>
@property (nonatomic, strong)  IDULabel *firstLabel;
//@property (nonatomic, strong) IDULabel *secondLabel;
@property (nonatomic, strong) NSAttributedString *attStr;
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  //   self.edgesForExtendedLayout = UIRectEdgeNone;
  //  self.automaticallyAdjustsScrollViewInsets = NO;
  
  self.firstLabel= [[IDULabel alloc]initWithFrame:CGRectMake(10, 10, 300, 300)];
  self.firstLabel.numberOfLines = 0;
  [self.view addSubview:self.firstLabel];
  
  
  NSString *str = @"aaaaaaaaaaaaaaaaaaaaaaaaaaaaa图片aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa图文1aaaaaahelloaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa图文2aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa，IDULabel";
  NSMutableAttributedString *content =  [[NSMutableAttributedString alloc]initWithString:str];
  //  [content addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, str.length)];
  
  [self configureLabelContent:content verticalAlignment:CJVerticalAlignmentBottom];
  
}



- (void)configureLabelContent:(NSMutableAttributedString *)attStr verticalAlignment:(IDULabelVerticalAlignment)verticalAlignment {
  attStr = [IDULabel configureLinkAttributedString:attStr
                                        withString:@"图文1"
                                  sameStringEnable:NO
                                    linkAttributes:@{
                                                     NSForegroundColorAttributeName:[UIColor blueColor],
                                                     NSFontAttributeName:[UIFont boldSystemFontOfSize:20],
                                                     kCJBackgroundStrokeColorAttributeName:[UIColor redColor],
                                                     kCJBackgroundLineWidthAttributeName:@(1),
                                                     kCJBackgroundFillColorAttributeName:[UIColor lightGrayColor]
                                                     }
                              activeLinkAttributes:@{
                                                     NSForegroundColorAttributeName:[UIColor redColor],
                                                     NSFontAttributeName:[UIFont boldSystemFontOfSize:20],
                                                     kCJActiveBackgroundStrokeColorAttributeName:[UIColor blackColor],
                                                     kCJActiveBackgroundFillColorAttributeName:[UIColor yellowColor]
                                                     }
                                         parameter:@"参数为字符串"
                                    clickLinkBlock:^(IDULabelLinkModel *linkModel){
                                      [self clickLink:linkModel isImage:NO];
                                    }longPressBlock:^(IDULabelLinkModel *linkModel){
                                      [self clicklongPressLink:linkModel isImage:NO];
                                    }];
  attStr = [IDULabel configureLinkAttributedString:attStr
                                        withString:@"图文2"
                                  sameStringEnable:NO
                                    linkAttributes:@{
                                                     NSForegroundColorAttributeName:[UIColor blueColor],
                                                     NSFontAttributeName:[UIFont boldSystemFontOfSize:15],
                                                     kCJBackgroundStrokeColorAttributeName:[UIColor orangeColor],
                                                     kCJBackgroundLineWidthAttributeName:@(1),
                                                     kCJBackgroundFillColorAttributeName:[UIColor lightGrayColor]
                                                     }
                              activeLinkAttributes:@{
                                                     NSForegroundColorAttributeName:[UIColor redColor],
                                                     NSFontAttributeName:[UIFont boldSystemFontOfSize:15],
                                                     kCJActiveBackgroundStrokeColorAttributeName:[UIColor blackColor],
                                                     kCJActiveBackgroundFillColorAttributeName:[UIColor yellowColor]
                                                     }
                                         parameter:@"参数为字符串"
                                    clickLinkBlock:^(IDULabelLinkModel *linkModel){
                                      [self clickLink:linkModel isImage:NO];
                                    }longPressBlock:^(IDULabelLinkModel *linkModel){
                                      [self clicklongPressLink:linkModel isImage:NO];
                                    }];
  
  NSRange imageRange = [attStr.string rangeOfString:@"图片"];
  [attStr replaceCharactersInRange:imageRange withString:@""];

  attStr = [IDULabel configureLinkAttributedString:attStr
                                      addImageName:@"IDULabel.png"
                                         imageSize:CGSizeMake(60, 48)
                                           atIndex:imageRange.location+imageRange.length
                                 verticalAlignment:verticalAlignment
                                    linkAttributes:@{
                                                     kCJBackgroundStrokeColorAttributeName:[UIColor blueColor],
                                                     kCJBackgroundLineWidthAttributeName:@(1),
                                                     }
                              activeLinkAttributes:@{
                                                     kCJActiveBackgroundStrokeColorAttributeName:[UIColor redColor],
                                                     }
                                         parameter:@"图片参数"
                                    clickLinkBlock:^(IDULabelLinkModel *linkModel){
                                      [self clickLink:linkModel isImage:YES];
                                    }longPressBlock:^(IDULabelLinkModel *linkModel){
                                      [self clicklongPressLink:linkModel isImage:YES];
                                    }];
  /* 设置默认换行模式为：NSLineBreakByCharWrapping
   * 当Label的宽度不够显示内容或图片的时候就自动换行, 不自动换行, 部分图片将会看不见
   */
  NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithAttributedString:attStr];
  NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
  paragraph.lineBreakMode = NSLineBreakByCharWrapping;
  [str addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, str.length)];
  
  self.firstLabel.attributedText = str;
  self.firstLabel.extendsLinkTouchArea = YES;
}


- (void)clickLink:(IDULabelLinkModel *)linkModel isImage:(BOOL)isImage {
  NSLog(@"我是单击");
}

- (void)clicklongPressLink:(IDULabelLinkModel *)linkModel isImage:(BOOL)isImage {
  NSLog(@"我是长按");
}

@end
