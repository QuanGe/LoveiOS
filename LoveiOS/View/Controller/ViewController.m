//
//  ViewController.m
//  LoveiOS
//
//  Created by zhangruquan on 15/2/13.
//  Copyright (c) 2015年 com.quange. All rights reserved.
//

#import "ViewController.h"
#import "UALogger.h"
#include "markdown.h"
#include "html.h"
#include "buffer.h"
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define READ_UNIT 1024
#define OUTPUT_UNIT 64
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSError* error;
    //NSString *filePath = [[NSBundle mainBundle] pathForResource:@"README" ofType:@"markdown"];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"README" ofType:@"markdown"];
    NSString* inputText = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    struct buf *ob;
    
    struct sd_callbacks callbacks;
    struct html_renderopt options;
    struct sd_markdown *markdown;
    
    /* performing markdown parsing */
    ob = bufnew(OUTPUT_UNIT);
    
    sdhtml_renderer(&callbacks, &options, 0);
    markdown = sd_markdown_new(MKDEXT_FENCED_CODE, 16, &callbacks, &options);
    const char * data = [inputText cStringUsingEncoding:NSUTF8StringEncoding];
    sd_markdown_render(ob, (uint8_t*)data, inputText.length, markdown);
    NSString *obStr = [[NSString alloc] initWithBytes:ob->data length:ob->size encoding:NSUTF8StringEncoding];
    NSString * bbb =[NSString stringWithFormat:@"<html><head><meta charset=\"UTF-8\"><style type=\"text/css\">pre {padding: 10px 70px 10px 0;margin-left: -20px;margin-right: -20px;font-family: 'Monaco', 'Lucida Console', monospace;font-size: 10px;line-height: 20px;box-shadow: inset 0 0 5px #000;word-wrap: break-word;background-color:#3b3b3b;color: #d6d6d6;}</style></head><body><div style=\"line-height: 1.5;font-size:%.1fpx;color:%@;margin-left:0px;padding-right:0px\"> %@</div><body></html>",14.0f,@"#000000",obStr];
    NSAttributedString * bodyStr = [[NSAttributedString alloc]
                                    initWithData: [bbb dataUsingEncoding:NSUTF8StringEncoding]
                                    options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
                                    documentAttributes:nil error:nil];
    self.m_pContentText.attributedText = bodyStr;
    
    sd_markdown_free(markdown);
    /* cleanup */
    bufrelease(ob);

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
