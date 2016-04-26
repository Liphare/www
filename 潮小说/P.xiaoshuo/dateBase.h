//
//  dateBase.h
//  p2.22
//
//  Created by 王开政 on 16/2/22.
//  Copyright (c) 2016年 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Informaton.h"
@interface dateBase : NSObject
{
    sqlite3 *db;
    NSString *dbPath;
}
-(NSString *)getpath;
-(void)createDB;
-(void)createTable:(NSString *)tableName;
-(void)insertInformation:(NSString *)tablename andName:(NSString *)name andPwd: (NSString *)pwd withPhotoName: (NSString *)photoname;
-(NSMutableArray *)getMassage:(NSString *)tablename;
-(void)deleteInformation:(NSString *)name and:(NSString *)tablename;
-(void)updatePhoto:(NSString *)photo ForName:(NSString *)name;
-(void)updatePwd:(NSString *)pwd ForName:(NSString *)name;
-(BOOL)checkName:(NSString *)name;
-(void)createBookList;
-(void)insertInformationToBookList:(NSString *)bookName andbookImg:(NSString *)bookImg andbookMark:(NSString *)bookMark;
-(NSMutableArray *)getBookListMassage;
-(void)updatebookList:(NSString *)bookName andbookMark:(NSString *)bookMark;
-(void)deleteBokkName:(NSString *)bookName;
@end
