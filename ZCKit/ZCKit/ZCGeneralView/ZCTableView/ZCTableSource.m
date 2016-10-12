//
//  ZCTableSource.m
//  ZCKit
//
//  Created by zhoucheng on 16/4/28.
//  Copyright © 2016年 t_zc. All rights reserved.
//

#import "ZCTableSource.h"

@implementation ZCTableSource


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return [_sections count];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[_sections objectAtIndex:section] cells] count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[[_sections objectAtIndex:indexPath.section] cells] objectAtIndex:indexPath.row];
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[_sections objectAtIndex:section] title];
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    id item = [_sections objectAtIndex:section];
    UIView * view = [item view];
    if(view){
        return view.frame.size.height;
    }
    return 0;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIView * v = [[[_sections objectAtIndex:indexPath.section] cells] objectAtIndex:indexPath.row];
    
    return v.frame.size.height;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[_sections objectAtIndex:section] view];
}

-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[_sections objectAtIndex:section] footerView];
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    id item = [_sections objectAtIndex:section];
    UIView * view = [item footerView];
    if(view){
        return view.frame.size.height;
    }
    return 0;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id delegate = [self delegate];
    
    if([delegate respondsToSelector:@selector(ZCTableSource:tableView:didSelectRowAtIndexPath:)]){
        [delegate ZCTableSource:self tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    
}

-(void) setSections:(NSArray *)sections{
    
    NSArray * c = [sections sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSInteger tag1 = [(ZCTableSection *) obj1 tag];
        NSInteger tag2 = [(ZCTableSection *) obj2 tag];
        NSInteger r = tag1 - tag2;
        
        if(r < 0){
            return NSOrderedAscending;
        }
        if(r > 0){
            return NSOrderedDescending;
        }
        return NSOrderedSame;
    }];
    _sections = c;
}


@end