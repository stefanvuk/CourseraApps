//
//  GameStart.m
//  BreakOut
//
//  Created by Stefan on 2/27/17.
//  Copyright © 2017 Stefan. All rights reserved.
//

#import "GameStart.h"
#import "GameScene.h"

@implementation GameStart

// ovo je da ako pipnemo ekran tokom startScene ekrana ono pokrene GameScene
- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if(touches){
        SKView *skView = (SKView *)self.view;
        
        GameScene *scene = [GameScene nodeWithFileNamed:@"GameScene"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene
        [skView presentScene:scene];
    }
}




@end
