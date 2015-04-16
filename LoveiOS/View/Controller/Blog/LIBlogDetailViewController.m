//
//  BlogDetailViewController.m
//  LoveiOS
//
//  Created by zhangruquan on 15/3/9.
//  Copyright (c) 2015年 com.quange. All rights reserved.
//

#import "LIBlogDetailViewController.h"
#import "LIAPIManager.h"
#include "markdown.h"
#include "html.h"
#include "buffer.h"
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define kREAD_UNIT 1024
#define kOUTPUT_UNIT 64
@interface LIBlogDetailViewController ()

@end

@implementation LIBlogDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    self.dtAttributeText.shouldDrawImages = NO;
    self.dtAttributeText.shouldDrawLinks = NO;
    self.dtAttributeText.textDelegate = self; // delegate for custom sub views
    
    // set an inset. Since the bottom is below a toolbar inset by 44px
    // set an inset. Since the bottom is below a toolbar inset by 44px
    [self.dtAttributeText setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 44, 0)];
    self.dtAttributeText.contentInset = UIEdgeInsetsMake(10, 10, 54, 10);
    self.dtAttributeText.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // this also compiles with iOS 6 SDK, but will work with later SDKs too
    CGFloat topInset = [[self valueForKeyPath:@"topLayoutGuide.length"] floatValue];
    CGFloat bottomInset = [[self valueForKeyPath:@"bottomLayoutGuide.length"] floatValue];
    
    NSLog(@"%f top", topInset);
    
    UIEdgeInsets outerInsets = UIEdgeInsetsMake(topInset, 0, bottomInset, 0);
    UIEdgeInsets innerInsets = outerInsets;
    innerInsets.left += 10;
    innerInsets.right += 10;
    innerInsets.top += 10;
    innerInsets.bottom += 10;
    
    CGPoint innerScrollOffset = CGPointMake(-innerInsets.left, -innerInsets.top);
    CGPoint outerScrollOffset = CGPointMake(-outerInsets.left, -outerInsets.top);
    
    self.dtAttributeText.contentInset = innerInsets;
    self.dtAttributeText.contentOffset = innerScrollOffset;
    self.dtAttributeText.scrollIndicatorInsets = outerInsets;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载，请稍后";
    
    [[[LIAPIManager sharedManager] fetchBlogDetailWithURLString:self.blogURLString] subscribeNext:^(NSString* x) {
        struct buf *ob;
        
        struct sd_callbacks callbacks;
        struct html_renderopt options;
        struct sd_markdown *markdown;
        
        /* performing markdown parsing */
        ob = bufnew(kOUTPUT_UNIT);
        
        sdhtml_renderer(&callbacks, &options, 0);
        markdown = sd_markdown_new(MKDEXT_FENCED_CODE, 16, &callbacks, &options);
        const char * data = [x cStringUsingEncoding:NSUTF8StringEncoding];
        sd_markdown_render(ob, (uint8_t*)data, [x lengthOfBytesUsingEncoding:NSUTF8StringEncoding], markdown);
        NSString *obStr = [[NSString alloc] initWithBytes:ob->data length:ob->size encoding:NSUTF8StringEncoding];
        obStr = [NSString stringWithFormat:@"<html><head><meta charset=\"UTF-8\"><style type=\"text/css\">code, pre {font-family:\"Monaco\",\"Courier New\",monospace;font-size:10px;line-height:1.5;margin:0 15 0 15px; padding:0px 0;}pre {-moz-border-radius:5px 5px 5px 5px;-webkit-border-radius:5px;border-radius:5px;-moz-box-shadow:0 -1px 0 #444444;background-color:#fafafa;color:#3b3b3b;font-size:10px;margin:0 15 0 15px;padding:0px;white-space:pre-wrap;word-wrap:break-word;}</style></head><body><div style=\"line-height: 1.5;font-size:18fpx;color:#000000;margin-left:0px;padding-right:0px\"> %@</div><body></html>",obStr];
        [self useHtmlStrSetDtAttributeText:obStr];
        [hud hide:YES];
        
    } error:^(NSError *error) {
        hud.labelText = NSLocalizedString([error userInfo][NSLocalizedDescriptionKey], nil);
        [hud hide:YES afterDelay:1];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark Custom Views on Text

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttributedString:(NSAttributedString *)string frame:(CGRect)frame
{
    NSDictionary *attributes = [string attributesAtIndex:0 effectiveRange:NULL];
    
    NSURL *URL = [attributes objectForKey:DTLinkAttribute];
    NSString *identifier = [attributes objectForKey:DTGUIDAttribute];
    
    
    DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:frame];
    button.URL = URL;
    button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
    button.GUID = identifier;
    
    // get image with normal link text
    UIImage *normalImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDefault];
    [button setImage:normalImage forState:UIControlStateNormal];
    
    // get image for highlighted link text
    UIImage *highlightImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDrawLinksHighlighted];
    [button setImage:highlightImage forState:UIControlStateHighlighted];
    
    // use normal push action for opening URL
    [button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
    
    // demonstrate combination with long press
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(linkLongPressed:)];
    [button addGestureRecognizer:longPress];
    
    return button;
}

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
{
    if ([attachment isKindOfClass:[DTImageTextAttachment class]])
    {
        // if the attachment has a hyperlinkURL then this is currently ignored
        DTLazyImageView *imageView = [[DTLazyImageView alloc] initWithFrame:frame];
        imageView.delegate = self;
        
        // sets the image if there is one
        imageView.image = [(DTImageTextAttachment *)attachment image];
        
        // url for deferred loading
        imageView.url = attachment.contentURL;
        
        imageView.placeHolderImageName = @"listDefault";
        
        // if there is a hyperlink then add a link button on top of this image
        if (attachment.hyperLinkURL)
        {
            // NOTE: this is a hack, you probably want to use your own image view and touch handling
            // also, this treats an image with a hyperlink by itself because we don't have the GUID of the link parts
            imageView.userInteractionEnabled = YES;
            
            DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:imageView.bounds];
            button.URL = attachment.hyperLinkURL;
            button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
            button.GUID = attachment.hyperLinkGUID;
            
            // use normal push action for opening URL
            [button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
            
            // demonstrate combination with long press
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(linkLongPressed:)];
            [button addGestureRecognizer:longPress];
            
            [imageView addSubview:button];
        }
        
        return imageView;
    }
    else if ([attachment isKindOfClass:[DTIframeTextAttachment class]])
    {
        DTWebVideoView *videoView = [[DTWebVideoView alloc] initWithFrame:frame];
        videoView.attachment = attachment;
        
        return videoView;
    }
    else if ([attachment isKindOfClass:[DTObjectTextAttachment class]])
    {
        // somecolorparameter has a HTML color
        NSString *colorName = [attachment.attributes objectForKey:@"somecolorparameter"];
        UIColor *someColor = DTColorCreateWithHTMLName(colorName);
        
        UIView *someView = [[UIView alloc] initWithFrame:frame];
        someView.backgroundColor = someColor;
        someView.layer.borderWidth = 1;
        someView.layer.borderColor = [UIColor blackColor].CGColor;
        
        someView.accessibilityLabel = colorName;
        someView.isAccessibilityElement = YES;
        
        return someView;
    }
    
    return nil;
}

- (BOOL)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView shouldDrawBackgroundForTextBlock:(DTTextBlock *)textBlock frame:(CGRect)frame context:(CGContextRef)context forLayoutFrame:(DTCoreTextLayoutFrame *)layoutFrame
{
    CGColorRef color = [textBlock.backgroundColor CGColor];
    
    if(!color)
        return YES;
    if(![self.dtAttributeText viewWithTag:@(frame.origin.y).integerValue])
    {
        attributedTextContentView.backgroundColor = [UIColor clearColor];
        UIView * u = [[UIView alloc] initWithFrame:frame];
        u.layer.cornerRadius = 3;
        u.layer.borderColor = mRGBToColor(0xeeeeee).CGColor;
        u.layer.borderWidth=1;
        u.layer.backgroundColor = color;
        u.tag = @(frame.origin.y).integerValue;
        
        [self.dtAttributeText addSubview:u];
        [self.dtAttributeText sendSubviewToBack:u];
    }
    return NO;

}


#pragma mark Actions

- (void)linkPushed:(DTLinkButton *)button
{
    NSURL *URL = button.URL;
    
    if ([[UIApplication sharedApplication] canOpenURL:[URL absoluteURL]])
    {
        
        [[UIApplication sharedApplication] openURL:[URL absoluteURL]];
        
    }
    else
    {
        if (![URL host] && ![URL path])
        {
            
            // possibly a local anchor link
            NSString *fragment = [URL fragment];
            
            if (fragment)
            {
                [self.dtAttributeText scrollToAnchorNamed:fragment animated:NO];
            }
        }
    }
}



- (void)linkLongPressed:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        DTLinkButton *button = (id)[gesture view];
        button.highlighted = NO;
        
        
         if ([[UIApplication sharedApplication] canOpenURL:[button.URL absoluteURL]])
         {
         UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:[[button.URL absoluteURL] description] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open in Safari", nil];
         [action showFromRect:button.frame inView:button.superview animated:YES];
         }
        
    }
}


#pragma mark - DTLazyImageViewDelegate

- (void)lazyImageView:(DTLazyImageView *)lazyImageView didChangeImageSize:(CGSize)size {
    NSURL *url = lazyImageView.url;
    CGSize imageSize = size;
    
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"contentURL == %@", url];
    
    BOOL didUpdate = NO;
    
    // update all attachments that matchin this URL (possibly multiple images with same size)
    for (DTTextAttachment *oneAttachment in [self.dtAttributeText.attributedTextContentView.layoutFrame textAttachmentsWithPredicate:pred])
    {
        // update attachments that have no original size, that also sets the display size
        if (CGSizeEqualToSize(oneAttachment.originalSize, CGSizeZero)||[oneAttachment originalSizeSetedByPlaceHolderSize])
        {
            oneAttachment.originalSize = imageSize;
            
            didUpdate = YES;
        }
    }
    
    if (didUpdate)
    {
        // layout might have changed due to image sizes
        [self.dtAttributeText relayoutText];
    }
}

#pragma mark Properties

-(void)useHtmlStrSetDtAttributeText:(NSString*)str {
    
    
    NSRange  range = [self.blogURLString rangeOfString:@"/master/"];
    NSString * baseUrl = [self.blogURLString substringToIndex:range.location+range.length];
    str = [str stringByReplacingOccurrencesOfString:@"<img src=\"/" withString:[@"<img src=\"" stringByAppendingString:baseUrl]];
    
    CGSize maxImageSize = CGSizeMake(self.view.width - 30.0, 3300.0);
    
    CGSize placeholder = CGSizeMake(self.view.width - 31.0, (self.view.width - 10.0)*13/37);
    NSData *data = [NSData dataWithBytes:[str UTF8String] length:[str lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    // example for setting a willFlushCallback, that gets called before elements are written to the generated attributed string
    void (^callBackBlock)(DTHTMLElement *element) = ^(DTHTMLElement *element) {
        
        // the block is being called for an entire paragraph, so we check the individual elements
        
        for (DTHTMLElement *oneChildElement in element.childNodes)
        {
            // if an element is larger than twice the font size put it in it's own block
            if (oneChildElement.displayStyle == DTHTMLElementDisplayStyleInline && oneChildElement.textAttachment.displaySize.height > 2.0 * oneChildElement.fontDescriptor.pointSize)
            {
                oneChildElement.displayStyle = DTHTMLElementDisplayStyleBlock;
                oneChildElement.paragraphStyle.minimumLineHeight = element.textAttachment.displaySize.height;
                oneChildElement.paragraphStyle.maximumLineHeight = element.textAttachment.displaySize.height;
            }
        }
    };
    
    
    
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:1.0], NSTextSizeMultiplierDocumentOption,
                                    
                                    [NSValue valueWithCGSize:placeholder],DTPlaceHolderImageSize,
                                    [NSValue valueWithCGSize:maxImageSize], DTMaxImageSize,
                                    @"Times New Roman", DTDefaultFontFamily,  @"black", DTDefaultLinkColor, @"red", DTDefaultLinkHighlightColor, callBackBlock, DTWillFlushBlockCallBack, nil];
    NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:options documentAttributes:NULL];
    
    self.dtAttributeText.attributedString = string;
    
    [self.view setNeedsLayout];
    
}

- (IBAction)back:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
