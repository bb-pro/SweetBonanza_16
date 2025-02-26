
import SpriteKit
import UIKit

class CrucialGameScene: SKScene, SKPhysicsContactDelegate {
    private var player: SKSpriteNode!
    private var leftArrow: SKSpriteNode!
    private var rightArrow: SKSpriteNode!
    private var jumpArrow: SKSpriteNode!
    private var miniGame: SKSpriteNode!
    private var wall: SKSpriteNode!
    private var candy: SKSpriteNode!
    private var backgroundImage: SKSpriteNode!
    private var cloud1: SKSpriteNode!
    private var cloud2: SKSpriteNode!
    private var cloud3: SKSpriteNode!
    private var earthGravity0: SKSpriteNode!
    private var earthGravity1: SKSpriteNode!
    private var earthGravity2: SKSpriteNode!
    private var gravityNodes: [SKSpriteNode] = []
    private var isMovingLeft = false
    private var isMovingRight = false
    private var isJumping = false
    private var isPlayerOnWall = false
    private var isPushingIntoLose = true
    weak var gameViewController: CrucialGameViewController?
    var stage: Int?
    var level: Int?
    private var rightTextures: [SKTexture] = []
    private var leftTextures: [SKTexture] = []
//    private var fallTextures: [SKTexture] = []
    var isAnimatingRight = false
    var isAnimatingLeft = false
    
    let playerCategory: UInt32 = 0x1 << 0
    let wallCategory: UInt32 = 0x1 << 1
    let earthGravityCategory: UInt32 = 0x1 << 2


    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        setupNodes()
    }
    
    private func setupNodes() {
        guard let stage = stage else { return }
        player = childNode(withName: "player") as? SKSpriteNode
        wall = childNode(withName: "wall") as? SKSpriteNode
        leftArrow = childNode(withName: "leftArrow") as? SKSpriteNode
        rightArrow = childNode(withName: "rightArrow") as? SKSpriteNode
        jumpArrow = childNode(withName: "jumpArrow") as? SKSpriteNode
        miniGame = childNode(withName: "miniGame") as? SKSpriteNode
        backgroundImage = childNode(withName: "backgroundNode") as? SKSpriteNode
        earthGravity0 = childNode(withName: "earthGravity0") as? SKSpriteNode
        earthGravity1 = childNode(withName: "earthGravity1") as? SKSpriteNode
        earthGravity2 = childNode(withName: "earthGravity2") as? SKSpriteNode
        backgroundImage.texture = SKTexture(imageNamed: "bg\(stage)")
        wall.texture = SKTexture(imageNamed: "stage\(stage)JumpingWalls")
        earthGravity0.texture = SKTexture(imageNamed: "stage\(stage)InitialBigWall")
        earthGravity1.texture = SKTexture(imageNamed: "stage\(stage)InitialNormalWall")
        earthGravity2.texture = SKTexture(imageNamed: "stage\(stage)InitialSmallWall")
        
        let rightArray = ["right1", "right2", "right3", "right4", "right5", "right6"]
        let leftArray = ["right6", "right5", "right4", "right3", "right2", "right1"]
//        let fallArray = ["fall1", "fall2", "fall3", "fall4", "fall5"]

        rightTextures = rightArray.map { SKTexture(imageNamed: $0) }
//        fallTextures = fallArray.map { SKTexture(imageNamed: $0) }
        leftTextures = leftArray.map { SKTexture(imageNamed: $0) }
        
        if stage != 0 {
            earthGravity1.removeFromParent()
            earthGravity0.size.width += earthGravity1.size.width
            earthGravity0.size.height = 420
            earthGravity2.size.height = 420
            earthGravity0.physicsBody = SKPhysicsBody(rectangleOf: earthGravity0.size)
            earthGravity0.physicsBody?.isDynamic = false
            earthGravity0.physicsBody?.contactTestBitMask = 1
        }
        
        wall.name = "wall"
        wall.position = position
        wall.setScale(0.7)
        
        wall.physicsBody = SKPhysicsBody(rectangleOf: wall.size)
        wall.physicsBody?.isDynamic = false
        wall.physicsBody?.contactTestBitMask = 1
        
        cloud1 = childNode(withName: "cloud1") as? SKSpriteNode
        cloud2 = childNode(withName: "cloud2") as? SKSpriteNode
        cloud3 = childNode(withName: "cloud3") as? SKSpriteNode

        let cloudTexture = SKTexture(imageNamed: "stage\(stage)CloudImage")
        [cloud1, cloud2, cloud3].forEach { cloud in
            cloud?.texture = cloudTexture
            switch stage {
            case 0:
                cloud?.size = CGSize(width: 943, height: 176)
            case 1:
                cloud?.size = CGSize(width: 427, height: 201)
            case 2:
                cloud?.size = CGSize(width: 330, height: 155)
            default:
                break
            }
        }
        
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = true
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.isDynamic = true
        player.physicsBody?.restitution = 0.0
        miniGame.physicsBody = SKPhysicsBody(rectangleOf: miniGame.size)
        miniGame.physicsBody?.isDynamic = false
        miniGame.physicsBody?.contactTestBitMask = 1

        let initialWall = createWall(at: CGPoint(x: frame.midX, y: frame.minY + 300), for: stage)
        addCandy(on: initialWall)

        var lastWall = initialWall
        for _ in 0..<2 {
            if let newWall = spawnStairWall(basedOn: lastWall) {
                addCandy(on: newWall)
                lastWall = newWall
            }
        }

        bringArrowsToFront()
    }
    
    private func createWall(at position: CGPoint, for stage: Int) -> SKSpriteNode {
        let newWall = wall.copy() as! SKSpriteNode
        newWall.physicsBody?.affectedByGravity = true
        newWall.name = "wall"
        newWall.position = position
//        newWall.setScale(0.7)
        
        newWall.physicsBody = SKPhysicsBody(rectangleOf: newWall.size)
        newWall.physicsBody?.isDynamic = false
        newWall.physicsBody?.contactTestBitMask = 1
        
        addChild(newWall)
        return newWall
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)

            if rightArrow.contains(location) {
                isMovingRight = true
                if !isAnimatingRight {
                    isAnimatingRight = true
                    animatePlayerMovingRight()
                }
            }
            
            if leftArrow.contains(location) {
                isMovingLeft = true
                if !isAnimatingLeft {
                    isAnimatingLeft = true
                    moveLeft()
                }
            }
            
            if jumpArrow.contains(location) {
                jump()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)

            if rightArrow.contains(location) {
                isMovingRight = false
                isAnimatingRight = false
                player.texture = SKTexture(imageNamed: "playerImage")
            }

            if leftArrow.contains(location) {
                isMovingLeft = false
                isAnimatingLeft = false
                player.texture = SKTexture(imageNamed: "playerImage")
            }
        }
        
        if !isMovingRight && !isMovingLeft {
            resetPlayerImage()
        }
    }
    
    private func countWallsAbove(_ wall: SKNode) -> Int {
        let wallsAbove = children.filter { node in
            node.name == "wall" && node.position.y > wall.position.y
        }
        return wallsAbove.count
    }

    private func highestWall() -> SKNode? {
        return children
            .filter { $0.name == "wall" }
            .max(by: { $0.position.y < $1.position.y })
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isMovingLeft {
            moveLeft()
            movePlayer(direction: -1)
        } else if isMovingRight {
            animatePlayerMovingRight()
            movePlayer(direction: 1)
        }
        
        if player.position.y < -size.height / 2 {
//            animatePlayerFalling()
            gameOver()
        }
    }
    
    private func movePlayer(direction: CGFloat) {
        let moveAction = SKAction.moveBy(x: direction * 5, y: 0, duration: 0.02)
        player.run(moveAction)
    }
    
    func jump() {
        let jumpHeight: CGFloat = 650
        let jumpUp = SKAction.moveBy(x: 0, y: jumpHeight, duration: 0.6)
        let fallDown = SKAction.moveBy(x: 0, y: -jumpHeight, duration: 0.6)
//        let fallAnimation = SKAction.animate(with: fallTextures, timePerFrame: 0.1)
        
        let resetAction = SKAction.run { [weak self] in
            self?.resetPlayerImage()
        }
        
        let jumpSequence = SKAction.sequence([jumpUp, SKAction.group([fallDown]), resetAction])
        player.run(jumpSequence, withKey: "jumping")
    }

    func didBegin(_ contact: SKPhysicsContact) {
        let contactA = contact.bodyA.node
        let contactB = contact.bodyB.node
        
        if (contactA == player && contactB?.name == "candy") || (contactB == player && contactA?.name == "candy") {
            let candyNode = (contactA?.name == "candy") ? contactA! : contactB!
            let wallNode = candyNode.parent!

            candyNode.removeFromParent()  // Remove candy after collection
            isPlayerOnWall = true
            isJumping = false

            // Check for walls above immediately
            checkAndGenerateWalls(above: wallNode)
            
            // Move walls down
            playerLanded(on: wallNode)
        }
        
        if (contactA == player && contactB == miniGame) || (contactB == player && contactA == miniGame) {
            miniGame.removeFromParent()
            stopPlayerMovement()
            gameViewController?.pauseTimer()
            
            if let earthGravity2 = earthGravity2, earthGravity2.parent != nil {
                let newYPosition = earthGravity2.position.y + earthGravity2.frame.height / 2 + player.size.height / 2 + 10
                player.position = CGPoint(x: earthGravity2.position.x, y: newYPosition)
            }
            
            if let miniGameVC = gameViewController?.storyboard?.instantiateViewController(withIdentifier: "MiniGameViewController") as? MiniGameViewController {
                gameViewController?.navigationController?.pushViewController(miniGameVC, animated: true)
            }
        }
    }
    
    func stopPlayerMovement() {
        player.physicsBody?.velocity = .zero
        player.removeAllActions()
        isMovingRight = false
        isMovingLeft = false
        isJumping = false
        player.physicsBody?.affectedByGravity = true
    }
    
    private func checkAndGenerateWalls(above wallNode: SKNode) {
        let wallsAboveCount = countWallsAbove(wallNode)

        // If fewer than 2 walls above, spawn new ones
        if wallsAboveCount < 2, let highestExistingWall = highestWall() {
            var lastWall = highestExistingWall
            for _ in wallsAboveCount..<2 {
                if let newWall = spawnStairWall(basedOn: lastWall) {
                    addCandy(on: newWall)
                    lastWall = newWall
                }
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        let contactA = contact.bodyA.node
        let contactB = contact.bodyB.node

        if (contactA == player && contactB?.name == "wall") || (contactB == player && contactA?.name == "wall") {
            isPlayerOnWall = false
        }
    }
    
    private func playerLanded(on wallNode: SKNode) {
        let distance: CGFloat = 200
        resetPlayerImage()  // <-- Reset image as soon as player lands
        isJumping = false
        run(SKAction.wait(forDuration: 0.05)) { [weak self] in
            guard let self = self else { return }
            let moveAction = SKAction.moveBy(x: 0, y: -150, duration: 0.3)
            wallNode.run(moveAction)
            self.moveAllWallsAndGravityNodesDown(by: distance, including: wallNode as! SKSpriteNode, landingWall: wallNode)
            self.bringArrowsToFront()
        }
    }

    private func addCandy(on wall: SKSpriteNode) {
        wall.childNode(withName: "candy")?.removeFromParent()

        let candyImages = ["chocolateImage", "candyImage"]
        let randomCandyImage = candyImages.randomElement()!
        if randomCandyImage == candyImages[0] {
            gameViewController?.chocolateAmount += 1
        } else {
            gameViewController?.candiesAmount += 1
        }

        let newCandy = SKSpriteNode(imageNamed: randomCandyImage)
        newCandy.name = "candy"
        newCandy.position = CGPoint(x: 0, y: wall.size.height / 2 + newCandy.size.height / 2)
        
        // Add physics body
        newCandy.physicsBody = SKPhysicsBody(rectangleOf: newCandy.size)
        newCandy.physicsBody?.isDynamic = false
        newCandy.physicsBody?.contactTestBitMask = 1

        wall.addChild(newCandy)
    }

    private func bringArrowsToFront() {
        leftArrow.zPosition = 100
        rightArrow.zPosition = 100
        jumpArrow.zPosition = 100
    }

    private func spawnStairWall(basedOn wall: SKNode) -> SKSpriteNode? {
        let newWall = wall.copy() as! SKSpriteNode
        newWall.physicsBody = SKPhysicsBody(rectangleOf: newWall.size)
        newWall.physicsBody?.isDynamic = false
        newWall.physicsBody?.contactTestBitMask = 1
        newWall.name = "wall"

        var offsetX: CGFloat = (Bool.random() ? 550 : -550)
        let newXPosition = wall.position.x + offsetX
        if newXPosition > size.width - 100 {
            offsetX = -550
        } else if newXPosition < 100 {
            offsetX = 550
        }

        newWall.position = CGPoint(
            x: max(-size.width / 2 + newWall.size.width / 2, min(size.width / 2 - newWall.size.width / 2, newXPosition)),
            y: wall.position.y + wall.frame.height
        )

        addChild(newWall)
        return newWall
    }

    private func moveAllWallsAndGravityNodesDown(by distance: CGFloat, including newWall: SKSpriteNode, landingWall: SKNode) {
        let moveDuration: TimeInterval = 0.3

        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.velocity = .zero

        let nodesToMove = children.filter { node in
            node.name == "wall" ||
            node.name == "earthGravity0" ||
            node.name == "earthGravity1" ||
            node.name == "earthGravity2" ||
            node.name == "miniGame"
        }

        print("Nodes to move down: \(nodesToMove.map { $0.name ?? "Unnamed" })")

        for node in nodesToMove {
            let moveAction = SKAction.moveBy(x: 0, y: -distance, duration: moveDuration)
            node.run(moveAction)
        }

        // Remove redundant moves for newWall and landingWall
        // They are already part of `nodesToMove`

        let movePlayer = SKAction.moveBy(x: 0, y: -distance, duration: moveDuration)
        player.run(movePlayer) {
            self.player.physicsBody?.affectedByGravity = true
            self.player.physicsBody?.isDynamic = true
        }
    }


    private func gameOver() {
        player.removeFromParent()
        if isPushingIntoLose {
            isPushingIntoLose = false
            gameViewController?.pushToWin(to: false)
        }
    }
}
extension CrucialGameScene {
    private func animatePlayerMovingRight() {
        guard !rightTextures.isEmpty else { return }
        player.size = CGSize(width: 164, height: 159)
        let animation = SKAction.animate(with: rightTextures, timePerFrame: 0.1)
        player.run(SKAction.repeatForever(animation), withKey: "movingRight")
    }

//    private func animatePlayerFalling() {
//        guard !fallTextures.isEmpty else { return }
//        
//        player.size = CGSize(width: 164, height: 159)
//        let animation = SKAction.animate(with: fallTextures, timePerFrame: 0.1)
//        
//        let resetAction = SKAction.run { [weak self] in
//            guard let self = self else { return }
//            self.player.size = CGSize(width: 143, height: 175)
//            self.player.texture = SKTexture(imageNamed: "playerImage")
//        }
//        
//        let sequence = SKAction.sequence([animation, resetAction])
//        player.run(sequence, withKey: "falling")
//    }


    func moveLeft() {
        guard !leftTextures.isEmpty else { return }
        player.size = CGSize(width: 164, height: 159)
        
        // Start left movement animation
        let leftAnimation = SKAction.animate(with: leftTextures, timePerFrame: 0.1)
        player.run(SKAction.repeatForever(leftAnimation), withKey: "movingLeft")
        
        // Move left
        let moveAction = SKAction.moveBy(x: -5, y: 0, duration: 0.1)
        player.run(SKAction.repeatForever(moveAction), withKey: "moveLeft")
    }

    private func resetPlayerImage() {
        player.size = CGSize(width: 143, height: 175)
        player.texture = SKTexture(imageNamed: "playerImage")

        // Stop all movement & animations
        player.removeAction(forKey: "movingRight")
        player.removeAction(forKey: "movingLeft")  // <-- Added
        player.removeAction(forKey: "moveLeft")
        player.removeAction(forKey: "falling")
    }
}
