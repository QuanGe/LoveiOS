//
//  LeftMenumViewController.m
//  LoveiOS
//
//  Created by zhangruquan on 15/3/9.
//  Copyright (c) 2015年 com.quange. All rights reserved.
//

#import "LILeftMenumViewController.h"
#import "LIAllInOneViewController.h"
static NSString *cellIdentifier = @"cell";
#define kCellHeight 44

@interface LILeftMenumViewController ()
@property (nonatomic) NSArray * itemNameArray;
@property (strong, nonatomic) NSMutableDictionary *contentViewControllersDic;
@end

@implementation LILeftMenumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = mRGBToColor(0x2b2f3e);
    
    self.itemNameArray = @[@"架构",@"经验",@"知识",@"UI"];
    
    CGFloat tableHeight = self.itemNameArray.count*(kCellHeight+2);
    UITableView * table = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.height-tableHeight)/2.0, self.view.width, tableHeight)];
    table.delegate = self;
    table.dataSource = self;
    table.scrollEnabled = NO;
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    table.separatorColor = mRGBToColor(0x353a4c);
    table.backgroundColor = [UIColor clearColor];
    [table registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:table];
    
    NSIndexPath *indexpath=[NSIndexPath indexPathForRow:0 inSection:0];
    [table selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionBottom];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.itemNameArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = mRGBToColor(0xe2394b);
    cell.textLabel.text = self.itemNameArray[indexPath.row];
    cell.textLabel.textColor = mRGBToColor(0x6f7382);
    cell.textLabel.highlightedTextColor= mRGBToColor(0xf7d8da);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return kCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self selectItemWithRow:indexPath.row];
}

-(void)selectItemWithRow:(NSInteger)row
{
    
    NSString *sonVC = [NSString stringWithFormat:@"sonViewController%@",@(row).stringValue];
    if (self.contentViewControllersDic[sonVC]) {
        ((LIAllInOneViewController*)self.parentViewController).contentViewController = self.contentViewControllersDic[sonVC];
        [(LIAllInOneViewController*)self.parentViewController closeSideBarView];
    } else {
        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        UIViewController *listController = (UIViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"LIBlogHomeViewController"];
        ((LIAllInOneViewController*)self.parentViewController).contentViewController = listController;
        self.contentViewControllersDic[sonVC] = listController;
        [(LIAllInOneViewController*)self.parentViewController closeSideBarView];
    }
    
}


@end
