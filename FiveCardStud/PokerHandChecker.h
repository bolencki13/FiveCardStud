//
//  PokerHandChecker.h
//  FiveCardStud
//
//  Created by Brian Olencki on 12/31/15.
//  Copyright © 2015 bolencki13. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    HighCard,
    OnePair,
    TwoPair,
    ThreeOfAKind,
    Straight,
    Flush,
    FullHouse,
    FourOfAKind,
    StraightFlush,
    RoyalFlush
} PokerHand;

NSString *NSStringFromPokerHand(PokerHand handType);

@interface PokerHandChecker : NSObject {
    NSArray *_hand;
}
+ (BOOL)checkWithHand:(NSArray*)hand;
+ (PokerHand)handTypeForHand:(NSArray*)hand;
@end
