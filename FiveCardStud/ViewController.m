//
//  ViewController.m
//  FiveCardStud
//
//  Created by Brian Olencki on 12/30/15.
//  Copyright © 2015 bolencki13. All rights reserved.
//

#import "ViewController.h"
#import "FlatButton.h"
#import "TriangleView.h"
#import "PokerHandChecker.h"

#define SCREEN ([UIScreen mainScreen].bounds)

@interface ViewController () {
    FlatButton *btnMain, *btnBidAdd, *btnBidMinus;
    
    NSInteger money, bet;
    NSArray *aryCards;
    NSMutableArray *aryCardsBeingUsed;
    
    UIView *viewMoney;
    UILabel *lblMoney, *lblBet, *lblInstructions;
    
    NSUserDefaults *prefs;
    
    BOOL gameHasStarted;
}
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkCards) name:@"checkCards" object:nil];
    
    gameHasStarted = NO;
    
    prefs = [NSUserDefaults standardUserDefaults];
    [prefs registerDefaults:@{
                              @"money" : @100
                              }];
    money = [prefs integerForKey:@"money"];
    [self loadCards];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 100)];
    lblTitle.font = [UIFont systemFontOfSize:32];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.text = @"FIVE CARD DRAW";
    lblTitle.tag = 7;
    lblTitle.textColor = [UIColor whiteColor];
    [self.view addSubview:lblTitle];
    
    btnMain = [FlatButton buttonWithType:UIButtonTypeCustom];
    [btnMain addTarget:self action:@selector(mainButton) forControlEvents:UIControlEventTouchUpInside];
    [btnMain setFrame:CGRectMake(5, SCREEN.size.height-105, SCREEN.size.width-10, 100)];
    [btnMain setTitle:@"START" forState:UIControlStateNormal];
    [btnMain setBackgroundColor:[UIColor flat:WaxFlower]];
    btnMain.layer.cornerRadius = [FlatButton cornerRadius];
    btnMain.titleLabel.font = [UIFont systemFontOfSize:32];
    [self.view addSubview:btnMain];
    
    NSInteger height = SCREEN.size.height/3;
    if (height > 250) {
        height = 250;
    }
    for (int x = 0; x < 5; x++) {
        UIView *viewContainer = [[UIView alloc] initWithFrame:CGRectMake((5*(x+1))+((SCREEN.size.width-30)/5*x), 0, (SCREEN.size.width-30)/5, height)];
        viewContainer.center = CGPointMake(viewContainer.center.x, SCREEN.size.height/2);
        [self.view addSubview:viewContainer];

        FlatButton *btnCard = [FlatButton buttonWithType:UIButtonTypeCustom];
        [btnCard addTarget:self action:@selector(cardButton:) forControlEvents:UIControlEventTouchUpInside];
        [btnCard setFrame:CGRectMake(0, 0, (SCREEN.size.width-30)/5, height)];
        [btnCard setTitle:@"" forState:UIControlStateNormal];
        [btnCard setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnCard setBackgroundColor:[UIColor flat:WhiteSmoke]];
        btnCard.layer.cornerRadius = [FlatButton cornerRadius];
        btnCard.tag = 10+x;
        switch (x) {
            case 0:
                [self setCard:btnCard withType:@"clubs-10"];
                break;
            case 1:
                [self setCard:btnCard withType:@"clubs-J"];
                break;
            case 2:
                [self setCard:btnCard withType:@"clubs-Q"];
                break;
            case 3:
                [self setCard:btnCard withType:@"clubs-K"];
                break;
            case 4:
                [self setCard:btnCard withType:@"clubs-A"];
                break;
                
            default:
                break;
        }
        [viewContainer addSubview:btnCard];
    }
    
    viewMoney = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 200)];
    viewMoney.backgroundColor = [UIColor clearColor];
    viewMoney.hidden = YES;
    [self.view addSubview:viewMoney];
    
    bet = 5;
    lblBet = [[UILabel alloc] initWithFrame:CGRectMake(0, 77.5, SCREEN.size.width, 75)];
    lblBet.text = [NSString stringWithFormat:@"%i",(int)bet];
    lblBet.textAlignment = NSTextAlignmentCenter;
    lblBet.font = [UIFont systemFontOfSize:32];
    lblBet.userInteractionEnabled = NO;
    lblBet.textColor = [UIColor flat:WhiteSmoke];
    [viewMoney addSubview:lblBet];
    
    lblMoney = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, SCREEN.size.width, 50)];
    lblMoney.text = [NSString stringWithFormat:@"%i",(int)money];
    lblMoney.textAlignment = NSTextAlignmentCenter;
    lblMoney.textColor = [UIColor flat:WhiteSmoke];
    lblMoney.font = [UIFont systemFontOfSize:32];
    lblMoney.userInteractionEnabled = NO;
    [viewMoney addSubview:lblMoney];
    
    btnBidMinus = [FlatButton buttonWithType:UIButtonTypeCustom];
    [btnBidMinus addTarget:self action:@selector(bidButton:) forControlEvents:UIControlEventTouchUpInside];
    [btnBidMinus setFrame:CGRectMake(50, 75, 75, 75)];
    [btnBidMinus setTitle:@"-" forState:UIControlStateNormal];
    [btnBidMinus setBackgroundColor:[UIColor clearColor]];
    [btnBidMinus.titleLabel setFont:[UIFont systemFontOfSize:32]];
    btnBidMinus.layer.cornerRadius = btnBidMinus.frame.size.width/2;
    btnBidMinus.showsTouchWhenHighlighted = YES;
    [viewMoney addSubview:btnBidMinus];
    
    btnBidAdd = [FlatButton buttonWithType:UIButtonTypeCustom];
    [btnBidAdd addTarget:self action:@selector(bidButton:) forControlEvents:UIControlEventTouchUpInside];
    [btnBidAdd setFrame:CGRectMake(SCREEN.size.width-50-btnBidMinus.frame.size.width, 75, btnBidMinus.frame.size.width, btnBidMinus.frame.size.height)];
    [btnBidAdd setTitle:@"+" forState:UIControlStateNormal];
    [btnBidAdd setBackgroundColor:[UIColor clearColor]];
    [btnBidAdd.titleLabel setFont:[UIFont systemFontOfSize:32]];
    btnBidAdd.layer.cornerRadius = btnBidAdd.frame.size.width/2;
    btnBidAdd.showsTouchWhenHighlighted = YES;
    [viewMoney addSubview:btnBidAdd];
    
    lblInstructions = [[UILabel alloc] initWithFrame:CGRectMake(0, btnMain.frame.origin.y-50, SCREEN.size.width, 50)];
    lblInstructions.text = @"PRESS START TO DEAL";
    lblInstructions.textAlignment = NSTextAlignmentCenter;
    lblInstructions.textColor = [UIColor flat:WhiteSmoke];
    lblInstructions.font = [UIFont systemFontOfSize:18];
    lblInstructions.center = CGPointMake(SCREEN.size.width/2, SCREEN.size.height/2+(btnMain.frame.origin.y-SCREEN.size.height/2+height/2)/2);
    [self.view addSubview:lblInstructions];
}
- (void)startGame {
    lblInstructions.text = @"PLACE BET & DEAL";
    [btnMain setTitle:@"DEAL" forState:UIControlStateNormal];
    btnBidMinus.userInteractionEnabled = YES;
    btnBidAdd.userInteractionEnabled = YES;
    btnMain.userInteractionEnabled = YES;
    btnMain.alpha = 1.0;

    if (money == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Five Card Stud" message:@"You're out of money :(\nRequest more?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Request", @"Request more")
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action) {
                                           money = 100;
                                           lblMoney.text = [NSString stringWithFormat:@"%i",(int)money];
                                           [prefs setInteger:money forKey:@"money"];
                                           [prefs synchronize];
                                       }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (bet > money) {
        bet = money;
        lblBet.text = [NSString stringWithFormat:@"%i",(int)bet];
    }
    
    if (gameHasStarted == NO) {
        viewMoney.hidden = NO;
        viewMoney.alpha = 0.0;
        [UIView animateWithDuration:0.5 animations:^{
            viewMoney.alpha = 1.0;
            [self.view viewWithTag:7].alpha = 0.0;
        } completion:^(BOOL finished) {
            [[self.view viewWithTag:7] removeFromSuperview];
        }];
    }
    
    [self deselectCard:[self cardForIndex:0]];
    [self deselectCard:[self cardForIndex:1]];
    [self deselectCard:[self cardForIndex:2]];
    [self deselectCard:[self cardForIndex:3]];
    [self deselectCard:[self cardForIndex:4]];
    
    gameHasStarted = YES;
}
- (void)dealCards {
    CGFloat delay = 0.0;
    if (![self viewHasBeenSelected:[self cardForIndex:0]]) {
        [self performSelector:@selector(flipCard1) withObject:nil afterDelay:delay];
        delay = delay + 0.25;
    }
    if (![self viewHasBeenSelected:[self cardForIndex:1]]) {
        [self performSelector:@selector(flipCard2) withObject:nil afterDelay:delay];
        delay = delay + 0.25;
    }
    if (![self viewHasBeenSelected:[self cardForIndex:2]]) {
        [self performSelector:@selector(flipCard3) withObject:nil afterDelay:delay];
        delay = delay + 0.25;
    }
    if (![self viewHasBeenSelected:[self cardForIndex:3]]) {
        [self performSelector:@selector(flipCard4) withObject:nil afterDelay:delay];
        delay = delay + 0.25;
    }
    if (![self viewHasBeenSelected:[self cardForIndex:4]]) {
        [self performSelector:@selector(flipCard5) withObject:nil afterDelay:delay];
        delay = delay + 0.25;
    }
    if ([lblInstructions.text isEqualToString:@"CHECKING CARDS..."]) {
        [self performSelector:@selector(checkCards) withObject:nil afterDelay:delay*3];
    }
    
}
- (void)checkCards {
    if ([self checkForWinnings] == YES) {
        money = money+bet;
        NSLog(@"Win");
    } else {
        money = money-bet;
        NSLog(@"Loose");
    }
    lblMoney.text = [NSString stringWithFormat:@"%i",(int)money];
    [prefs setInteger:money forKey:@"money"];
    [prefs synchronize];
    [self startGame];
}

#pragma mark - UIButton Functions
- (void)mainButton {
    if ([lblInstructions.text isEqualToString:@"PRESS START TO DEAL"]) {
        [self startGame];
    } else if ([lblInstructions.text isEqualToString:@"PLACE BET & DEAL"]) {
        lblInstructions.text = @"HOLD OR DRAW";
        [btnMain setTitle:@"DRAW" forState:UIControlStateNormal];
        btnBidMinus.userInteractionEnabled = NO;
        btnBidAdd.userInteractionEnabled = NO;
        [self dealCards];
    } else if ([lblInstructions.text isEqualToString:@"HOLD OR DRAW"]) {
        btnMain.userInteractionEnabled = NO;
        btnMain.alpha = 0.75;
        lblInstructions.text = @"CHECKING CARDS...";
        [self dealCards];
    }
}
- (void)cardButton:(UIButton*)sender {
    if (gameHasStarted == NO || [lblInstructions.text isEqualToString:@"PLACE BET & DEAL"]) {
        return;
    }
    
    sender.layer.masksToBounds = YES;
    
    if ([self viewHasBeenSelected:(FlatButton*)sender] == YES) {
        for (UIView *view in sender.subviews) {
            if ([view isMemberOfClass:[TriangleView class]]) {
                [view removeFromSuperview];
                break;
            }
        }
    } else {
        NSInteger height = SCREEN.size.height/3;
        if (height > 250) {
            height = 250;
        }
        TriangleView *view = [[TriangleView alloc] initWithFrame:CGRectMake((SCREEN.size.width-30)/5-(SCREEN.size.width-30)/7, height-(SCREEN.size.width-30)/7, (SCREEN.size.width-30)/7, (SCREEN.size.width-30)/7)];
        view.backgroundColor = [UIColor flat:GreenHaze];
        view.userInteractionEnabled = NO;
        [sender addSubview:view];
    }
}
- (void)bidButton:(UIButton*)sender {
    if (sender == btnBidMinus) {
        if (bet > 5) {
            bet= bet-5;
        }
    } else {
        if (bet < 25 && bet < money) {
            bet= bet+5;
        }
    }
    lblBet.text = [NSString stringWithFormat:@"%i",(int)bet];
}

#pragma mark - Flip Cards
- (void)flipCard:(FlatButton*)card completion:(void (^)(void))complete {
    [UIView transitionFromView:card toView:[self cardAtIndex:card.tag] duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
        if (complete) {
            complete();
        }
    }];
}
- (void)flipCard1 {
    FlatButton *btnCard = (FlatButton*)[self.view viewWithTag:10];
    [self flipCard:btnCard completion:nil];
}
- (void)flipCard2 {
    [self flipCard:(FlatButton*)[self.view viewWithTag:11] completion:nil];
}
- (void)flipCard3 {
    [self flipCard:(FlatButton*)[self.view viewWithTag:12] completion:nil];
}
- (void)flipCard4 {
    [self flipCard:(FlatButton*)[self.view viewWithTag:13] completion:nil];
}
- (void)flipCard5 {
    [self flipCard:(FlatButton*)[self.view viewWithTag:14] completion:nil];
}
- (FlatButton*)cardForIndex:(NSInteger)index {
    return (FlatButton*)[self.view viewWithTag:index+10];
}

#pragma mark - HandleCards
- (void)loadCards {
    aryCards = [[NSArray alloc] initWithObjects:
                @"diamonds-2",
                @"diamonds-3",
                @"diamonds-4",
                @"diamonds-5",
                @"diamonds-6",
                @"diamonds-7",
                @"diamonds-8",
                @"diamonds-9",
                @"diamonds-10",
                @"diamonds-J",
                @"diamonds-Q",
                @"diamonds-K",
                @"diamonds-A",
                @"clubs-2",
                @"clubs-3",
                @"clubs-4",
                @"clubs-5",
                @"clubs-6",
                @"clubs-7",
                @"clubs-8",
                @"clubs-9",
                @"clubs-10",
                @"clubs-J",
                @"clubs-Q",
                @"clubs-K",
                @"clubs-A",
                @"hearts-2",
                @"hearts-3",
                @"hearts-4",
                @"hearts-5",
                @"hearts-6",
                @"hearts-7",
                @"hearts-8",
                @"hearts-9",
                @"hearts-10",
                @"hearts-J",
                @"hearts-Q",
                @"hearts-K",
                @"hearts-A",
                @"spades-2",
                @"spades-3",
                @"spades-4",
                @"spades-5",
                @"spades-6",
                @"spades-7",
                @"spades-8",
                @"spades-9",
                @"spades-10",
                @"spades-J",
                @"spades-Q",
                @"spades-K",
                @"spades-A",
                nil];
    aryCardsBeingUsed = [NSMutableArray new];
}
- (void)setCard:(FlatButton*)sender {
    
    NSString *cardType;
    while (1) {
        int rndValue = 0 + arc4random() % (52 - 0);
        cardType = [aryCards objectAtIndex:rndValue];
        if (![aryCardsBeingUsed containsObject:cardType]) {
            break;
        }
    }
    NSArray *aryTemp = [cardType componentsSeparatedByString:@"-"];
    
    UIImage *imgIcon = nil;
    if ([[aryTemp objectAtIndex:0] isEqualToString:@"diamonds"]) {
        imgIcon = [UIImage imageNamed:@"diamond.png"];
    } else if ([[aryTemp objectAtIndex:0] isEqualToString:@"spades"]) {
        imgIcon = [UIImage imageNamed:@"spade.png"];
    } else if ([[aryTemp objectAtIndex:0] isEqualToString:@"clubs"]) {
        imgIcon = [UIImage imageNamed:@"club.png"];
    } else if ([[aryTemp objectAtIndex:0] isEqualToString:@"hearts"]) {
        imgIcon = [UIImage imageNamed:@"heart.png"];
    }
    
    NSInteger height = SCREEN.size.height/3;
    if (height > 250) {
        height = 250;
    }
    UIImageView *imgViewIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, height-(SCREEN.size.width-30)/5-20, (SCREEN.size.width-30)/5-10, (SCREEN.size.width-30)/5-10)];
    imgViewIcon.image = imgIcon;
    imgViewIcon.userInteractionEnabled = NO;
    [sender addSubview:imgViewIcon];
    
    UILabel *lblCardType = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, (SCREEN.size.width-30)/5, (SCREEN.size.width-30)/5)];
    lblCardType.text = [((NSString*)[aryTemp objectAtIndex:1]) stringByReplacingOccurrencesOfString:@"-" withString:@""];
    lblCardType.textAlignment = NSTextAlignmentCenter;
    lblCardType.font = [UIFont systemFontOfSize:42];
    lblCardType.userInteractionEnabled = NO;
    [sender addSubview:lblCardType];
    
    if ([aryCardsBeingUsed count] > 4) {
        [aryCardsBeingUsed removeObjectAtIndex:sender.tag-10];
    }
    [aryCardsBeingUsed insertObject:cardType atIndex:sender.tag-10];
}
- (void)setCard:(FlatButton*)sender withType:(NSString*)type {
    NSArray *aryTemp = [type componentsSeparatedByString:@"-"];
    
    UIImage *imgIcon = nil;
    if ([[aryTemp objectAtIndex:0] isEqualToString:@"diamonds"]) {
        imgIcon = [UIImage imageNamed:@"diamond.png"];
    } else if ([[aryTemp objectAtIndex:0] isEqualToString:@"spades"]) {
        imgIcon = [UIImage imageNamed:@"spade.png"];
    } else if ([[aryTemp objectAtIndex:0] isEqualToString:@"clubs"]) {
        imgIcon = [UIImage imageNamed:@"club.png"];
    } else if ([[aryTemp objectAtIndex:0] isEqualToString:@"hearts"]) {
        imgIcon = [UIImage imageNamed:@"heart.png"];
    }
    
    NSInteger height = SCREEN.size.height/3;
    if (height > 250) {
        height = 250;
    }
    UIImageView *imgViewIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, height-(SCREEN.size.width-30)/5-20, (SCREEN.size.width-30)/5-10, (SCREEN.size.width-30)/5-10)];
    imgViewIcon.image = imgIcon;
    imgViewIcon.userInteractionEnabled = NO;
    [sender addSubview:imgViewIcon];
    
    UILabel *lblCardType = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, (SCREEN.size.width-30)/5, (SCREEN.size.width-30)/5)];
    lblCardType.text = [((NSString*)[aryTemp objectAtIndex:1]) stringByReplacingOccurrencesOfString:@"-" withString:@""];
    lblCardType.textAlignment = NSTextAlignmentCenter;
    lblCardType.font = [UIFont systemFontOfSize:42];
    lblCardType.userInteractionEnabled = NO;
    [sender addSubview:lblCardType];
    
    if ([aryCardsBeingUsed count] > 4) {
        [aryCardsBeingUsed removeObjectAtIndex:sender.tag-10];
    }
    [aryCardsBeingUsed insertObject:type atIndex:sender.tag-10];
}
- (BOOL)checkForWinnings {
    PokerHand hand = [PokerHandChecker handTypeForHand:aryCardsBeingUsed];
    NSLog(@"%@", NSStringFromPokerHand(hand));
    if (hand != HighCard && hand != OnePair) {
        return YES;
    }
    return NO;
}

#pragma mark - Other
- (FlatButton*)cardAtIndex:(NSInteger)index {
    index = index-10;
    NSInteger height = SCREEN.size.height/3;
    if (height > 250) {
        height = 250;
    }
    FlatButton *btnCard = [FlatButton buttonWithType:UIButtonTypeCustom];
    [btnCard addTarget:self action:@selector(cardButton:) forControlEvents:UIControlEventTouchUpInside];
    [btnCard setFrame:CGRectMake(0, 0, (SCREEN.size.width-30)/5, height)];
    [btnCard setTitle:@"" forState:UIControlStateNormal];
    [btnCard setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnCard setBackgroundColor:[UIColor flat:WhiteSmoke]];
    btnCard.layer.cornerRadius = [FlatButton cornerRadius];
    btnCard.tag = 10+index;
    
    [self setCard:btnCard];
    
    return btnCard;
}
- (BOOL)viewHasBeenSelected:(FlatButton*)sender {
    for (UIView *view in sender.subviews) {
        if ([view isMemberOfClass:[TriangleView class]]) {
            return YES;
        }
    }
    
    return NO;
}
- (void)deselectCard:(FlatButton*)card {
    if ([self viewHasBeenSelected:card]) {
        for (UIView *view in card.subviews) {
            if ([view isMemberOfClass:[TriangleView class]]) {
                [view removeFromSuperview];
            }
        }
    }
}
@end
