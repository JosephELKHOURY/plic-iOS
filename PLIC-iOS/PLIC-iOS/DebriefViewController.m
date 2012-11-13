//
//  DebriefViewController.m
//  PLIC-iOS
//
//  Created by Leo on 10/23/12.
//
//

#import "DebriefViewController.h"

@interface DebriefViewController ()

@end

@implementation DebriefViewController
@synthesize user;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.qteWarrior.text = [NSString stringWithFormat:@"Qté:%d", user.Warrior];
    self.qteKnight.text = [NSString stringWithFormat:@"Qté:%d", user.Knight];
    self.qteBommerang.text = [NSString stringWithFormat:@"Qté:%d", user.Boomerang];
    self.lifeWarrior.text = [NSString stringWithFormat:@"Vie moyenne:%.01f/20", user.warriorAvgLife];
    self.lifeKnight.text = [NSString stringWithFormat:@"Vie moyenne:%.01f/16", user.knightAvgLife];
    self.lifeBoomerang.text = [NSString stringWithFormat:@"Vie moyenne:%.01f/10", user.boomerangAvgLife];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setQteWarrior:nil];
    [self setQteKnight:nil];
    [self setQteBommerang:nil];
    [self setLifeWarrior:nil];
    [self setLifeKnight:nil];
    [self setLifeBoomerang:nil];
    [super viewDidUnload];
}
@end
