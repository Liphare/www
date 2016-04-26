//
//  dateBase.m
//  p2.22
//
//  Created by 王开政 on 16/2/22.
//  Copyright (c) 2016年 Wang. All rights reserved.
//

#import "dateBase.h"

@implementation dateBase
//获取数据库路径
-(NSString *)getpath
{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [array objectAtIndex:0];
    dbPath = [path stringByAppendingPathComponent:@"db"];
    return dbPath;
    
}
//创建数据库
-(void)createDB
{
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:[self getpath]])
    {
        NSLog(@"db exist");
    }
    else
    {
        if (sqlite3_open([[self getpath] UTF8String], &db) ==SQLITE_OK)
        {
            NSLog(@"success to open");
        }
        else
        {
            NSLog(@"fail to open");
        }
        sqlite3_close(db);
    }
}
//创建表
-(BOOL)checkName:(NSString *)name{
    
    char *err;
    
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM sqlite_master where type='table' and name='%@';",name];
    
    const char *sql_stmt = [sql UTF8String];
    
    if(sqlite3_exec(db, sql_stmt, NULL, NULL, &err) == 1)
    {
        
        return YES;
        
    }
    else
    {
        
        return NO;
        
    }
    
}
//创建一个书单表 ，用于存放书类信息
-(void)createBookList
{
    if (sqlite3_open([[self getpath] UTF8String], &db) ==SQLITE_OK)
    {
        NSString *table = [NSString stringWithFormat:@"create table bookList(bookName text, bookImg text,bookMark text)"];
        if (sqlite3_exec(db, [table UTF8String], nil, nil, nil) ==SQLITE_OK)
        {
            NSLog(@"success to create");
        }
        else
        {
            NSLog(@"fail to create");
        }
        sqlite3_close(db);
    }
    else
    {
        NSLog(@"fail to open");
    }

}
//添加书单信息；
-(void)insertInformationToBookList:(NSString *)bookName andbookImg:(NSString *)bookImg andbookMark:(NSString *)bookMark
{
    if (sqlite3_open([[self getpath] UTF8String], &db) == SQLITE_OK)
    {
        sqlite3_stmt *stm;
        NSString *insert = [NSString stringWithFormat:@"insert into bookList(bookName,bookImg,bookMark) values(\"%@\",\"%@\",\"%@\")",bookName,bookImg,bookMark];
        sqlite3_prepare_v2(db, [insert UTF8String], -1,
                           &stm, nil);
        if (sqlite3_step(stm) == SQLITE_DONE)
            
        {
            NSLog(@"success to insert");
        }
        else
        {
            NSLog(@"fail to insert");
        }
        sqlite3_finalize(stm);
        sqlite3_close(db);
    }
    else
    {
        NSLog(@"fail to open");
    }


}
//获取书单信息
-(NSMutableArray *)getBookListMassage
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    if (sqlite3_open([[self getpath] UTF8String], &db) == SQLITE_OK)
    {
        sqlite3_stmt *stm;
        NSString *select = [NSString stringWithFormat:@"select * from bookList"];
        sqlite3_prepare_v2(db, [select UTF8String], -1, &stm, nil);
        while (sqlite3_step(stm) ==SQLITE_ROW)
        {
            Informaton *info = [[Informaton alloc]init];
            NSString *name1 = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(stm, 0)];
            NSString *name2 = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(stm, 1)];
            NSString *name3 = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(stm, 2)];
            info.bookName = name1;
            info.bookImg = name2;
            info.bookMark = name3;
            [array addObject:info];
        }
        sqlite3_finalize(stm);
        sqlite3_close(db);
    }
    return array;
}

-(void)createTable:(NSString *)tableName
{
    if (sqlite3_open([[self getpath] UTF8String], &db) ==SQLITE_OK)
    {
        NSString *table = [NSString stringWithFormat:@"create table %@(name text, pwd text,photo text)",tableName];
        if (sqlite3_exec(db, [table UTF8String], nil, nil, nil) ==SQLITE_OK)
        {
            NSLog(@"success to create");
        }
        else
        {
            NSLog(@"fail to create");
        }
       sqlite3_close(db);
    }
        else
    {
        NSLog(@"fail to open");
    }
}
//插入数据
-(void)insertInformation:(NSString *)tablename andName:(NSString *)name andPwd: (NSString *)pwd withPhotoName: (NSString *)photoname
{
    if (sqlite3_open([[self getpath] UTF8String], &db) == SQLITE_OK)
    {
        sqlite3_stmt *stm;
        NSString *insert = [NSString stringWithFormat:@"insert into %@(name,pwd,photo) values(\"%@\",\"%@\",\"%@\")",tablename,name,pwd,photoname];
        sqlite3_prepare_v2(db, [insert UTF8String], -1,
                           &stm, nil);
        if (sqlite3_step(stm) == SQLITE_DONE)
        
        {
            NSLog(@"success to insert");
        }
        else
        {
         NSLog(@"fail to insert");
        }
        sqlite3_finalize(stm);
        sqlite3_close(db);
    }
    else
    {
      NSLog(@"fail to open");
    }
}
//获取数据
-(NSMutableArray *)getMassage:(NSString *)tablename
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    if (sqlite3_open([[self getpath] UTF8String], &db) == SQLITE_OK)
    {
        sqlite3_stmt *stm;
        NSString *select = [NSString stringWithFormat:@"select * from %@",tablename];
        sqlite3_prepare_v2(db, [select UTF8String], -1, &stm, nil);
        while (sqlite3_step(stm) ==SQLITE_ROW)
        {
            Informaton *info = [[Informaton alloc]init];
            NSString *name1 = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(stm, 0)];
            NSString *name2 = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(stm, 1)];
            NSString *name3 = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(stm, 2)];
            info.name = name1;
            info.pwd = name2;
            info.photo = name3;
            [array addObject:info];
        }
        sqlite3_finalize(stm);
        sqlite3_close(db);
    }
    return array;
}
//删除数据
-(void)deleteInformation:(NSString *)name and:(NSString *)tablename

{
    if (sqlite3_open([[self getpath] UTF8String], &db)==SQLITE_OK)
    {
        sqlite3_stmt *stm;
        NSString *delete =  [NSString stringWithFormat:@"delete from %@ where name = \"%@\"",tablename,name];
        sqlite3_prepare_v2(db, [delete UTF8String], -1, &stm, nil);
        if (sqlite3_step(stm) ==SQLITE_DONE)
        {
            NSLog(@"success to delete");
        }
        else
        {
        NSLog(@"fail to delete");
        }
        sqlite3_finalize(stm);
        sqlite3_close(db);
    }
    else
    {
        NSLog(@"fail to open");
    }
  
}
//删除书单信息
-(void)deleteBokkName:(NSString *)bookName

{
    if (sqlite3_open([[self getpath] UTF8String], &db)==SQLITE_OK)
    {
        sqlite3_stmt *stm;
        NSString *delete =  [NSString stringWithFormat:@"delete from bookList where bookName = \"%@\"",bookName];
        sqlite3_prepare_v2(db, [delete UTF8String], -1, &stm, nil);
        if (sqlite3_step(stm) ==SQLITE_DONE)
        {
            NSLog(@"success to delete");
        }
        else
        {
            NSLog(@"fail to delete");
        }
        sqlite3_finalize(stm);
        sqlite3_close(db);
    }
    else
    {
        NSLog(@"fail to open");
    }
    
}

//修改书单书签值
-(void)updatebookList:(NSString *)bookName andbookMark:(NSString *)bookMark
{
    if (sqlite3_open([[self getpath] UTF8String], &db)==SQLITE_OK)
    {
        sqlite3_stmt *stm;
        NSString *update = [NSString stringWithFormat:@"update bookList set bookMark = \"%@\" where bookName = \"%@\"",bookMark,bookName];
        sqlite3_prepare_v2(db, [update UTF8String], -1, &stm, nil);
        if (sqlite3_step(stm) == SQLITE_DONE)
        {
            NSLog(@"success to update");
        }
        else
        {
            NSLog(@"fail to update");
        }
        sqlite3_finalize(stm);
        sqlite3_close(db);
    }
    else
    {
        NSLog(@"fail   to open");
    }
    
}

//
-(void)updatePwd:(NSString *)pwd ForName:(NSString *)name
{
    if (sqlite3_open([[self getpath] UTF8String], &db)==SQLITE_OK)
    {
        sqlite3_stmt *stm;
        NSString *update = [NSString stringWithFormat:@"update person set pwd = \"%@\" where name = \"%@\"",pwd,name];
        sqlite3_prepare_v2(db, [update UTF8String], -1, &stm, nil);
        if (sqlite3_step(stm) == SQLITE_DONE)
        {
            NSLog(@"success to update");
        }
        else
        {
            NSLog(@"fail to update");
        }
        sqlite3_finalize(stm);
        sqlite3_close(db);
    }
    else
    {
        NSLog(@"fail   to open");
    }

}
-(void)updatePhoto:(NSString *)photo ForName:(NSString *)name
{
    if (sqlite3_open([[self getpath] UTF8String], &db)==SQLITE_OK)
    {
        sqlite3_stmt *stm;
        NSString *update = [NSString stringWithFormat:@"update person set photo = \"%@\" where name = \"%@\"",photo,name];
        sqlite3_prepare_v2(db, [update UTF8String], -1, &stm, nil);
        if (sqlite3_step(stm) == SQLITE_DONE)
        {
            NSLog(@"success to update");
        }
        else
        {
            NSLog(@"fail to update");
        }
        sqlite3_finalize(stm);
        sqlite3_close(db);
    }
    else
    {
        NSLog(@"fail   to open");
    }
    
}

@end
