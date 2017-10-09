//
//  GameScene.m
//  BreakOut
//
//  Created by Stefan on 2/27/17.
//  Copyright © 2017 Stefan. All rights reserved.
//

// veliki problem sa kodom je bio to sto
// pola vreme cvorovi i elementi nisu hteli da se pojave
// potpuno random je radilo, popravljeno je tako sto
// za svako sprite/node ubacim zPosition da je 1.0
// The layer’s position on the z axis. Animatable.
// kad se menja zposition menja se front-to-back
// ordering of layers onscreen.

#import "GameScene.h"
#import "GameOver.h"
#import "GameWon.h"

static const CGFloat kTrackPointsPerSecond = 1000;

static const uint32_t category_fence   =  0x1 << 3;
static const uint32_t category_paddle  =  0x1 << 2;
static const uint32_t category_block   =  0x1 << 1;
static const uint32_t category_ball    =  0x1 << 0;


@interface GameScene () <SKPhysicsContactDelegate>

@property (nonatomic, strong, nullable) UITouch *motivatingTouch;
@property (strong, nonatomic) NSMutableArray *blockFrames;

@end

@implementation GameScene

- (void)sceneDidLoad {
    
    self.name = @"Fence";
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.categoryBitMask = category_fence;
    self.physicsBody.collisionBitMask = 0x0;
    self.physicsBody.contactTestBitMask = 0x0;
    self.physicsWorld.contactDelegate = self;

    SKSpriteNode *background = (SKSpriteNode *)[self childNodeWithName:@"Background"];
    background.lightingBitMask = 0x1;
    background.zPosition = 0; // Below of all the things drawn

    
    // pravimo kugle i povezujemo ih pomocu SKPhysicsJointSpring
    SKSpriteNode *ball1 = [SKSpriteNode spriteNodeWithImageNamed:@"magic_ball.png"];
    ball1.name = @"Ball1";
    ball1.zPosition = 1;
    ball1.position = CGPointMake(60, 30); // bilo je 100, self.size.height/2 sada je 60, 30
    
    ball1.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball1.size.width/2];
    ball1.physicsBody.dynamic = YES;
    ball1.physicsBody.friction = 0.0;
    ball1.physicsBody.restitution = 1.0;
    ball1.physicsBody.linearDamping = 0.0;
    ball1.physicsBody.angularDamping = 0.0;
    ball1.physicsBody.allowsRotation = NO;
    ball1.physicsBody.mass = 1.0;
    ball1.physicsBody.velocity = CGVectorMake(200.0, 200.0); // initial velocity
    ball1.physicsBody.affectedByGravity = NO;
    ball1.physicsBody.categoryBitMask = category_ball;
    ball1.physicsBody.collisionBitMask = category_fence | category_ball | category_block | category_paddle;
    ball1.physicsBody.contactTestBitMask = category_fence | category_block;
    ball1.physicsBody.usesPreciseCollisionDetection = YES;
    
    // add a light to the ball
    SKLightNode *light = [SKLightNode new];
    light.categoryBitMask = 0x1;
    light.falloff = 1;
    light.ambientColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    light.lightColor = [UIColor colorWithRed:0.7 green:0.7 blue:1.0 alpha:1.0];
    light.shadowColor = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    light.zPosition = 1;
    
    [ball1 addChild:light];
    
    SKSpriteNode *ball2 = [SKSpriteNode spriteNodeWithImageNamed:@"magic_ball.png"];
    ball2.name = @"Ball2";
    ball2.zPosition = 1;
    ball2.position = CGPointMake(60, 75); // bilo je 150, self.size.height/2 sada je 60, 75
    
    ball2.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball2.size.width/2];
    ball2.physicsBody.dynamic = YES;
    ball2.physicsBody.friction = 0.0;
    ball2.physicsBody.restitution = 1.0;
    ball2.physicsBody.linearDamping = 0.0;
    ball2.physicsBody.angularDamping = 0.0;
    ball2.physicsBody.allowsRotation = NO;
    ball2.physicsBody.mass = 1.0;
    ball2.physicsBody.velocity = CGVectorMake(0.0, 0.0); // initial velocity
    ball2.physicsBody.affectedByGravity = NO;
    ball2.physicsBody.categoryBitMask = category_ball;
    ball2.physicsBody.collisionBitMask = category_fence | category_ball | category_block | category_paddle;
    ball2.physicsBody.contactTestBitMask = category_fence | category_block;
    ball2.physicsBody.usesPreciseCollisionDetection = YES;
    
    // pravimo paddle
    SKSpriteNode *paddle = [SKSpriteNode spriteNodeWithImageNamed:@"paddle.png"];
    paddle.name = @"Paddle";
    paddle.zPosition = 1;
    paddle.position = CGPointMake(0, -300);
    paddle.lightingBitMask = 0x1;
    
    paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(paddle.size.width, paddle.size.height)];
    paddle.physicsBody.dynamic = NO;
    paddle.physicsBody.friction = 0.0;
    paddle.physicsBody.restitution = 1.0;
    paddle.physicsBody.linearDamping = 0.0;
    paddle.physicsBody.angularDamping = 0.0;
    paddle.physicsBody.allowsRotation = NO;
    paddle.physicsBody.mass = 1.0;
    paddle.physicsBody.velocity = CGVectorMake(0.0, 0.0); // initial velocity
    paddle.physicsBody.categoryBitMask = category_paddle;
    paddle.physicsBody.collisionBitMask = 0x0;
    paddle.physicsBody.contactTestBitMask = category_ball;
    paddle.physicsBody.usesPreciseCollisionDetection = YES;

    
    [self addChild:ball1];
    [self addChild:ball2];
    [self addChild:paddle];
    
    CGPoint ball1Anchor = CGPointMake(ball1.position.x, ball1.position.y);
    CGPoint ball2Anchor = CGPointMake(ball2.position.x, ball2.position.y);
    
    SKPhysicsJointSpring *joint = [SKPhysicsJointSpring jointWithBodyA:ball1.physicsBody
                                                                    bodyB:ball2.physicsBody
                                                                    anchorA:ball1Anchor
                                                                    anchorB:ball2Anchor];
    
    joint.damping = 0.0;
    joint.frequency = 1.5;
    
    [self.scene.physicsWorld addJoint:joint];
    
    self.blockFrames = [NSMutableArray array];
    
    SKTextureAtlas *blockAnimation = [SKTextureAtlas atlasNamed:@"block.atlas"];
    unsigned long numImages = blockAnimation.textureNames.count;
    for(int i = 0; i < numImages; i++){
        NSString *textureName = [NSString stringWithFormat:@"block%02d", i];
        SKTexture *temp = [blockAnimation textureNamed:textureName];
        [self.blockFrames addObject:temp];
    }
    
    
    
    // Add blocks to the game
    
    // prvo smo pravili blokove od single slike, sad pravimo iz atlasa
    // SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"block.png"];
    
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithTexture:self.blockFrames[0]];
    node.scale = 0.2;
    
    CGFloat kBlockWidth = node.size.width;
    CGFloat kBlockHeight = node.size.height;
    CGFloat kBlockHorizSpace = 20.0f;
    
    int kBlocksPerRow = (1024 / (kBlockWidth + kBlockHorizSpace));

    
    // ovde je bio problem isto kao i sa crtanjem paddle
    // sto centar nije u levom donjem cosku vec u centru
    // zbog toga za poziciju prvog bloka gledamo odozgore
    // 350 visinu, jer cela visina je 768, gornja polovina
    // je 384 a donja -384, zato crtamo na 350
    // za sirinu krecemo od -500 jer je leva strana -512
    // desna je +512 pa se polako krecemo za sirinu bloka
    // i jos malo dok ne iscrtamo sve!!!!!!!
    // ovo je za ipad, iphone ima manji ekran pa bi morala da se menja formula!
    
    
    // Top row of blocks
    for(int i = 0; i < kBlocksPerRow; i++){
        //node = [SKSpriteNode spriteNodeWithImageNamed:@"block.png"];
        node = [SKSpriteNode spriteNodeWithTexture:self.blockFrames[0]];
        node.scale = 0.2;
        
        node.name = @"Block";
        node.position = CGPointMake(-500+(kBlockHorizSpace/2 + kBlockWidth/2 + i*(kBlockWidth) + i*kBlockHorizSpace),
                                    350);
        node.zPosition = 1;
        node.lightingBitMask = 0x1;
        
        node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:node.size center:CGPointMake(0, 0)];
        node.physicsBody.dynamic = NO;
        node.physicsBody.friction = 0.0;
        node.physicsBody.restitution = 1.0;
        node.physicsBody.linearDamping = 0.0;
        node.physicsBody.angularDamping = 0.0;
        node.physicsBody.allowsRotation = NO;
        node.physicsBody.mass = 1.0;
        node.physicsBody.velocity = CGVectorMake(0.0, 0.0);
        node.physicsBody.categoryBitMask = category_block;
        node.physicsBody.collisionBitMask = 0x0;
        node.physicsBody.contactTestBitMask = category_ball;
        node.physicsBody.usesPreciseCollisionDetection = NO;
        
        [self addChild:node];
        
    }
    
    kBlocksPerRow = (self.size.width / (kBlockWidth + kBlockHorizSpace)) - 1;
    
    // Middle row of blocks
    for(int i = 0; i < kBlocksPerRow; i++){
    
//        node = [SKSpriteNode spriteNodeWithImageNamed:@"block.png"];
        node = [SKSpriteNode spriteNodeWithTexture:self.blockFrames[0]];
        node.scale = 0.2;
        
        node.name = @"Block";
        node.position = CGPointMake(-500 + (kBlockHorizSpace + kBlockWidth + i*(kBlockWidth) + i*kBlockHorizSpace),
                                    350 - (1.5 * kBlockHeight));
        node.zPosition = 1;
        node.lightingBitMask = 0x1;
        
        node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:node.size center:CGPointMake(0, 0)];
        node.physicsBody.dynamic = NO;
        node.physicsBody.friction = 0.0;
        node.physicsBody.restitution = 1.0;
        node.physicsBody.linearDamping = 0.0;
        node.physicsBody.angularDamping = 0.0;
        node.physicsBody.allowsRotation = NO;
        node.physicsBody.mass = 1.0;
        node.physicsBody.velocity = CGVectorMake(0.0, 0.0);
        node.physicsBody.categoryBitMask = category_block;
        node.physicsBody.collisionBitMask = 0x0;
        node.physicsBody.contactTestBitMask = category_ball;
        node.physicsBody.usesPreciseCollisionDetection = NO;
        
        [self addChild:node];
    }
    
    
    // Third row of blocks
    
    kBlocksPerRow = (self.size.width /(kBlockWidth + kBlockHorizSpace));
    
    for(int i = 0; i < kBlocksPerRow; i++){
        
       // node = [SKSpriteNode spriteNodeWithImageNamed:@"block.png"];
        node = [SKSpriteNode spriteNodeWithTexture:self.blockFrames[0]];
        node.scale = 0.2;
        
        node.name = @"Block";
        node.position = CGPointMake(-500 + (kBlockHorizSpace/2 + kBlockWidth/2 + i*(kBlockWidth) + i*kBlockHorizSpace),
                                    350 - (3.0 * kBlockHeight));
        node.zPosition = 1;
        node.lightingBitMask = 0x1;
        
        node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:node.size center:CGPointMake(0, 0)];
        node.physicsBody.dynamic = NO;
        node.physicsBody.friction = 0.0;
        node.physicsBody.restitution = 1.0;
        node.physicsBody.linearDamping = 0.0;
        node.physicsBody.angularDamping = 0.0;
        node.physicsBody.allowsRotation = NO;
        node.physicsBody.mass = 1.0;
        node.physicsBody.velocity = CGVectorMake(0.0, 0.0);
        node.physicsBody.categoryBitMask = category_block;
        node.physicsBody.collisionBitMask = 0x0;
        node.physicsBody.contactTestBitMask = category_ball;
        node.physicsBody.usesPreciseCollisionDetection = NO;
        
        [self addChild:node];
    }
    
}


- (void)touchDownAtPoint:(CGPoint)pos {
}

- (void)touchMovedToPoint:(CGPoint)pos {
}

- (void)touchUpAtPoint:(CGPoint)pos {
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // ovo ce biti oblast osetnjiva na dodire
    const CGRect touchRegion = CGRectMake( -512, -384, self.size.width, self.size.height * 0.3);
    
    
    for(UITouch *touch in touches){
        CGPoint p = [touch locationInNode:self];
        if(CGRectContainsPoint(touchRegion, p)){
            self.motivatingTouch = touch;
        }
    }
    // pozivamo metod, koji govori spritekitu da animira paddle u odnosu na dodir
    [self trackPaddlesToMotivatingTouches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [self trackPaddlesToMotivatingTouches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if([touches containsObject:self.motivatingTouch])
        self.motivatingTouch = nil;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if([touches containsObject:self.motivatingTouch])
        self.motivatingTouch = nil;
}

- (void) trackPaddlesToMotivatingTouches{
    
    // nismo u GameScene.sks napravili node sa imenom paddle,
    // zato ga ne bi nasao, pa gore tokom pravljenja paddle
    // postavljamo ime na Paddle
    SKNode *node = [self childNodeWithName:@"Paddle"];
    
    UITouch *touch = self.motivatingTouch;
    if(!touch)
        return;
    
    // uzimamo samo x koordinatu jer po x zelimo da se krecemo
    CGFloat xPos = [touch locationInNode:self].x;
    NSTimeInterval duration = ABS(xPos - node.position.x) / kTrackPointsPerSecond;
    [node runAction:[SKAction moveToX:xPos duration:duration]];
}

- (void) didBeginContact:(SKPhysicsContact *)contact{
    NSString *nameA = contact.bodyA.node.name;
    NSString *nameB = contact.bodyB.node.name;
    
    if(([nameA containsString:@"Ball"] && [nameB containsString:@"Block"]) ||
       ([nameA containsString:@"Block"] && [nameB containsString:@"Ball"])){
        
        // figure out which body is exploding
        SKNode *block;
        if([nameA containsString:@"Block"]){
            block = contact.bodyA.node;
        }else{
            block = contact.bodyB.node;
        }
        
        // do the build up
        SKAction *actionAudioRamp = [SKAction playSoundFileNamed:@"sound_block.m4a" waitForCompletion:NO];
        SKAction *actionVisualRamp = [SKAction animateWithTextures:self.blockFrames timePerFrame:0.04f resize:NO restore:NO];

        NSString *particleRampPath = [[NSBundle mainBundle] pathForResource:@"ParticleRampUp" ofType:@"sks"];
        SKEmitterNode *particleRamp = [NSKeyedUnarchiver unarchiveObjectWithFile:particleRampPath];
        
        particleRamp.position = CGPointMake(0, 0);
        particleRamp.zPosition = 0;
        SKAction *actionParticleRamp = [SKAction runBlock:^{
            [block addChild:particleRamp];
        }];
        
        // group
        SKAction *actionRampSequence = [SKAction group:@[actionAudioRamp, actionParticleRamp, actionVisualRamp]];
        
        SKAction *actionAudioExplode = [SKAction playSoundFileNamed:@"sound_explode.m4a" waitForCompletion:NO];
        
        NSString *particleExplosionPath = [[NSBundle mainBundle]pathForResource:@"MyParticle" ofType:@"sks"];
        
        SKEmitterNode *particleExplosion = [NSKeyedUnarchiver unarchiveObjectWithFile:particleExplosionPath];
        
        particleExplosion.position = CGPointMake(0, 0);
        particleExplosion.zPosition = 2;
        SKAction *actionParticleExplosion = [SKAction runBlock:^{
            [block addChild:particleExplosion];
        }];

        SKAction *actionRemoveBlock = [SKAction removeFromParent];
        
        SKAction *actionExplodeSequence = [SKAction sequence:@[actionAudioExplode, actionParticleExplosion,
                                                               [SKAction fadeOutWithDuration:1]]];
        
        SKAction *checkGameOver = [SKAction runBlock:^{
            // are we out of blocks? if so, game is over.
            // just wait a second so its not too abrupt.
            BOOL anyBlocksRemaining = ([self childNodeWithName:@"Block"] != nil);
            if(!anyBlocksRemaining){
                SKView *skView = (SKView *)self.view;
                [self removeFromParent];
                
                GameWon *scene = [GameWon nodeWithFileNamed:@"GameWon"];
                scene.scaleMode = SKSceneScaleModeAspectFit;
                [skView presentScene:scene];
            };
        }];
        
        [block runAction:[SKAction sequence:@[actionRampSequence, actionExplodeSequence, actionRemoveBlock, checkGameOver]]];

    } else if(([nameA containsString:@"Ball"] && [nameB containsString:@"Paddle"]) ||
              ([nameA containsString:@"Paddle"] && [nameB containsString:@"Ball"])){
                SKAction *paddleAudio = [SKAction playSoundFileNamed:@"sound_paddle.m4a" waitForCompletion:NO];
                [self runAction:paddleAudio];
            }
    else if(([nameA containsString:@"Fence"] && [nameB containsString:@"Ball"]) ||
                      ([nameA containsString:@"Ball"] && [nameB containsString:@"Fence"])){
            SKAction *fenceAudio = [SKAction playSoundFileNamed:@"sound_wall.m4a" waitForCompletion:NO];
            [self runAction:fenceAudio];
        
        
            SKNode *ball;
            if([nameA containsString:@"Ball"]){
                ball = contact.bodyA.node;
            }else{
                ball = contact.bodyB.node;
            }
        
            // you missed the ball - game over
            // ako je contact ispod -374 prekidamo igru
            // donja granica ekrana je -384 tako da je ovo
            // malo iznad granice fence
        
            if(contact.contactPoint.y < -374){
                SKAction *actionAudioExplode = [SKAction playSoundFileNamed:@"sound_explode.m4a" waitForCompletion:NO];
            
                NSString *particleExplosionPath = [[NSBundle mainBundle]pathForResource:@"MyParticle" ofType:@"sks"];
            
                SKEmitterNode *particleExplosion = [NSKeyedUnarchiver unarchiveObjectWithFile:particleExplosionPath];
            
                particleExplosion.position = CGPointMake(0, 0);
                particleExplosion.zPosition = 2;
                particleExplosion.targetNode = self;
                SKAction *actionParticleExplosion = [SKAction runBlock:^{
                    [ball addChild:particleExplosion];
                }];
                SKAction *actionRemoveBlock = [SKAction removeFromParent];
                
                SKAction *switchScene = [SKAction runBlock:^{
                    SKView *skView = (SKView *) self.view;
                    [self removeFromParent];
                    
                    // create a new scene
                    GameOver *scene = [GameOver nodeWithFileNamed:@"GameOver"];
                    scene.scaleMode = SKSceneScaleModeAspectFill;
                    
                    // present the scene
                    [skView presentScene:scene];
                }];
                SKAction *actionExplodeSequence = [SKAction sequence:@[actionAudioExplode, actionParticleExplosion,
                                                                       [SKAction fadeOutWithDuration:1], actionRemoveBlock, switchScene]];
                [ball runAction:actionExplodeSequence];
            }
        }
    else {
        SKAction *explode = [SKAction playSoundFileNamed:@"sound_wall.m4a" waitForCompletion:NO];
        [self runAction:explode];
    }

    NSLog(@"\nWhat collided? %@ %@", nameA, nameB);
}


// Called before each frame is rendered
-(void)update:(CFTimeInterval)currentTime {

    static const int kMaxSpeed = 1500;
    static const int kMinSpeed = 400;
    
    // Adjust the linear damping if the ball starts moving a little too fast or slow
    SKNode *ball1 = [self childNodeWithName:@"Ball1"];
    SKNode *ball2 = [self childNodeWithName:@"Ball2"];
    
    float speedball = sqrt(ball1.physicsBody.velocity.dx * ball1.physicsBody.velocity.dx +
                           ball1.physicsBody.velocity.dy * ball1.physicsBody.velocity.dy);
    
    float dx = (ball1.physicsBody.velocity.dx + ball2.physicsBody.velocity.dx)/2;
    float dy = (ball1.physicsBody.velocity.dy + ball2.physicsBody.velocity.dy)/2;
    float speed = sqrt(dx*dx + dy*dy);
    
    if((speed > kMaxSpeed) || (speedball > kMaxSpeed)){
        ball1.physicsBody.linearDamping += 0.1f;
        ball2.physicsBody.linearDamping += 0.1f;
        //ball2.physicsBody.velocity = CGVectorMake(ball2.physicsBody.velocity.dx * .9, ball2.physicsBody.velocity.dy * .9);
    } else if ((speedball < kMinSpeed) || (speed < kMinSpeed)){
        ball1.physicsBody.linearDamping -= 0.1f;
        ball2.physicsBody.linearDamping -= 0.1f;
        //ball2.physicsBody.velocity = CGVectorMake(ball2.physicsBody.velocity.dx * 1.1, ball2.physicsBody.velocity.dy * 1.1);
    } else{
        ball1.physicsBody.linearDamping = 0.0f;
        ball2.physicsBody.linearDamping = 0.0f;
    }
    NSLog(@"ball1 %f %f", ball1.position.x, ball1.position.y);
    
}

@end
