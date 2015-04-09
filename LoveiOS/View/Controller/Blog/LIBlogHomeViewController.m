//
//  BlogHomeViewController.m
//  LoveiOS
//
//  Created by zhangruquan on 15/3/9.
//  Copyright (c) 2015年 com.quange. All rights reserved.
//

#import "LIBlogHomeViewController.h"
#import "SVPullToRefresh.h"
#import "LIBlogListTableViewCell.h"
#import "LIBlogDetailViewController.h"
@interface LIBlogHomeViewController ()
@property (nonatomic) LIBlogListViewModel * viewModel;
@property (nonatomic) NSMutableDictionary * cellItemSizes;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LIBlogHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewModel = [[LIBlogListViewModel alloc] initWithType:self.type];
    self.cellItemSizes = [NSMutableDictionary dictionaryWithCapacity:10]  ;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass( [LIBlogListTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass( [LIBlogListTableViewCell class])];
    @weakify(self);
    [self.tableView addPullToRefreshWithActionHandler:^{
        @strongify(self);
        [[self.viewModel refreshBlogList] subscribeNext:^(NSArray* x) {
            
            [self.tableView.pullToRefreshView stopAnimating];
            if(x.count >0)
            {
                [self.cellItemSizes removeAllObjects];
                [self.tableView reloadData];
            }
        } error:^(NSError *error) {
            mAlertView(@"提示", NSLocalizedString([error userInfo][NSLocalizedDescriptionKey], nil));
            [self.tableView.pullToRefreshView stopAnimating];
        }];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        @strongify(self);
        [[self.viewModel fetchMore] subscribeNext:^(NSArray* x) {
            if (x.count ==0) {
                mAlertView(@"提示", @"已经拉到底了");
            }
            else
                [self.tableView reloadData];
            [self.tableView.infiniteScrollingView stopAnimating];
            
        } error:^(NSError *error) {
            mAlertView(@"提示", NSLocalizedString([error userInfo][NSLocalizedDescriptionKey], nil));
            [self.tableView.infiniteScrollingView stopAnimating];
        }];
    }];
    
    [self.tableView configPullVisibleLogoWithName:@"logoOfList"];
    
    [self.tableView.pullToRefreshView setTitle:@"下拉更新" forState:SVPullToRefreshStateStopped];
    [self.tableView.pullToRefreshView setTitle:@"释放更新" forState:SVPullToRefreshStateTriggered];
    [self.tableView.pullToRefreshView setTitle:@"卖力加载中..." forState:SVPullToRefreshStateLoading];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView triggerPullToRefresh];
    });

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


#pragma mark - uitable

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel countRowOfBlogList];
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSValue *cachedSize = [self.cellItemSizes objectForKey:indexPath];
    if (cachedSize) {
        return [cachedSize CGSizeValue].height;
    }
    
    
    CGFloat h = 0.0;
    CGRect titleRect = [[self.viewModel titleOfBlogListWithRow:indexPath.row] boundingRectWithSize:CGSizeMake(self.view.width-30, CGFLOAT_MAX)
                                                                                    options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                                                 attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:18] }
                                                                                    context:nil];
    
    CGRect desRect = [[self.viewModel desOfBlogListWithRow:indexPath.row] boundingRectWithSize:CGSizeMake(self.view.frame.size.width-30, CGFLOAT_MAX)
                                                                                options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                                             attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:16] }
                                                                                context:nil];
    
    h = titleRect.size.height+desRect.size.height+50;
    
    [self.cellItemSizes setObject:[NSValue valueWithCGSize:CGSizeMake(0, h)] forKey:indexPath];
    
    
    
    return h;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
    LIBlogListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass( [LIBlogListTableViewCell class])];
    [cell textSetTitle:[self.viewModel titleOfBlogListWithRow:indexPath.row]];
    [cell textSetDes:[self.viewModel desOfBlogListWithRow:indexPath.row]];
    [cell textSetAuthor:[self.viewModel authorOfBlogListWithRow:indexPath.row] pushDate:[self.viewModel pushDateOfBlogListWithRow:indexPath.row]];
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LIBlogDetailViewController* modal=[mainStoryboard instantiateViewControllerWithIdentifier:@"LIBlogDetailViewController"];
    modal.blogURLString = [self.viewModel blogUrlOfBlogListWithRow:indexPath.row];
    [self.navigationController pushViewController:modal animated:YES];

}


@end
