//
//  GameScene.m
//  SpirteContainer
//
//  Created by Stefan on 3/19/17.
//  Copyright © 2017 Stefan. All rights reserved.
//

#import "GameScene.h"


static const uint32_t category_fence   =  0x1 << 3;
static const uint32_t category_ball    =  0x1 << 0;

@interface GameScene () <SKPhysicsContactDelegate>

@end

@implementation GameScene{
    NSTimeInterval _lastUpdateTime;
    SKShapeNode *_spinnyNode;
    SKLabelNode *_label;
}

- (void)sceneDidLoad {
    
    _lastUpdateTime = 0;
    
    self.name = @"Fence";
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.categoryBitMask = category_fence;
    self.physicsBody.collisionBitMask = 0x0;
    self.physicsBody.contactTestBitMask = 0x0;
    self.physicsWorld.contactDelegate = self;
    
    SKSpriteNode *background = (SKSpriteNode *)[self childNodeWithName:@"Background"];
    background.zPosition = 0;
    
    SKSpriteNode *ball1 = [SKSpriteNode spriteNodeWithImageNamed:@"blueball_x1.png"];
    ball1.name = @"Ball";
    ball1.zPosition = 1.0;
    ball1.position = CGPointMake(-500, 370);
    
    ball1.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball1.size.width/2];
    ball1.physicsBody.dynamic = YES;
    ball1.physicsBody.friction = 0.0;
    ball1.physicsBody.restitution = 1.0;
    ball1.physicsBody.linearDamping = 0.1;
    ball1.physicsBody.angularDamping = 0.0;
    ball1.physicsBody.allowsRotation = NO;
    ball1.physicsBody.mass = 5.0;
    ball1.physicsBody.velocity = CGVectorMake(550.0, 550.0); // initial velocity
    ball1.physicsBody.affectedByGravity = YES;
    ball1.physicsBody.categoryBitMask = category_ball;
    ball1.physicsBody.collisionBitMask = category_fence | category_ball;
    ball1.physicsBody.contactTestBitMask = category_fence;
    ball1.physicsBody.usesPreciseCollisionDetection = YES;

    [self addChild:ball1];

    
}

- (void) didBeginContact:(SKPhysicsContact *)contact{
    NSString *nameA = contact.bodyA.node.name;
    NSString *nameB = contact.bodyB.node.name;
    
    if(([nameA containsString:@"Fence"] && [nameB containsString:@"Ball"]) ||
            ([nameA containsString:@"Ball"] && [nameB containsString:@"Fence"])){
        
        SKNode *ball;
        if([nameA containsString:@"Ball"]){
            ball = contact.bodyA.node;
        }else{
            ball = contact.bodyB.node;
        }
        
        if(contact.contactPoint.y < -364){
            SKAction *fenceAudio = [SKAction playSoundFileNamed:@"sound_wall.m4a" waitForCompletion:NO];
            
            NSString *particleExplosionPath = [[NSBundle mainBundle]pathForResource:@"MyParticle" ofType:@"sks"];
            
            SKEmitterNode *particleExplosion = [NSKeyedUnarchiver unarchiveObjectWithFile:particleExplosionPath];
            
            particleExplosion.position = CGPointMake(0, 0);
            particleExplosion.zPosition = 2;
            particleExplosion.targetNode = self;
            SKAction *actionParticleExplosion = [SKAction runBlock:^{
                [ball addChild:particleExplosion];
            }];
            
            SKAction *actionFireSeqence = [SKAction sequence:@[fenceAudio, actionParticleExplosion]];
            [ball runAction:actionFireSeqence];
        }
    }

}



- (void)touchDownAtPoint:(CGPoint)pos {
    //    SKShapeNode *n = [_spinnyNode copy];
    //    n.position = pos;
    //    n.strokeColor = [SKColor greenColor];
    //    [self addChild:n];
}

- (void)touchMovedToPoint:(CGPoint)pos {
    //    SKShapeNode *n = [_spinnyNode copy];
    //    n.position = pos;
    //    n.strokeColor = [SKColor blueColor];
    //    [self addChild:n];
}

- (void)touchUpAtPoint:(CGPoint)pos {
    //    SKShapeNode *n = [_spinnyNode copy];
    //    n.position = pos;
    //    n.strokeColor = [SKColor redColor];
    //    [self addChild:n];
}

-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
    
    // Initialize _lastUpdateTime if it has not already been
    if (_lastUpdateTime == 0) {
        _lastUpdateTime = currentTime;
    }
    
    // Calculate time since last update
    CGFloat dt = currentTime - _lastUpdateTime;
    
    // Update entities
    for (GKEntity *entity in self.entities) {
        [entity updateWithDeltaTime:dt];
    }
    
    _lastUpdateTime = currentTime;}

@end
