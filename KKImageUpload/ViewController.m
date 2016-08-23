//
//  ViewController.m
//  KKImageUpload
//
//  Created by 周吾昆 on 15/11/28.
//  Copyright © 2015年 zhang_rongwu. All rights reserved.
//

#import "ViewController.h"
#import "KKUploadPhotoCollectionViewCell.h"
#import "KKPhotoPickerManager.h"

static NSString *collectionViewCellId = @"collectionViewCellId";
static CGFloat imageSize = 80;

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic, strong) UICollectionView *collectionView; //添加图片,每个cell内有一个imageView
@property(nonatomic, strong) NSMutableArray *imageArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(150, 200, 100, 20)];
    label.text = @"图片上传";
    [self.view addSubview:label];
    
    [self setCollectionView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageArray = [NSMutableArray array];

}

#pragma mark  UICollectionView数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.imageArray.count < 9) {
        return self.imageArray.count + 1;
    }
    return self.imageArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KKUploadPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellId forIndexPath:indexPath];
    //添加子控件,设置布局与控件图片
    [self addAndSetSubViews:cell indexPath:indexPath];
    return cell;
}

- (void)addAndSetSubViews:(KKUploadPhotoCollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    //清空子控件,解决重用问题
    
    NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    UIImageView *imageView = [[UIImageView alloc]init];
    [cell.contentView addSubview:imageView];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    cell.tag = 11; //根据tag值设定是否可点击,11可点击,初始全部可点击
    cell.imageView = imageView;
    cell.backgroundColor = [UIColor whiteColor];
    if(indexPath.row == self.imageArray.count){
        imageView.image = [UIImage imageNamed:@"add"];
    }else{
        imageView.image = nil;
    }
    
    UIButton *cancleBtn = [[UIButton alloc]init];
    cell.cancleBtn = cancleBtn;
    [cell.contentView addSubview: cancleBtn];
    [cancleBtn setImage:[UIImage imageNamed:@"remove"] forState:UIControlStateNormal];
    
    cancleBtn.hidden = YES;//初始将删除按钮隐藏
    
    cell.cancleBtn.tag = indexPath.row;
    [cell.cancleBtn addTarget:self action:@selector(cancleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //删除按钮 图片位置
    cell.imageView.frame = CGRectMake(0, 0, imageSize, imageSize);
    cell.cancleBtn.frame = CGRectMake(0, 0, 20, 20);
    
    if (self.imageArray.count > indexPath.row) {
        if ([self.imageArray[indexPath.row] isKindOfClass:[UIImage class]]) {
            cell.imageView.image = nil;
            cell.imageView.image = self.imageArray[indexPath.row];
            cell.cancleBtn.hidden = NO;
            cell.tag = 10; //初始设置tag为11,当为10时,表示已经添加图片
        }
    }
}

#pragma mark  collectionView代理方法,添加照片
//点击collectionView跳转到相册
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView cellForItemAtIndexPath:indexPath].tag == 11) {
        [[KKPhotoPickerManager shareInstace] showActionSheetInView:self.view fromController:self completionBlock:^(NSMutableArray *imageArray) {
            for (int i = 0; i<imageArray.count; i++) {
                if (self.imageArray.count < 9) {
                    UIImage *image = imageArray[i];
                    [self.imageArray addObject:image]; //上传图片保存到数组
                }
            }
            [self.collectionView reloadData];
        }];
    }
}

#pragma mark  删除图片
- (void)cancleBtnClick:(UIButton *)sender{
    if (sender.tag < self.imageArray.count) {
        [self.imageArray removeObjectAtIndex:sender.tag];
        sender.hidden = YES;
        [self.collectionView reloadData];
    }
}

#pragma mark  设置CollectionView
- (void)setCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(imageSize, imageSize);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 250, self.view.frame.size.width, imageSize + 20) collectionViewLayout:layout];
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    
    [self.collectionView registerClass:[KKUploadPhotoCollectionViewCell class] forCellWithReuseIdentifier:collectionViewCellId];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];

}



@end
