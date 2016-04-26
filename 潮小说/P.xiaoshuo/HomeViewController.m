//
//  HomeViewController.m
//  P.xiaoshuo
//
//  Created by 王开政 on 16/3/1.
//  Copyright (c) 2016年 Wang. All rights reserved.
//

#import "HomeViewController.h"
#import "ReadViewController.h"
#import "dateBase.h"
#import "BookCollectionViewController.h"
#import "AppDelegate.h"

#import "RefreshView.h"
#define ip @"http://121.42.156.160/massage.php"

@interface HomeViewController ()<UIScrollViewDelegate>

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication ]delegate];
    if (del.networkSign == NO)
    {
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前网络不可用，请转到本地阅读" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
                                   {
                                       self.tabBarController.selectedIndex = 1;
                                   }];
        
        [alertView addAction:okAction];
        [self presentViewController:alertView animated:YES completion:nil];
        return;

    }
    self.bookimgdic = [[NSMutableDictionary alloc]init];
    self.buttondic = [[NSMutableDictionary alloc]init];
    self.bookloadarray = [[NSMutableArray alloc]init];
    self.bookimgloadarray = [[NSMutableArray alloc]init];
    [self homepage];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}
-(void)homepage
{
    NSURL *url =[NSURL URLWithString:ip];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&error];
    if (error)
    {
        NSLog(@"错误： %@", error.localizedDescription);
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    
    self.typeArray = [dic allKeys];
    
    NSURL *typeurl =[NSURL URLWithString:@"http://121.42.156.160/typeName.php"];
    NSURLRequest *typereq = [NSURLRequest requestWithURL:typeurl];
    
    NSData *typedata = [NSURLConnection sendSynchronousRequest:typereq returningResponse:nil error:&error];
    NSDictionary *typeDic = [NSJSONSerialization JSONObjectWithData:typedata options:NSJSONReadingMutableLeaves error:nil];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height)];
    
    [self.view addSubview:self.scrollView];
    self.scrollView.delegate = self;
    
    self.refreshView = [[RefreshView alloc]init];
    NSArray *nils = [[NSBundle mainBundle]loadNibNamed:@"Empty" owner:self options:nil];
    self.refreshView =[nils objectAtIndex:0];
    self.refreshView.frame = CGRectMake(0, -50, self.scrollView.frame.size.width, 50);
    self.refreshView.alpha = 0;
    
    [self.scrollView addSubview:self.refreshView];
    
//    self.title =@"首页";
    
    
    
    for (int i = 0; i < dic.count; i ++)
    {
        
        UIButton *midTopBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0 +i*190, self.scrollView.frame.size.width, 40)];
        UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40 +i *190, self.view.frame.size.width , 150)];
        
        
        UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(single:)];
        singleRecognizer.numberOfTapsRequired = 1;
        [scroll addGestureRecognizer:singleRecognizer];
        midTopBtn.tag = i +1;
        scroll.tag = i +1;
        NSArray *arr = [self getImages];//获取图书分类 信息
        NSArray *arr1 = [arr objectAtIndex:i];
        NSString *fileStr1 = [self.typeArray objectAtIndex:i];
        NSString *fileStr2 = [@"bookImg/" stringByAppendingString:fileStr1];
        NSString *markfileStr3 = [@"bookMarkArrayfile" stringByAppendingPathComponent:fileStr1];
        BOOL e = [self isFileExisted:fileStr2];
        BOOL ex = [self isFileExisted:markfileStr3];//创建纪录分页的文件夹
        if (!ex)
        {
            NSLog(@"eeeeeeeeeeeeeeeeeeeee");
            [self createDirectoryAtPath:markfileStr3];
        }
        
        if (!e)
        {
            [self createDirectoryAtPath:fileStr2];//创建图书分类图片文件夹
        }
        
        
        for (int j = 0; j < arr1.count; j ++)
        {
            int k = j / 3;
            int n = j % 3;
            
            self.btn = [[UIButton alloc]initWithFrame:CGRectMake(30 + n*90 , 20+k *100, 60, 80)];
            [scroll addSubview:self.btn];
            
            self.btn.tag = [NSString stringWithFormat:@"%d%d",i+1,j].intValue;
//            NSLog(@"%ld",(long)self.btn.tag);
            scroll.contentSize = CGSizeMake(self.view.frame.size.width, 100 * (arr1.count / 3 + 1) );
            NSString *urlStr = [NSString stringWithFormat:@"/%@",[self.typeArray objectAtIndex:i]];
            NSString *urlStr1 = [NSString stringWithFormat:@"/%d.png",j+1];
            NSString *urlStr3 = [[self getFilePath:fileStr2] stringByAppendingString:urlStr1];
//            NSLog(@"3333==%@",urlStr3);
            BOOL a = [self isFileExisted:urlStr1];
            if (a)
            {
                //如果本地有文件 ，  从本地获取；
                NSData *imgdata = [NSData dataWithContentsOfFile:urlStr3];
                UIImage *img = [UIImage imageWithData:imgdata];
                [self.btn setBackgroundImage:img forState:UIControlStateNormal];
            }
            else//如果没有，从服务器下载并保
            {
                NSString *urlStr2 = [urlStr stringByAppendingString:urlStr1];
                NSString *url1 = [@"http://121.42.156.160/bookImg"stringByAppendingString:urlStr2];
                NSURL *url =[NSURL URLWithString:url1];
             NSURLRequest *req = [NSURLRequest requestWithURL:url];
                [self.buttondic setObject:self.btn forKey:url];
                NSLog(@"bbbbbb=%lu",(unsigned long)self.buttondic.count);
//            NSError *error;
            NSOperationQueue *queue=[NSOperationQueue mainQueue];
            [NSURLConnection sendAsynchronousRequest:req queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
                {
                    self.img = [UIImage imageWithData:data];
//                    NSLog(@"%@",response.suggestedFilename);
//                    NSString *url1 = url substringFromIndex:<#(NSUInteger)#>
                    [self.bookimgdic setObject:self.img forKey:response.URL];
                    UIButton *button = (UIButton *)[self.buttondic objectForKey:response.URL];
                    [ button setBackgroundImage:self.img forState:UIControlStateNormal];
                    NSLog(@"%lu",(unsigned long)self.bookimgdic.count);
                     NSLog(@"--block回调数据--%@---%lu", [NSThread currentThread],(unsigned long)data.length);
                    [data writeToFile:urlStr3 atomically:YES];//保存
                   
                }];
//                [self.bookimgdic setObject:self.img forKey:[NSString stringWithFormat:@"%ld",(long)self.btn.tag]];
                 NSLog(@"%@",[self.bookimgdic allKeys]);
            [self.btn setBackgroundImage:self.img forState:UIControlStateNormal];
//            UIImage *img = [UIImage imageWithData:imgdata];
//            [self.btn setBackgroundImage:img forState:UIControlStateNormal];
            
//                NSURLRequest *req = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:15];
            
//                self.con = [[NSURLConnection alloc]initWithRequest:req delegate:self];
            
                

            }
            [self.btn addTarget:self action:@selector(download:)forControlEvents:UIControlEventTouchUpInside];//包装点击下载
           
            scroll.showsVerticalScrollIndicator = NO;
        }
        
        
        
        midTopBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:202/255.0 blue:114/255.0 alpha:0.8];
        [midTopBtn setTitle:[typeDic objectForKey:[self.typeArray objectAtIndex:i]] forState:UIControlStateNormal];
        scroll.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"首页界面背景.jpg"]];
        [self.scrollView addSubview:midTopBtn];
        [self.scrollView addSubview:scroll];
    }
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 60 + dic.count * 190);
    self.scrollView.showsVerticalScrollIndicator = NO;

}
//点击事件
-(void)single:(UITapGestureRecognizer *)gesture 
{
    NSLog(@"单击");
}
//用到的4个代理方法
//初始化receiveData，用于存放服务器给的数据
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (connection == self.con)
    {
         self.mutImageData = [[NSMutableData alloc]init];
    }
    else if (connection == self.bookcon1)
    {
        self.mutbookData1 = [[NSMutableData alloc]init];
        self.sumLength1=response.expectedContentLength;
        NSLog(@"111111");
    }
    else if (connection == self.bookcon2)
    {
        self.mutbookData2 = [[NSMutableData alloc]init];
        self.sumLength2=response.expectedContentLength;
        NSLog(@"22222");

    }

}
//接收到服务器传输数据的时候调用，此方法根据数据大小会执行若干次
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection == self.con)
    {
    [self.mutImageData appendData:data];
    }
    else if (connection == self.bookcon1)
    {
        
        self.currentLength1+=data.length;
       
        //计算当前进度(转换为double型的)
    double progress1=(double)self.currentLength1/self.sumLength1;
    self.progress1.progress=progress1;
        self.progress1.progressTintColor = [UIColor redColor];
           //一点一点接收数据。
//        NSLog(@"接收到服务器的数据！---%lu",(unsigned long)data.length);
//        NSLog(@"didReceiveData--%f",progress1);
        [self.mutbookData1 appendData:data];
    }
    else if (connection == self.bookcon2)
    {
        
        self.currentLength2+=data.length;
        
        //计算当前进度(转换为double型的)
        double progress2=(double)self.currentLength2/self.sumLength2;
        self.progress2.progress=progress2;
        self.progress2.progressTintColor = [UIColor redColor];
        //一点一点接收数据。
//        NSLog(@"接收到服务器的数据！---%lu",(unsigned long)data.length);
//        NSLog(@"didReceiveData--%f",progress2);
        [self.mutbookData2 appendData:data];
    }


}
//数据传完之后调用此方法
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    dateBase *db = [[dateBase alloc]init];
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
   
    NSLog(@"current thread = %@",[NSThread currentThread]);
//    UIImage *ima = [[UIImage alloc]initWithData:self.mutImageData];
    if (connection == self.con)
    {
//       NSString *url = connection.currentRequest.URL.absoluteString;
//        NSLog(@"%@",url);
       self.img = [UIImage imageWithData:self.mutImageData];
    }
    else if (connection == self.bookcon1)
    {
                NSString *path1 = [self getFilePath:self.bookma1];
        const NSStringEncoding *encodings = [NSString availableStringEncodings];
        NSStringEncoding encoding;
        int i = 0;
        while ((encoding = *encodings++) != 0)
        {
            i ++;
            if (i == 57)
            {
               self.bookstring = [[NSString alloc] initWithData:self.mutbookData1 encoding:encoding];
                break;
            }
            
        }
        NSData *data1= [self.bookstring dataUsingEncoding:NSUTF8StringEncoding];
        [data1 writeToFile:path1 atomically:YES];

        self.currentLength1 = 0;
        self.progress1.progress = 0;
        [self.progress1 removeFromSuperview];
        
        [db insertInformationToBookList:self.bookma1 andbookImg:self.bookim1 andbookMark:@"0"];//将书名 图片添加到表中
        [self.bookloadarray removeObject:self.bookma1];
        [self.bookimgloadarray removeObject:self.bookim1];
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"下载已完成" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertView addAction:cancelAction];
        [self presentViewController:alertView animated:YES completion:nil];
        self.bookcon1 = nil;
    }
    else if (connection == self.bookcon2)
    {
        NSString *path2 = [self getFilePath:self.bookma2];
        const NSStringEncoding *encodings = [NSString availableStringEncodings];
        NSStringEncoding encoding;
        int i = 0;
        while ((encoding = *encodings++) != 0)
        {
            i ++;
            if (i == 57)
            {
                self.bookstring = [[NSString alloc] initWithData:self.mutbookData2 encoding:encoding];
                break;
            }
            
        }
        NSData *data2= [self.bookstring dataUsingEncoding:NSUTF8StringEncoding];
        [data2 writeToFile:path2 atomically:YES];
        
        self.currentLength2 = 0;
        self.progress2.progress = 0;
        
        [db insertInformationToBookList:self.bookma2 andbookImg:self.bookim2 andbookMark:@"0"];//将书名 图片添加到表中

        [self.progress2 removeFromSuperview];
        [self.bookloadarray removeObject:self.bookma2];
        [self.bookimgloadarray removeObject:self.bookim2];
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"下载已完成" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertView addAction:cancelAction];
        [self presentViewController:alertView animated:YES completion:nil];
        self.bookcon2 = nil;
    }

    

}
//网络请求过程中，出现任何错误，如断网，连接超时等，会进入此方法
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    NSLog(@"net error!");
}
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
//}

// 刚拖动的时候

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    NSLog(@"kkkk");
    
    [self.refreshView isScrollViewStartDragging:self.scrollView];
}
// 拖动过程中
- (void)scrollViewDidScroll:(UIScrollView *)scrollView_
{
//    NSLog(@"zzzzz");
    
    [self.refreshView isScrollViewDragging:self.scrollView];
}
// 拖动结束后
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView_ willDecelerate:(BOOL)decelerate
{
//     NSLog(@"jjjj");
    self.refreshView.alpha = 1;
    self.scrollView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
    [self.refreshView isScrollViewEndDragging:self.scrollView];
    
}

-(NSArray *)getImages
{
    NSURL *url =[NSURL URLWithString:@"http://121.42.156.160/bookneirong.php"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&error];
     NSArray *bookarray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    return bookarray;
 }
//点击书下载
-(void)download:(UIButton *)sender
{
    
    
   AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *str1 = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    NSString *str2 = [str1 substringToIndex:1];
    NSString *str3 = [str1 substringFromIndex:1];
    NSString *urlStr = [NSString stringWithFormat:@"/%@",[self.typeArray objectAtIndex:str2.intValue -1]];
    NSString *urlStr1 = [NSString stringWithFormat:@"/%d.txt",str3.intValue+1];
    NSString *bookImgStr = [NSString stringWithFormat:@"/%d.png",str3.intValue+1];
    NSString *bookImgStr1 = [urlStr stringByAppendingString:bookImgStr];
    NSString *urlStr2 = [urlStr stringByAppendingString:urlStr1];
    NSString *urlStr3 =[@"/bookName" stringByAppendingString:urlStr];
    [self createDirectoryAtPath:urlStr3];
    del.url1 = [@"http://121.42.156.160/bookName"stringByAppendingString:urlStr2];
    
    del.bookName =[urlStr3 stringByAppendingString:urlStr1];
    self.bookImg = [@"/bookImg" stringByAppendingString:bookImgStr1];//图片信息记录下
    [self.bookimgloadarray addObject:self.bookImg];
    dateBase *db = [[dateBase alloc]init];
    [db createBookList];//创建书单表；
    NSMutableArray *bookArray = [[NSMutableArray alloc]initWithArray:[db getBookListMassage]];
    
    
    int sign = 0;
    for (int i = 0; i < bookArray.count; i ++)
    {
        //如果书存在  就不添加  不存在 就添加
        if ([del.bookName isEqualToString:[[bookArray objectAtIndex:i] bookName]])
        {
            sign ++;
        }
        
    }
    
    
    
    BOOL b =[self isFileExisted:del.bookName];
    if (!b)
    {
        
        
       
        
        [self.bookloadarray addObject:del.bookName];
        if (self.bookloadarray.count ==3)
        {
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"队列已满，请等待下载完成" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alertView addAction:cancelAction];
            [self presentViewController:alertView animated:YES completion:nil] ;
            [self.bookloadarray removeObjectAtIndex:2];
            [self.bookimgloadarray removeObjectAtIndex:2];
            return;
        }
        NSLog(@"%@",del.bookName);
        NSLog(@"qqqqqqqq===%lu",(unsigned long)self.bookloadarray.count);
        NSURL *url =[NSURL URLWithString:del.url1];
        NSURLRequest *req = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:15];
//        NSError *error;
        if (self.bookcon1 ==nil)
        {
            
            self.bookma1 =[self.bookloadarray objectAtIndex:0];
            self.bookim1 = [self.bookimgloadarray objectAtIndex:0];
            self.progress1 =[[UIProgressView alloc]initWithFrame:CGRectMake(0, sender.frame.size.height - 2, sender.frame.size.width, 20)];
            self.progress1.progressViewStyle = UIProgressViewStyleBar ;
            [sender addSubview:self.progress1];
            self.bookcon1 = [[NSURLConnection alloc]initWithRequest:req delegate:self];
            return;
        }
        else if (self.bookcon2 ==nil);
            
        {
            
            self.bookma2 =[self.bookloadarray objectAtIndex:1];
            self.bookim2 = [self.bookimgloadarray objectAtIndex:1];
            self.progress2 =[[UIProgressView alloc]initWithFrame:CGRectMake(0, sender.frame.size.height - 2, sender.frame.size.width, 20)];
            self.progress2.progressViewStyle = UIProgressViewStyleBar ;
            [sender addSubview:self.progress2];

          self.bookcon2 = [[NSURLConnection alloc]initWithRequest:req delegate:self];
        }
        
        
    }
    

//    self.tabBarController.selectedIndex = 1;
}

/*文件是否存在*/

-(BOOL)isFileExisted:(NSString *)fileName{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:[self getFilePath:fileName]])
    {
        return NO;
    }
    
    return YES;
}

/*创建指定名字的文件    文本*/
- (BOOL)createFileAtPath:(NSString *)fileName{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[array objectAtIndex:0] stringByAppendingPathComponent:fileName];
    NSLog(@"-----%@:", path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:path]){
        [fileManager createFileAtPath:path contents:nil attributes:nil];
        return YES;
    }
    
    return NO;
}
//创建文件夹
- (BOOL)createDirectoryAtPath:(NSString *)fileName{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[array objectAtIndex:0] stringByAppendingPathComponent:fileName];
    NSLog(@"-----%@:", path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:path]){
        NSError *error = nil;
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        return YES;
    }
    
    return NO;
}
//取路径
- (NSString *)getFilePath:(NSString *)fileName{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[array objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
    return path;
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
