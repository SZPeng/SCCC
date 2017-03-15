//
//  CXXChooseImageViewController.m
//  CXXChooseImage
//
//  Created by Qun on 16/9/30.
//  Copyright © 2016年 Qun. All rights reserved.
//

#import "CXXChooseImageViewController.h"
#import "TZImagePickerController.h"
#import "CXXPhotoCell.h"
#import "UIView+Extension.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SCCHeader.h"

#define WINDOW_width  [[UIScreen mainScreen] bounds].size.width
#define WINDOW_height [[UIScreen mainScreen] bounds].size.height

//#define self.itemSpace 10
//#define rowCount 4

@interface CXXChooseImageViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, CXXPhotoCellDelegate, UIActionSheetDelegate, TZImagePickerControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
/** collectionView */
@property (nonatomic, strong) UICollectionView *collectionView;

/** layout */
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;


/** 点击的第几个item */
@property (nonatomic, strong) NSIndexPath *selectIndexPath;

/** 每一行多少个 */
@property (nonatomic, assign) NSInteger rowCount;
/**  itemSize*/
@property (nonatomic, assign) CGSize itemSize;
/** 间距 */
@property (nonatomic, assign) CGFloat itemSpace;

@end

@implementation CXXChooseImageViewController

static NSString * const photoID = @"photoID";
- (instancetype)init{
    self = [super init];
    if (self) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        self.layout = layout;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;

    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.layout];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleWidth;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CXXPhotoCell" bundle:nil] forCellWithReuseIdentifier:photoID];
}

#pragma mark - CXXPhotoCellDelegate
// 删除照片
- (void)photoCellRemovePhotoBtnClickForCell:(CXXPhotoCell *)cell{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    if (self.dataArr.count > 0) {
        [self.dataArr removeObjectAtIndex:indexPath.item];
    }
    [self.collectionView reloadData];
    
    [self resetHeight];
}

-(void)removeAllPhoto
{
    [self.dataArr removeAllObjects];
    [self.collectionView reloadData];
    
    [self resetHeight];

}
#pragma mark - collect数据源
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.dataArr.count >= self.maxImageCount) {
        return self.maxImageCount;
    }
    return self.dataArr.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CXXPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoID forIndexPath:indexPath];
    cell.delegate = self;
    if (cell == nil) {
        cell = [[CXXPhotoCell alloc]init];
    }
    
    if(self.dataArr.count == 0){
        cell.photoImg = nil;
    }else{
        cell.photoImg = indexPath.item <= self.dataArr.count - 1 ? self.dataArr[indexPath.item] : nil;
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectIndexPath = indexPath;
    
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:@"请选择相机或者相册" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开相机",@"打开相册",nil];
    [action showInView:self.view];
    
}
#pragma mark - 打开相机 相册
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self openCamera];
            break;
        case 1:
            [self openAlbum];
            break;
        default:
            break;
    }
}
- (void)openCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        ipc.delegate = self;
        [self presentViewController:ipc animated:YES completion:nil];
    } else {
//        [self showHint:@"请打开允许访问相机权限"];
        NSLog(@"请打开允许访问相机权限");
    }
}
- (void)openAlbum
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxImageCount - self.selectIndexPath.item delegate:self];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }else{
//        [self showHint:@"请打开允许访问相册权限"];
        NSLog(@"请打开允许访问相册权限");
    }
}
#pragma mark - UIImagePickerControllerDelegate
//相机选的图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 关闭相册\相机
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 往数据数组拼接图片
    UIImage *imageNew = info[UIImagePickerControllerOriginalImage];
    CGSize imagesize = imageNew.size;
    imagesize.height =WIN_HEIGHT*(800/WIN_WIDTH);
    imagesize.width = 800;
    //对图片大小进行压缩--
    imageNew = [self imageWithImage:imageNew scaledToSize:imagesize];
    imageNew = [self fixOrientation:imageNew];
    [self.dataArr addObject:imageNew];
//    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset)
//    {
//        ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];
//        NSLog(@"[imageRep filename] : %@", [imageRep filename]);
//    };
    [self reloadData];
}
//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
//取消按钮
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picke{
    [self dismissViewControllerAnimated:YES completion:nil];
}
// 相册选的图片
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    [self.dataArr addObjectsFromArray:photos];
    [self reloadData];
}
#pragma mark - set方法
- (void)setOrigin:(CGPoint)origin ItemSize:(CGSize)itemSize rowCount:(NSInteger)rowCount{
    self.rowCount = rowCount;
    self.itemSize = itemSize;
    CGFloat itemSpace = (WINDOW_width - itemSize.width * rowCount) / (rowCount + 1);
    self.itemSpace = itemSpace;
    self.layout.itemSize = itemSize;
    self.layout.minimumLineSpacing = itemSpace;
    self.layout.minimumInteritemSpacing = itemSpace;
    self.layout.sectionInset = UIEdgeInsetsMake(itemSpace, itemSpace, itemSpace, itemSpace);
    self.view.frame = CGRectMake(origin.x, origin.y, WINDOW_width, itemSize.width + 2 * itemSpace);
}
- (void)setMaxImageCount:(NSInteger)maxImageCount{
    _maxImageCount = maxImageCount;
    [self.collectionView reloadData];
}
- (NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}
- (void)reloadData{
    // 大于maxImageCount条的删除
    if (self.dataArr.count > self.maxImageCount) {
        NSRange range = NSMakeRange(self.maxImageCount, self.dataArr.count - self.maxImageCount);
        [self.dataArr removeObjectsInRange:range];
    }
    [self.collectionView reloadData];
    
    [self resetHeight];
}
// 重置高度
- (void)resetHeight{
    NSInteger count = self.dataArr.count / self.rowCount + 1; // 行数
    CGFloat height = (count + 1) *  self.itemSpace + count * self.itemSize.height;
    if ([self.delegate respondsToSelector:@selector(chooseImageViewControllerDidChangeCollectionViewHeigh:)]) {
        [self.delegate chooseImageViewControllerDidChangeCollectionViewHeigh:height];
    }
    self.collectionView.height = height;
}
#pragma mark-使得图片不旋转
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    if (aImage.imageOrientation == UIImageOrientationUp) return aImage;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) { case UIImageOrientationDown: case UIImageOrientationDownMirrored: transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height); transform = CGAffineTransformRotate(transform, M_PI); break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) { case UIImageOrientationUpMirrored: case UIImageOrientationDownMirrored: transform = CGAffineTransformTranslate(transform, aImage.size.width, 0); transform = CGAffineTransformScale(transform, -1, 1); break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height, CGImageGetBitsPerComponent(aImage.CGImage), 0, CGImageGetColorSpace(aImage.CGImage), CGImageGetBitmapInfo(aImage.CGImage)); CGContextConcatCTM(ctx, transform); switch (aImage.imageOrientation) { case UIImageOrientationLeft: case UIImageOrientationLeftMirrored: case UIImageOrientationRight: case UIImageOrientationRightMirrored:
            
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx); UIImage *img = [UIImage imageWithCGImage:cgimg]; CGContextRelease(ctx); CGImageRelease(cgimg); return img;
    
}
@end
