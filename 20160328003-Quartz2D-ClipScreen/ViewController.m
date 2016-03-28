//
//  ViewController.m
//  20160328003-Quartz2D-ClipScreen
//
//  Created by Rainer on 16/3/28.
//  Copyright © 2016年 Rainer. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    CGPoint _startPoint;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) UIView *clipView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加一个拖动手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAction:)];
    
    [self.view addGestureRecognizer:panGestureRecognizer];
}

/**
 *  拖动手势事件处理
 */
- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)panGestureRecognizer {
    // 移动中的点
    CGPoint changedPoint = CGPointZero;
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {  // 开始拖动手指
        // 记录开始触摸的点作为裁剪区域的原点
        _startPoint = [panGestureRecognizer locationInView:self.view];
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) { // 拖动中
        // 取得当前拖动的位置点
        changedPoint = [panGestureRecognizer locationInView:self.view];
        
        // 获取裁剪区域
        CGFloat clipViewX = _startPoint.x;
        CGFloat clipViewY = _startPoint.y;
        CGFloat clipViewW = changedPoint.x - _startPoint.x;
        CGFloat clipViewH = changedPoint.y - _startPoint.y;
        
        // 设置裁剪区域
        self.clipView.frame = CGRectMake(clipViewX, clipViewY, clipViewW, clipViewH);
    } else { // 拖动完成
        // 1.根据当前图片视图创建一个图形上下文
        UIGraphicsBeginImageContextWithOptions(self.imageView.bounds.size, NO, 0.0);
        
        // 2.给当前上下文设置裁剪区域
        // 2.1.获取上下文
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        // 2.2.创建一个裁剪区域路径
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:self.clipView.frame];
        
        // 2.3.设置裁剪区域
        [bezierPath addClip];
        
        // 3.把控件上的内容渲染到上下文
        [self.imageView.layer renderInContext:context];
        
        // 4.将当前上下文保存为图片
        UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // 5.关闭上下文
        UIGraphicsEndImageContext();
        
        // 6.将最新图片展示到视图上
        self.imageView.image = clipImage;
        
        // 7.移除裁剪视图
        [self.clipView removeFromSuperview];
        self.clipView = nil;
    }
}

/**
 *  懒加载裁剪区域视图
 */
- (UIView *)clipView {
    if (nil == _clipView) {
        UIView *clipView = [[UIView alloc] init];
        
        clipView.backgroundColor = [UIColor blackColor];
        clipView.alpha = 0.5;
        
        _clipView = clipView;
        
        [self.view addSubview:_clipView];
    }
    
    return _clipView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
