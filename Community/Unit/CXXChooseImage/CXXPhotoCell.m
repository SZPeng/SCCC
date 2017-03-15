//
//  CXXPhotoCell.m
//  chexiaoxi
//
//  Created by Qun on 16/6/29.
//  Copyright © 2016年 IOS. All rights reserved.
//

#import "CXXPhotoCell.h"
@interface CXXPhotoCell()

@property (weak, nonatomic) IBOutlet UIButton *addImageBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@end
@implementation CXXPhotoCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.addImageBtn.userInteractionEnabled = NO;
}

- (void)setPhotoImg:(UIImage *)photoImg{
    _photoImg = photoImg;
    if (photoImg == nil) {
        [self.addImageBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        self.addImageBtn.layer.cornerRadius = 3;
        self.addImageBtn.clipsToBounds = YES;
        self.addImageBtn.userInteractionEnabled = NO;
        self.closeBtn.hidden = YES;
    }else{
        [self.addImageBtn setImage:photoImg forState:UIControlStateNormal];
        self.addImageBtn.userInteractionEnabled = YES;
        self.closeBtn.hidden = NO;
    }
}


- (IBAction)closeBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(photoCellRemovePhotoBtnClickForCell:)]) {
        [self.delegate photoCellRemovePhotoBtnClickForCell:self];
    }
}

@end
