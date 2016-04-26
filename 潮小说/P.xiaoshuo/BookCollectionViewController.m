//
//  BookCollectionViewController.m
//  P.xiaoshuo
//
//  Created by 王开政 on 16/3/18.
//  Copyright (c) 2016年 Wang. All rights reserved.
//

#import "BookCollectionViewController.h"
#import "ReadViewController.h"
#import "dateBase.h"
#import "Informaton.h"
#import "AppDelegate.h"

@interface BookCollectionViewController ()

@end

@implementation BookCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImage *img =[UIImage imageNamed:@"书架界面背景"];
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:img];
    dateBase *db = [[dateBase alloc]init];
   self.bookArray = [[NSMutableArray alloc]init];
   self.bookArray = [db getBookListMassage];//获取书单信息，将他放到数组里
   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *myDirectory = [documentsDirectory stringByAppendingPathComponent:@"bookName"];
    self.bookFiles = [fileManage subpathsAtPath: myDirectory ];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    
    //创建长按手势监听
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(myHandleTableviewCellLongPressed:)];
    longPress.minimumPressDuration = 1.0;
    //将长按手势添加到需要实现长按操作的视图里
    [self.collectionView addGestureRecognizer:longPress];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    
    UIImage *img =[UIImage imageNamed:@"书架界面背景"];
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:img];
    dateBase *db = [[dateBase alloc]init];
    self.bookArray = [[NSMutableArray alloc]init];
    self.bookArray = [db getBookListMassage];//获取书单信息，将他放到数组里
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *myDirectory = [documentsDirectory stringByAppendingPathComponent:@"bookName"];
    self.bookFiles = [fileManage subpathsAtPath: myDirectory ];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    
    //创建长按手势监听
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(myHandleTableviewCellLongPressed:)];
    longPress.minimumPressDuration = 1.0;
    //将长按手势添加到需要实现长按操作的视图里
    [self.collectionView addGestureRecognizer:longPress];
    
    [self.collectionView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)download
{
    
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
//    dateBase *db = [[dateBase alloc]init];
   
    BOOL b =[self isFileExisted:del.bookName];
    if (!b)
    {
        
        
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(40, 75, 200, 40)];
        view.backgroundColor = [UIColor grayColor];
        view.tag = 1002;
        [self.view addSubview:view];
        UIProgressView *pro = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 20, 140, 5)];
        [pro addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:nil];
        [view addSubview:pro];
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(145, 15, 50, 15)];
        lb.backgroundColor = [UIColor yellowColor];
        lb.tag = 1001;
        [view addSubview:lb];
        
        NSURL *url =[NSURL URLWithString:del.url1];
        NSURLRequest *req = [NSURLRequest requestWithURL:url];
        NSError *error;
        NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&error];
        NSString *path = [self getFilePath:del.bookName];
        
        NSString*bookstring;
        
        const NSStringEncoding *encodings = [NSString availableStringEncodings];
        NSStringEncoding encoding;
        int i = 0;
        while ((encoding = *encodings++) != 0)
        {
            i ++;
            if (i == 57)
            {
                bookstring = [[NSString alloc] initWithData:data encoding:encoding];
                break;
            }
            
        }
        NSData *data2= [bookstring dataUsingEncoding:NSUTF8StringEncoding];
        [data2 writeToFile:path atomically:YES];
    }
    

}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    NSNumber *num = [change objectForKey:@"new"];
    float number = num.floatValue * 100;
    UILabel *lb1 = (UILabel *)[self.view viewWithTag:1001];
    lb1.text = [NSString stringWithFormat:@"%2f%%",number];
    if (number == 100)
    {
        UIView *view2 = (UIView *)[self.view viewWithTag:1002];
        [view2 removeFromSuperview];
        
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.\
 kk
}
*/
//长按事件
-(void) myHandleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer
{
    
    
    CGPoint pointTouch = [gestureRecognizer locationInView:self.collectionView];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:pointTouch];
        if (indexPath == nil)
        {
            
        }
        else
        {
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除图书" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
                         {
                           [self deleteBookData:indexPath.row];
                         }];
            [alertView addAction:cancelAction];
            [alertView addAction:okAction];
            [self presentViewController:alertView animated:YES completion:nil];
            
        }
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
            }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        
    }
}
//删除事件
-(void)deleteBookData:(long)index
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    dateBase *db = [[dateBase alloc]init];

    NSString *booknamestr =[[self.bookArray objectAtIndex:index] bookName];
    [db deleteBokkName:booknamestr];
    NSString *pathstr =[self getFilePath:booknamestr];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([self isFileExisted:booknamestr] )
    {
        [fileManager removeItemAtPath:pathstr error:nil];
    }
    
    
    NSString *markName = [del.bookName substringFromIndex:9];
    NSString *markstr = [@"bookMarkArrayfile" stringByAppendingPathComponent:markName];
    NSString *markPath = [self getFilePath:markstr];
    if ([self isFileExisted:markstr] )
    {
       [fileManager removeItemAtPath:markPath error:nil];
    }
     [self.bookArray removeObjectAtIndex:index];
     [self.collectionView reloadData];
    
    
    
    
}
#pragma mark <UICollectionViewDataSource>
//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    del.bookName = [[self.bookArray objectAtIndex:indexPath.row] bookName];
    
    del.indexrow = (int)indexPath.row;
    ReadViewController *view = [[ReadViewController alloc]initWithNibName:@"ReadViewController" bundle:nil];
    [self presentViewController:view animated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//#warning Incomplete method implementation -- Return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//#warning Incomplete method implementation -- Return the number of items in the section
    return self.bookArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
      UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSString *str1 = [[self.bookArray objectAtIndex:indexPath.row] bookImg];
  
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *str = [array objectAtIndex:0];
   
    NSString *path = [str stringByAppendingPathComponent:str1];
    NSLog(@"path = %@",path);

    UIImage *ima = [[UIImage alloc]initWithContentsOfFile:path];
    cell.backgroundView = [[UIImageView alloc]initWithImage:ima];
    
    // Configure the cell
    
    return cell;
}
//cell大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(70, 90);
}
//cell的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 45;
}
//cell的上左右间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(50, 20, 40, 20);
}
//获取沙盒路径
- (NSString *)getFilePath:(NSString *)fileName{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[array objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
    return path;
}
//判断文件是否存在
-(BOOL)isFileExisted:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:[self getFilePath:fileName]])
    {
        return NO;
    }
    
    
    return YES;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
