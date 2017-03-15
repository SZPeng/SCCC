//
//  PersonMessage.m
//  SCCBBS
//
//  Created by co188 on 17/1/9.
//  Copyright © 2017年 co188. All rights reserved.
//

#import "PersonMessage.h"
#import "SCCHeader.h"
#import <AFNetworking.h>
#import <MBProgressHUD.h>
#import <UIImageView+WebCache.h>
#import "SCCImagePickerController.h"
#import "tools.h"
#import "SCCAFnetTool.h"
#import "MessageTool.h"

@interface PersonMessage ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UILabel *_label;
    UIButton *_leftBtn;
    NSMutableArray *_dataArray;
    UITableView *_tableView;
    
    UIView *_headView;
    UIImage   * _headImgPlaceploder;
    MBProgressHUD *_HUD;
    NSString * _nameStr;   //昵称
    NSString *_userName;  //用户名
    NSString *_telNum;
    NSInteger _sex;
    NSString * _birthday;
    NSString *_birthyear;
    NSString *_birthmonth;
    NSString *_imgUrl;
    NSString *_avatar;
    NSString *_imageString;
    UIDatePicker *_dataPicker;
    UIView *_pickView;
    NSString *_dateString;
    
    NSString *_qianMing; // 签名

}
@end

@implementation PersonMessage

-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataArray = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = Af4f5f9;
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,WIN_WIDTH ,64 )];
    headView.backgroundColor = TMHEADCOLO;
    [self.view addSubview:headView];
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 200, 44)];
    _label.backgroundColor = [UIColor clearColor];
    _label.text = @"个人信息";
    _label.textAlignment = NSTextAlignmentCenter;
    
    _label.font = [UIFont systemFontOfSize:18];
    _label.textColor = [UIColor whiteColor];
    _label.center = CGPointMake(headView.center.x, _label.center.y);
    [headView addSubview:_label];
    
    _leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 0, 40, 44)];
    _leftBtn.imageEdgeInsets=UIEdgeInsetsMake(10, 6, 9, 15);
    [_leftBtn setImage:[UIImage imageNamed:@"back"]  forState:UIControlStateNormal];
    [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    _leftBtn.center = CGPointMake(_leftBtn.center.x, _label.center.y);
    [headView addSubview:_leftBtn];
    [self prepareData];
}

-(void)prepareData
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;
    NSString *urlString = [NSString stringWithFormat:@"%@/protected/member/getUserDetailInfo",API_HOST];
    NSLog(@"%@",urlString);
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([code isEqualToString:@"0"]){
            NSDictionary *dataDic = responseObject[@"data"];
            _imgUrl = dataDic[@"avatar"];
            _birthday = dataDic[@"birthday"];
            _userName = [NSString stringWithFormat:@"%@",dataDic[@"username"]];
            _nameStr = dataDic[@"nickname"];
            _sex = [dataDic[@"gender"] integerValue];
            _qianMing = dataDic[@"signature"];
            NSLog(@"%@",_qianMing);
            _telNum = [NSString stringWithFormat:@"%@",dataDic[@"mobile"]];
            [self createUI];
        }else if([code isEqualToString:@"500"]){
            [tools alert:responseObject[@"msg"]];
        }else if([code isEqualToString:@"401"]){
            [tools alert:responseObject[@"msg"]];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

}
-(void)createUI
{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, WIN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.contentInset=UIEdgeInsetsMake(10, 0, 0, 0);
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    _tableView.backgroundColor=self.view.backgroundColor;
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 5)];
    headView.backgroundColor = Af4f5f9;
    _tableView.tableHeaderView = headView;
    _tableView.tableFooterView=[[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    else if (section==1)
    {
        return 4;
    }
    else
    {
        return 2;
    }
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        UIImageView * imgView=[[UIImageView alloc] initWithFrame:CGRectMake(tableView.bounds.size.width-80, 5, 60, 60)];
        imgView.tag=100;
        imgView.layer.cornerRadius=30;
        imgView.clipsToBounds = YES;
//        imgView.layer.masksToBounds=YES;
        [cell addSubview:imgView];
    }
    UIImageView * imgView=(UIImageView *)[cell viewWithTag:100];
    imgView.hidden=indexPath.row;
    cell.textLabel.textColor=A333;
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    cell.detailTextLabel.textColor=A333;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text=@"头像";
            if (_imgUrl==nil || [_imgUrl isEqualToString:@""])
            {
                imgView.image=_headImgPlaceploder;
            }
            else
            {
                
                [imgView sd_setImageWithURL:[NSURL URLWithString:_imgUrl] placeholderImage:[UIImage imageNamed:@"df_wode"]];
            }
        }
        
    }
    else if (indexPath.section==1)
    {
        if(indexPath.row == 0){
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.textColor = A999;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text=@"用户名";
            cell.detailTextLabel.text=_userName;
        }else if(indexPath.row == 1){
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.textColor = A999;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text=@"手机";
            cell.detailTextLabel.text= _telNum;
        }else if(indexPath.row == 2){
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.textColor = A999;
            cell.textLabel.text=@"昵称";
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.detailTextLabel.text=_nameStr;
        }else if(indexPath.row == 3){
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.textColor = A333;
            cell.textLabel.text=@"性别";
            cell.detailTextLabel.text=_sex==1?@"女":_sex==2?@"男":@"未知";
        }
    }else if(indexPath.section == 2){
        if(indexPath.row == 0){
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.textColor = A333;
            cell.textLabel.text=@"生日";
            cell.detailTextLabel.text= _birthday;
        }else{
            cell.textLabel.text=@"签名";
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            cell.detailTextLabel.textColor = A333;
            if(_qianMing.length > 0){
                cell.detailTextLabel.text= _qianMing;
            }else{
                cell.detailTextLabel.text= @"尚未编辑个性签名，点击编辑";
            }
            
        }
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0&&indexPath.section==0)
    {
        return 70;
    }
    return 57;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //    if (textField.text.length<=10)
    //    {
    //        return YES;
    //    }
    //    else
    //    {
    //        if ([string isEqualToString:@""])
    //        {
    //            return YES;
    //        }
    //        return NO;
    //    }
    return YES;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 5)];
    v.backgroundColor=Af4f5f9;
    return v;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_pickView removeFromSuperview];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
//        if (indexPath.row==0) {
//            UIActionSheet * headSheet = [[UIActionSheet alloc] initWithTitle:@"选择图片方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选取",@"打开照相机", nil];
//            headSheet.tag=0;
//            [headSheet showInView:self.view];
//        }
        [_tableView deselectRowAtIndexPath:indexPath animated:YES];

    }else if(indexPath.section == 1){
        if(indexPath.row == 0){
            [_tableView deselectRowAtIndexPath:indexPath animated:YES];
        }else if(indexPath.row == 1){
            [_tableView deselectRowAtIndexPath:indexPath animated:YES];

        } else if(indexPath.row == 2){
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"请输入昵称" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            alertView.tag=1;
            alertView.alertViewStyle=UIAlertViewStylePlainTextInput;
            [[alertView textFieldAtIndex:0] setDelegate:self];
//            [alertView show];
            
        }else if(indexPath.row == 3){
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"请选择性别" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"男",@"女", nil];
            alertView.tag=2;
            [alertView show];
        }
    }else if(indexPath.section == 2){
        if(indexPath.row == 0){
            _pickView = [[UIView alloc]initWithFrame:CGRectMake(0, WIN_HEIGHT - 200, WIN_WIDTH, 200)];
            _pickView.backgroundColor = [UIColor whiteColor];
            UIView *finishView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 30)];
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH - 50, 0, 40, 30)];
            [btn setTitle:@"完成" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(dataAction) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:[UIColor colorWithRed:0.31f green:0.74f blue:0.98f alpha:1.00f] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [finishView addSubview:btn];
            UIButton *qBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 40, 30)];
            [qBtn setTitle:@"取消" forState:UIControlStateNormal];
            [qBtn addTarget:self action:@selector(lostAction) forControlEvents:UIControlEventTouchUpInside];
            [qBtn setTitleColor:[UIColor colorWithRed:0.31f green:0.74f blue:0.98f alpha:1.00f] forState:UIControlStateNormal];
            qBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [finishView addSubview:qBtn];
            
            UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 0.5)];
            line.backgroundColor = LINECOLOR;
            [finishView addSubview:line];
            [_pickView addSubview:finishView];
            _dataPicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 30, WIN_WIDTH, 170)];
            [_pickView addSubview:_dataPicker];
            //            _pickView.
            //            NSDate *MinDate = [[NSDate alloc]initWithString:@"1900-01-01 00:00:00 -0500"];
            _dataPicker.datePickerMode = UIDatePickerModeDate;
            [self.view addSubview:_pickView];

        }else{
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"请输入签名" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            alertView.tag=3;
            alertView.alertViewStyle=UIAlertViewStylePlainTextInput;
            [[alertView textFieldAtIndex:0] setDelegate:self];
            [alertView show];
        }
    }
}
#pragma mark- datachange
-(void)dataAction
{
    NSLog(@"%@",_dataPicker.date);
    NSString *str = [NSString stringWithFormat:@"%@",_dataPicker.date];
    NSString *dataStr = [str substringToIndex:10];
    _birthday = dataStr;
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationFade];
    NSLog(@"%@",dataStr);
    [_pickView removeFromSuperview];
    [self upData:@"birthday" withString:_birthday withType:@"1"];
}
-(void)lostAction
{
    [_pickView removeFromSuperview];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag)
    {
        case 1://姓名
        {
            if (buttonIndex==0)
            {
                UITextField * tf=[alertView textFieldAtIndex:0];
                if ([tf.text length]!=0) {
                    _nameStr=tf.text;
                    [_tableView reloadData];
                }
                [self upData:@"nickname" withString:_nameStr withType:@"10"] ;
            }
        }
            break;
        case 2://性别
        {
            if (buttonIndex==1)//男
            {
                _sex=2;
                [_tableView reloadData];
                
            }
            else if(buttonIndex==2)
            {
                _sex=1;
                [_tableView reloadData];
            }
            [self upData:@"gender" withString:[NSString stringWithFormat:@"%ld",_sex] withType:@"10"];
        }
            break;
        case 3:
            if (buttonIndex==0)
            {
                UITextField * tf=[alertView textFieldAtIndex:0];
                if ([tf.text length]!=0) {
                    _qianMing = tf.text;
                    [_tableView reloadData];
                    [self upData:@"signature" withString:_qianMing withType:@"10"];
                }
                
            }
            break;
        default:
            break;
    }
}

-(void)upData:(NSString *)str withString:(NSString *)name withType:(NSString *)type
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;
    NSString *urlString = [NSString stringWithFormat:@"%@/protected/member/updateUserinfo",API_HOST];
    NSLog(@"%@",urlString);
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    if(type.length > 1){
        name = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
    }
    [messageDic setObject:@"utf-8" forKey:@"charset"];
    [messageDic setObject:name forKey:str];
    NSLog(@"%@",messageDic);
    [afTool postMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([code isEqualToString:@"0"]){
            
        }else if([code isEqualToString:@"500"]){
            [tools alert:responseObject[@"msg"]];
        }else if([code isEqualToString:@"401"]){
            [tools alert:responseObject[@"msg"]];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 100){
        
    }else{
        switch (buttonIndex)
        {
            case 0://相册
            {
                [self LocalPhoto];
            }
                break;
            case 1://相机
            {
                [self takePhoto];
            }
                break;
            default:
                break;
        }
    }
}

//打开相册
-(void)LocalPhoto{
    SCCImagePickerController *picker = [[SCCImagePickerController alloc]init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

//打开相机
-(void)takePhoto
{
    SCCImagePickerController *picker = [[SCCImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
    
}

//选择照片后进入
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *imageNew = info[UIImagePickerControllerOriginalImage];
    CGSize imagesize = imageNew.size;
    imagesize.height =200;
    imagesize.width =200;
    //对图片大小进行压缩--
    imageNew = [self imageWithImage:imageNew scaledToSize:imagesize];
    NSData *imageData = UIImageJPEGRepresentation(imageNew, 1.0);
    //    NSString *imageString = [[NSString alloc] initWithData:imageData encoding:NSUTF8StringEncoding];
    
    _imageString = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    
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

#pragma mark- 保存
-(void)saveAction
{
    
}

#pragma mark-UITextDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma Mark- 返回
-(void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark- 修改状态栏
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end
