import Foundation
import UIKit

var barriers: [Shape] = []
var targets: [Shape] = []

let ball = OvalShape(width: 40, height: 40)

let funnelPoints = [
    Point(x: 0, y: 50),
    Point(x: 80, y: 50),
    Point(x: 60, y: 0),
    Point(x: 20, y: 0)
]

let funnel = PolygonShape(points: funnelPoints)

// Handles collisions between the ball and the targets.
func ballCollided(with otherShape: Shape) {
    if otherShape.name != "target" { return }
    otherShape.fillColor = .green
}

fileprivate func setupBall() {
    ball.position = Point(x: 250, y: 400)
    scene.add(ball)
    ball.hasPhysics = true
    ball.fillColor = .green
    ball.onCollision = ballCollided(with:)
    scene.trackShape(ball)
    ball.onExitedScene = ballExitedScene
    ball.onTapped = resetGame
    ball.bounciness = 0.6
}
/// Add a barrier to the scene.
fileprivate func addBarrier(at position: Point, width: Double, height: Double, angle: Double) {
    let barrierPoints = [
        Point(x: 0, y: 0),
        Point(x: 0, y: height),
        Point(x: width, y: height),
        Point(x: width, y: 0)
    ]
    
    let barrier = PolygonShape(points:
        barrierPoints)
    
    barriers.append(barrier)
    barrier.position = position
    barrier.hasPhysics = true
    barrier.isImmobile = true
    barrier.fillColor = .init(red: 211, green: 211, blue: 211, alpha: 0.5)
    barrier.angle = angle
    scene.add(barrier)
}

fileprivate func setupfunnel() {
    funnel.position = Point(x: 200,
                            y: scene.height - 25)
    funnel.fillColor = .green
    /// Add a funnel to the scene.
    scene.add(funnel)
    funnel.onTapped = dropBall
    ball.isDraggable = false
}

func addTarget(at position: Point) {
    let targetPoints = [
        Point(x: 10, y: 0),
        Point(x: 0, y: 10),
        Point(x: 10, y: 20),
        Point(x: 20, y: 10)
    ]

    let target = PolygonShape(points:
       targetPoints)

    targets.append(target)
    target.position = position
    target.hasPhysics = true
    target.isImmobile = true
    target.isImpermeable = false
    target.fillColor = .yellow
    target.name = "target"
    scene.add(target)
    //ball.isDraggable = false
}

/// Drops the ball by moving it to the funnel's  position.
func dropBall() {
    ball.position = funnel.position
    ball.stopAllMotion()

    for barrier in barriers {
        barrier.isDraggable = false
    }
    for target in targets {
        target.fillColor = .yellow
    }
}
func alertDismissed() {
}
func ballExitedScene() {
    for barrier in barriers {
            barrier.isDraggable = true
        }
    var hitTargets = 0
    for target in targets {
        if target.fillColor == .green {
            hitTargets += 1
        }
    }
    if hitTargets == targets.count {
        print("Won game!")
    }
    if hitTargets == 5{
        scene.presentAlert(text: "You won!",
       completion: alertDismissed)
    }
}

/// Resets the game by moving the ball below the scene,which will unlock the barriers.
func resetGame() {
    ball.position = Point(x: 0, y: -80)
}

func printPosition(of shape: Shape) {
    print(shape.position)
}

func setup() {
    setupBall()
    addBarrier(at: Point(x: 175, y: 100), width: 80,
               height: 25, angle: 0.1)
    addBarrier(at: Point(x: 100, y: 150), width: 40,
               height: 15, angle: -0.2)
    addBarrier(at: Point(x: 325, y: 150), width: 100,
               height: 25, angle: 0.3)
    addTarget(at: Point(x: 184, y: 563))
    addTarget(at: Point(x: 238, y: 624))
    addTarget(at: Point(x: 269, y: 453))
    addTarget(at: Point(x: 213, y: 348))
    addTarget(at: Point(x: 113, y: 267))
    setupfunnel()
    resetGame()
    scene.onShapeMoved = printPosition(of:)
}



