//
//  DebriefViewController.h
//  PLIC-iOS
//
//  Created by Leo on 10/23/12.
//
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface DebriefViewController : UIViewController
{
    User *user;
}

@property (strong, nonatomic) User *user;
@property (strong, nonatomic) IBOutlet UILabel *qteWarrior;
@property (strong, nonatomic) IBOutlet UILabel *qteKnight;
@property (strong, nonatomic) IBOutlet UILabel *qteBommerang;
@property (strong, nonatomic) IBOutlet UILabel *lifeWarrior;
@property (strong, nonatomic) IBOutlet UILabel *lifeKnight;
@property (strong, nonatomic) IBOutlet UILabel *lifeBoomerang;

@end
