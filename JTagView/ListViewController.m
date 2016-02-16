//
//  ListViewController.m
//  JTagView
//
//  Created by junlongj on 16/2/16.
//  Copyright © 2016年 junlongj. All rights reserved.
//

#import "ListViewController.h"
#import "ListImageCell.h"
#import "SCCommodityTagsView.h"
@interface ListViewController ()
@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = self.tableView.bounds.size.width;
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    return [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(ListImageCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell.imageV.tagViews enumerateObjectsUsingBlock:^(SCListCommodityTagsView * _Nonnull tagView, NSUInteger idx, BOOL * _Nonnull stop) {
        tagView.isShowExpandAnimation = true;
    }];
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(ListImageCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell.imageV.tagViews enumerateObjectsUsingBlock:^(SCListCommodityTagsView * _Nonnull tagView, NSUInteger idx, BOOL * _Nonnull stop) {
        tagView.isShowExpandAnimation = false;
    }];
}


@end
