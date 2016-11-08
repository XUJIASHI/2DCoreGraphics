//
//  ViewController.m
//  2DCoreGraphicesExamoles
//
//  Created by walter on 16/11/7.
//  Copyright © 2016年 walter. All rights reserved.
//

#import "ViewController.h"
#import "ViewController2.h"
#import "ShoppingCarCell.h"

#import <AudioToolbox/AudioToolbox.h>
//写一个宏，返回两个数的最小值
#define kMin(x, y) ((x) > (y) ? (y) : (x))

//角度转化为弧度,
#define kToDian(angle) ((angle) * M_PI / 180)




@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,strong)UIImageView *imageV;
@property(nonatomic,strong)NSMutableArray *imagesArr;
@property(nonatomic,strong)UITextField *textField1;
@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, weak) UITableView *tableView;
/**
 *  购物车按钮
 */
@property (nonatomic, weak) UIButton *shoppingCarButton;

@property(nonatomic,strong)UIImageView *topImageView;
@property(nonatomic,strong)UIImageView *bottomImageView;

@property (nonatomic, strong) UIDynamicAnimator *animator;

/**
 *  重力行为
 */
@property (nonatomic, strong) UIGravityBehavior *gravity;

/**
 *  碰撞行为
 */
@property (nonatomic, strong) UICollisionBehavior *collision;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self imageViewAnimation];

    
}
- (IBAction)oneBarButtonItem:(UIBarButtonItem *)sender {
    [self animationWithPath];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(animations) userInfo:nil repeats:YES];
}

- (UIColor *)randomColor
{
    return [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
}

- (void)animations
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(arc4random_uniform(self.view.frame.size.width - 60), 0, 70, 70)];
    view.layer.contents = (id)[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",arc4random()%8+1]].CGImage;
    view.layer.cornerRadius = 35;
    view.layer.masksToBounds = YES;
    
    //    view.backgroundColor = [self randomColor];
    [self.view addSubview:view];
    
    //添加重力行为
    [self.gravity addItem:view];
    //添加碰撞行为
    [self.collision addItem:view];
    
    //执行重力行为
    [self.animator addBehavior:self.gravity];
    //执行碰撞行为
    [self.animator addBehavior:self.collision];
    
}



//重力行为
- (UIGravityBehavior *)gravity
{
    if (!_gravity)
    {
        _gravity = [[UIGravityBehavior alloc] init];
    }
    
    return _gravity;
}

- (UICollisionBehavior *)collision
{
    if (!_collision)
    {
        _collision = [[UICollisionBehavior alloc] init];
        //不会超过当前view的边界
        _collision.translatesReferenceBoundsIntoBoundary = YES;
    }
    
    return _collision;
}

//所有行为的执行者
- (UIDynamicAnimator *)animator
{
    if (!_animator)
    {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    
    return _animator;
}



-(void)animationWithPath{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.view.bounds;
    //填充颜色
    layer.fillColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:layer];
    
    
    //path1
    CGMutablePathRef startPath = CGPathCreateMutable();
    CGPathAddRect(startPath, NULL, CGRectMake(100, 700, 50, 0));
    
    layer.path = startPath;
    
    //path2
    CGMutablePathRef endPath = CGPathCreateMutable();
    CGPathAddRect(endPath, NULL, CGRectMake(100, 400, 50, 300));
    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.duration = 5;
    //开始path
    animation.fromValue = (__bridge id)startPath;
    //结束的path
    animation.toValue = (__bridge id _Nullable)(endPath);
    
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    
    [layer addAnimation:animation forKey:nil];
    
    
    
    //释放path
    CGPathRelease(startPath);
    CGPathRelease(endPath);
}
-(void)animationForKeyPath{
    //红色 -> 绿色
    
    UIView *view = [[UIView alloc] init];
    view.bounds = CGRectMake(0, 0, 100, 100);
    view.center = self.view.center;
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    
    //修改的背景颜色
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    animation.duration = 2;
    animation.toValue = (id)[UIColor greenColor].CGColor;
    animation.autoreverses = YES;
    animation.repeatCount = MAXFLOAT;
    [view.layer addAnimation:animation forKey:nil];
    
    //修改圆角
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    animation2.duration = 2;
    animation2.toValue = @(50);
    animation2.autoreverses = YES;
    animation2.repeatCount = MAXFLOAT;
    [view.layer addAnimation:animation2 forKey:nil];
}

-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
    /**
     *  隐式动画
     */
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    //transform.translation.y
    animation.duration = 0.5;
    //动画结束的位移，相对于原来的位置
    animation.toValue = @(-25);
    animation.autoreverses = YES;
    [self.topImageView.layer addAnimation:animation forKey:nil];
    
    //向下移动
    animation.toValue = @(25);
    [self.bottomImageView.layer addAnimation:animation forKey:nil];
    
    
    //播放短音效
    //soundID
    SystemSoundID systemSoundID;
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"shake_sound_male.wav" ofType:nil]];
    
    //加载指定的短音效
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(url), &systemSoundID);
    //播放指定的soundID
    AudioServicesPlaySystemSound(systemSoundID);
}

- (IBAction)twoBarButtonItem:(UIBarButtonItem *)sender {
    [self createShoppingCar];
    [self tableView];
}
- (void)createShoppingCar
{
    CGFloat space = 20;
    
    CGFloat width = 60;
    CGFloat height = width;
    
    CGFloat x = space;
    CGFloat y = self.view.frame.size.height - 150;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(x, y, width, height);
    [btn setBackgroundImage:[UIImage imageNamed:@"1.jpg"] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    self.shoppingCarButton = btn;
}
- (void)startAnimation:(CGPoint)startPoint
{
    //起点
    startPoint = [self.tableView convertPoint:startPoint toView:self.view];
    //终点坐标
    CGPoint endPoint = self.shoppingCarButton.center;
    //控点
    CGFloat cx = endPoint.x;
    CGFloat cy = startPoint.y;
    
    /*
     一、构造贝塞尔曲线
     */
    CGMutablePathRef path = CGPathCreateMutable();
    //添加抛物线
    //1.起点
    CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
    //2.控制点和终点
    CGPathAddQuadCurveToPoint(path, NULL, cx, cy, endPoint.x, endPoint.y);
    
    
    /*
     二、创建要进行动画视图
     */
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1.jpg"]];
    imageView.bounds = CGRectMake(0, 0, 40, 40);
    imageView.layer.cornerRadius = 20;
    imageView.clipsToBounds = YES;
    [self.view addSubview:imageView];
    
    
    /*
     三、执行动画
     */
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.duration = 5;
    //设置path
    animation.path = path;
    //停留在终点
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    animation.delegate = self;
    
    [imageView.layer addAnimation:animation forKey:nil];
    
    
    //释放path
    CGPathRelease(path);
}

- (IBAction)three:(UIBarButtonItem *)sender {
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandle:)];
    [self.imageView addGestureRecognizer:gesture];
}

- (void)longPressHandle:(UILongPressGestureRecognizer *)longPress
{
    
    /*
     self.imageView.transform
     反射变换：
     1.弧度
     2.比例
     3.唯一
     */
    
    //长按开始
    if (longPress.state == UIGestureRecognizerStateBegan)
    {
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.duration = 0.15;
        //关键点
        animation.values = @[@(kToDian(5)),
                             @(kToDian(0)),
                             @(kToDian(-5)),
                             @(kToDian(0)),
                             ];
        animation.repeatCount = MAXFLOAT;
        [self.imageView.layer addAnimation:animation forKey:@"animation"];
        
        
        //3秒后停止动画
#if 0
        //停止所有动画
        [self.imageView.layer removeAllAnimations];
        //停止指定的动画
        [self.imageView.layer removeAnimationForKey:@"key"];
#endif
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //停止指定的动画
            [self.imageView.layer removeAnimationForKey:@"animation"];
        });
    }
}
//01,waggle
- (IBAction)fourBarButtonItem:(UIBarButtonItem *)sender {
    self.navigationController.navigationBar.translucent = NO;
    UIView *red = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    red.backgroundColor = [UIColor redColor];
    [self.view addSubview:red];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    animation.duration = 0.15;
    //关键点
    animation.values = @[@5,@0,@(-5),@0];
    //参照当前的position点移动多少。
    animation.additive = YES;//YES把更改的值追加到当前的present层中 keypath+=value ，NO是把更改的值设置成当前present层的值keypath = value
    //动画连续执行2次
    animation.repeatCount = 2;
    self.textField1 = [[UITextField alloc]initWithFrame:CGRectMake(0, 50, 300, 20)];
    self.textField1.text = @"wrong";
    self.textField1.borderStyle = UITextBorderStyleRoundedRect;
    self.textField1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.textField1];
    [self.textField1.layer addAnimation:animation forKey:nil];
    
    NSLog( @"four");
}


//5
-(void)keyAnimation2{
    CAKeyframeAnimation *ani = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    ani.duration = 0.5;
    ani.values = @[@5,@0,@(-5),@0];
    ani.additive = YES;
    ani.repeatCount = 3;
    UITextField *tf = [self textField];
    tf.frame = CGRectMake(0, 300, 200, 30);
    tf.text = @"world";
    [self.view addSubview:tf];
    [self.view.layer addAnimation:ani forKey:nil];
}
//4.key animation
-(void)keyAnimation{
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 200, 200);
    layer.position = self.view.center;
    layer.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1].CGColor;
    [self.view.layer addSublayer:layer];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddEllipseInRect(path, NULL, CGRectMake(0, 0, 400, 400));
    CGPathAddRect(path, NULL, CGRectMake(0, 0, 100, 1000));
    CGPathAddQuadCurveToPoint(path, NULL, 300, 0, 0, M_PI * 2);
    
    CGFloat startx = 0;
    CGFloat starty = 500;
    CGFloat endx = 400;
    CGFloat endy = 500;
    CGFloat cpx = 200;
    CGFloat cpy = 0;
    
    CGPathMoveToPoint(path, NULL, startx, starty);
    CGPathAddQuadCurveToPoint(path, NULL, cpx, cpy, endx, endy);
    CAKeyframeAnimation *ani = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    ani.duration  = 4;
    ani.removedOnCompletion = NO;
    ani.fillMode = kCAFillModeForwards;
    ani.path = path;
    ani.calculationMode = kCAAnimationPaced;
    [layer addAnimation:ani forKey:nil];
    CFRelease(path);
}


//3.
-(void)keyframeAnimation{
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 200, 200);
    layer.position = self.view.center;
    layer.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1].CGColor;
    [self.view.layer addSublayer:layer];
    
    CAKeyframeAnimation *ani = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    ani.duration = 30;
    ani.values = @[[NSValue valueWithCGPoint:CGPointMake(100, 100)],[NSValue valueWithCGPoint:CGPointMake(300, 100)],[NSValue valueWithCGPoint:CGPointMake(300, 500)],[NSValue valueWithCGPoint:CGPointMake(100, 300)],[NSValue valueWithCGPoint:CGPointMake(100, 100)]];
    ani.autoreverses = YES;
    ani.removedOnCompletion = NO;
    ani.fillMode = kCAFillModeForwards;
    [layer addAnimation:ani forKey:@"kk"];
}

//2.
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self keyframeAnimation];
    
//    ViewController2 *vc2  = [[ViewController2 alloc]init];
//    CATransition *ani = [CATransition animation];
//    ani.type = @"cube";
//    ani.subtype = kCATransitionFromTop;
//    ani.duration = 30;
//    [self.navigationController.view.layer addAnimation:ani forKey:nil];
//    
//    [self.navigationController pushViewController:vc2 animated:YES];
    
//    [self keyAnimation2];
}
//1.
-(void)imageViewAnimation{
    self.imageV.animationImages = self.imagesArr;
    self.imageV.animationDuration = 3;
    self.imageV.animationRepeatCount = 10;
    [self.imageV startAnimating];
}
#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShoppingCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    //设置加入购物车回调
    [cell setShoppingCarCellDidClickShoppingCarButtonCallback:^(CGPoint startPoint)
     {
         //开始动画
         [self startAnimation: startPoint];
         
     }];
    
    return cell;
}

/**
 *  动画完成会自动触发
 *
 *  @param anim <#anim description#>
 *  @param flag <#flag description#>
 */
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag)
    {
        NSLog(@"动画完成========");
    }
}

#pragma mark - getter

- (UITableView *)tableView
{
    if (!_tableView)
    {
        UITableView *tb = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        tb.delegate = self;
        tb.dataSource = self;
        tb.rowHeight = 120;
        [self.view addSubview:tb];
        
        [tb registerNib:[UINib nibWithNibName:@"ShoppingCarCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
        
        _tableView = tb;
    }
    
    return _tableView;
}

- (UIImageView *)imageView
{
    if (!_imageView)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1.jpg"]];
        imageView.bounds = CGRectMake(0, 0, 100, 100);
        imageView.center = self.view.center;
        imageView.layer.cornerRadius = 15;
        imageView.userInteractionEnabled = YES;
        [self.view addSubview:imageView];
        
        _imageView = imageView;
    }
    
    return _imageView;
}

-(UITextField *)textField{
    UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(0, 200, 200, 30)];
    tf.text = @"hell0 ";
    [self.view addSubview:tf];
    
    return tf;
}

-(CALayer *)layer{
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 200, 200);
    layer.position = self.view.center;
    layer.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1].CGColor;
    [self.view.layer addSublayer:layer];
    return layer;
}
-(UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:_imageV];
    }return _imageV;
}
-(NSMutableArray *)imagesArr{
    if (!_imagesArr) {
        _imagesArr = [[NSMutableArray alloc]init];
        for (int i = 1; i<=8; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]];
            [_imagesArr addObject:image];
        }
    }return _imagesArr;
}

@end
