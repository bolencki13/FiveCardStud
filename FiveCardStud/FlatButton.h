//
//  FlatButton.h
//  test
//
//  Created by Brian Olencki on 12/30/15.
//  Copyright © 2015 bolencki13. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    Turquoise =  0x1abc9c,
    Emerald =  0x2ecc71,
    PeterRiver =  0x3498db,
    Amethyst =  0x9b59b6,
    WetAsphalty =  0x34495e,
    GreenSea =  0x16a085,
    Nephritis =  0x27ae60,
    BelizeHole =  0x2980b9,
    Wisteria =  0x8e44ad,
    MidnightBlue =  0x2c3e50,
    SunFlower =  0xf1c40f,
    Carrot =  0xe67e22,
    Alizarin =  0xe74c3c,
    Clouds =  0xecf0f1,
    Concrete =  0x95a5a6,
    Orange =  0xf39c12,
    Pumpkin =  0xd35400,
    Pomegranate =  0xc0392b,
    Silver =  0xbdc3c7,
    Asbestos =  0x7f8c8d,
    ChestnuteRose =  0xd24d57,
    Thunderbird =  0xD91E18,
    OldBrick =  0x96281B,
    Flamingo =  0xEF4836,
    Valencia =  0xD64541,
    TallPoppy =  0xC0392B,
    Monza =  0xCF000F,
    Cinnabar =  0xE74C3C,
    Razzmatazz =  0xDB0A5B,
    SunsetOrange =  0xF64747,
    WaxFlower =  0xF1A9A0,
    Cabaret =  0xD2527F,
    NewYorkPink =  0xE08283,
    RadicalRed =  0xF62459,
    Sunglo =  0xE26A6A,
    Snuff =  0xDCC6E0,
    Rebeccapurple =  0x663399,
    HoneyFlower =  0x674172,
    Wistful =  0xAEA8D3,
    Plum =  0x913D88,
    Seance =  0x9A12B3,
    MediumPurple =  0xBF55EC,
    LightWisteria =  0xBE90D4,
    Studio =  0x8E44AD,
    SanMarino =  0x446CB3,
    AliceBlue =  0xE4F1FE,
    RoyalBlue =  0x4183D7,
    PictonBlue =  0x22A7F0,
    Spray =  0x81CFE0,
    Shakespeare =  0x52B3D9,
    HummingBird =  0xC5EFF7,
    Curious =  0x3498DB,
    Madison =  0x2C3E50,
    DodgerBlue =  0x19B5FE,
    Ming =  0x336E7B,
    EbonyClay =  0x22313F,
    Malibu =  0x6BB9F0,
    SummerySky =  0x1E8BC3,
    Chambray =  0x3A539B,
    PickledBluewood =  0x34495E,
    Hoki =  0x67809F,
    JellyBean =  0x2574A9,
    JacksonsPurple =  0x1F3A93,
    JordyBlue =  0x89C4F4,
    SteelBlue =  0x4B77BE,
    FountainBlue =  0x5C97BF,
    MediumTurquoise =  0x4ECDC4,
    AquaIsland =  0xA2DED0,
    Gossip =  0x87D37C,
    DarkSeaGreen =  0x90C695,
    Eucalyptus =  0x26A65B,
    CaribbeanGreen =  0x03C9A9,
    SilverTree =  0x68C3A3,
    Downy =  0x65C6BB,
    MountainMeadow =  0x1BBC9B,
    LightSeaGreen =  0x1BA39C,
    MediumAquamarine =  0x66CC99,
    Madang =  0xC8F7C5,
    Riptide =  0x86E2D5,
    Shamrock =  0x2ECC71,
    Niagara =  0x16A085,
    GreenHaze =  0x019875,
    OceanGreen =  0x4DAF7C,
    NiagaraOne =  0x2ABB9B,
    Jade =  0x00B16A,
    Salem =  0x1E824C,
    Observatory =  0x049372,
    JungleGreen =  0x26C281,
    CapeHoney =  0xFDE3A7,
    California =  0xF89406,
    FireBush =  0xEB9532,
    TahitiGold =  0xE87E04,
    Casablanca =  0xF4B350,
    Crusta =  0xF2784B,
    SeaBuckthorn =  0xEB974E,
    LightningYellow =  0xF5AB35,
    BurntOrange =  0xD35400,
    ButterCup =  0xF39C12,
    Ecstasy =  0xF9690E,
    Sandstorm =  0xF9BF3B,
    Jaffa =  0xF27935,
    Zest =  0xE67E22,
    WhiteSmoke =  0xECECEC,
    Lynch =  0x6C7A89,
    Pumice =  0xD2D7D3,
    Gallery =  0xEEEEEE,
    SilverSand =  0xBDC3C7,
    Porcelain =  0xECF0F1,
    Cascade =  0x95A5A6,
    Iron =  0xDADFE1,
    Edward =  0xABB7B7,
    Cararra =  0xF2F1E
} Colors;
@interface UIColor (CustomColors)
+ (UIColor *)flat:(Colors)color;
- (UIColor *)inverseColor;
- (UIColor *)lighterColor;
- (UIColor *)darkerColor;
@end

@interface FlatButton : UIButton
+ (CGFloat)cornerRadius;
@end
