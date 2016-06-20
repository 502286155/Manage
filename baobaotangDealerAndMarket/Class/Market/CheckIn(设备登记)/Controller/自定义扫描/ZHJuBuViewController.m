//
//  ZHJuBuViewController.m
//  ZH二维码
//
//  Created by haodf on 16/1/8.
//  Copyright © 2016年 ZH. All rights reserved.
//

#import "ZHJuBuViewController.h"
#import "ZBarSDK.h"

@interface ZHJuBuViewController () <ZBarReaderViewDelegate>
{
    ZBarReaderView *readView;
}

@property (weak, nonatomic) IBOutlet UIView *juBuView;

@property (weak, nonatomic) IBOutlet UIView *scanView;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic, strong) UIView *line;

@end

@implementation ZHJuBuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    
    [self setSubView];
    
//    self.title = @"ZH自定义二维码扫描";
    
    readView = [ZBarReaderView new];
    
    readView.torchMode = 0;
    
    // 自定义大小
    readView.frame = CGRectMake(0, 0, self.juBuView.width, self.juBuView.height);
    
    // 设置代理
    readView.readerDelegate = self;
    
    // 将其照相机拍摄视图添加到要显示的视图上
    [self.juBuView addSubview:readView];
    
    [self.juBuView sendSubviewToBack:readView];
    
    // 二维码 条形码识别设置`
    ZBarImageScanner *scanner = readView.scanner;
    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    
    // 启动，必须启动后，手机摄像头拍摄的即时图像才可以显示在readview上
    [readView start];
}

- (void)setNav
{
    self.navigationItem.title = @"扫码绑定";
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_button_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(returnClick)];
}
- (void)returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
    [readView removeFromSuperview];
}
// 设置子视图
- (void)setSubView
{
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftView.frame), CGRectGetMaxY(self.scanView.frame) + 5, CGRectGetMinX(self.rightView.frame) - CGRectGetMaxX(self.leftView.frame), 20)];
    topLabel.text = @"将二维码或条形码放入框内";
    topLabel.font = [UIFont systemFontOfSize:14];
    topLabel.textColor = [UIColor whiteColor];
    topLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:topLabel];
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(topLabel.frame), CGRectGetMaxY(topLabel.frame), topLabel.width, 20)];
    bottomLabel.textColor = [UIColor whiteColor];
    bottomLabel.font = [UIFont systemFontOfSize:14];
    bottomLabel.text = @"即可自动扫描";
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bottomLabel];
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(self.scanView.x + 10, self.scanView.y, self.scanView.width - 20, 1)];
    line.backgroundColor = [UIColor greenColor];
    [self.view addSubview:line];
    self.line = line;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(beginTimer) userInfo:nil repeats:YES];
        [timer fire];
    });
}
- (void)beginTimer
{
    [UIView animateWithDuration:2 animations:^{
        self.line.y = CGRectGetMaxY(self.scanView.frame);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2 animations:^{
            self.line.y = self.scanView.y;
        }];
    }];
}


#pragma ZBarReaderViewDelegate
- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image {
    
    ZBarSymbol *symbol = nil;
    for (symbol in symbols) {
        break;
    }
    
    NSString *text = symbol.data;
    
    self.block (text);
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [readerView removeFromSuperview];
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

@end
