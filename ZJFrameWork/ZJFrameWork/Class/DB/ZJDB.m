//
//  ZJDB.m
//  waimai
//
//  Created by DL on 14/11/18.
//
//

#import "ZJDB.h"
#import "sqlite3.h"
#import "FMDatabase.h"

#define DATA_FILE @"waimai.db"

#define overdueTime  180
@interface ZJDB ()
@property(nonatomic,strong)NSString *dbFile;
@property(nonatomic,assign)sqlite3 *dataDB;
@property(nonatomic,strong) FMDatabase *db;
@end
static ZJDB *zjdb;

@implementation ZJDB
@synthesize dataDB;
+(ZJDB*)db
{
    if (!zjdb) {
        zjdb = [[ZJDB alloc] init];
        
    }
    return zjdb;
}
- (BOOL)copyMissingFile:(NSString *)sourcePath toPath:(NSString *)toPath
{
    BOOL retVal = YES; // If the file already exists, we'll return success…
    NSString * finalLocation = [toPath stringByAppendingPathComponent:[sourcePath lastPathComponent]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:finalLocation])
    {
        retVal = [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:finalLocation error:NULL];
    }
    return retVal;
}
- (void)createFolder:(NSString *)createDir
{
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:createDir isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:createDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

-(NSString *)dataFilePath {
    if (self.dbFile) {
        return self.dbFile;
    }
    NSArray * myPaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
    NSString * myDocPath = [myPaths objectAtIndex:0];
    NSString *myDBfileGroup = [myDocPath stringByAppendingString:@"/Caches"];
    [self createFolder:myDBfileGroup];
    
    NSString *filename = [myDBfileGroup stringByAppendingFormat:@"/%@",DATA_FILE];
    self.dbFile = filename;
    return self.dbFile;
}
-(BOOL)openDB
{
    _db = [FMDatabase databaseWithPath:[self dataFilePath]] ;
    if (![_db open]) {
                
        return NO;
    }else
    {
        return YES;
    }
}
//删除数据库
- (void)deleteDatabse
{
    BOOL success;
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // delete the old db.
    if ([fileManager fileExistsAtPath:[self dataFilePath]])
    {
        [_db close];
        success = [fileManager removeItemAtPath:[self dataFilePath] error:&error];
        if (!success) {
            NSAssert1(0, @"Failed to delete old database file with message '%@'.", [error localizedDescription]);
        }
    }
}
-(BOOL)close
{
    return [_db close];
}

-(BOOL)createShopConfigure
{
    return YES;
}
@end
