import QtQuick 2.0

Item {
    enum Direction {
        Up,
        Down,
        Left,
        Right
    }

    id: root

    property int headX: 0
    property int headY: 0
    property int speed: 1
    property real cellSize: 5
    property int direction: Snake.Direction.Up
    property int nextDirection: root.direction
    property var tail: []

    SnakeSegment {
        id: head
        size: root.cellSize
        posX: snake.headX
        posY: snake.headY
    }

    function nextHeadPosition() {
        switch (snake.nextDirection) {
        case Snake.Direction.Up:
            return { x: snake.headX, y: snake.headY-1 }
        case Snake.Direction.Down:
            return { x: snake.headX, y: snake.headY+1 }
        case Snake.Direction.Left:
            return { x: snake.headX-1, y: snake.headY }
        case Snake.Direction.Right:
            return { x: snake.headX+1, y: snake.headY }
        }
    }

    function move() {
        let nextPos = nextHeadPosition();
        root.direction = root.nextDirection

        for (let i=root.tail.length-1; i>0; i--) {
            root.tail[i].posX = root.tail[i-1].posX
            root.tail[i].posY = root.tail[i-1].posY
        }

        root.tail[0].posX = root.headX
        root.tail[0].posY = root.headY

        root.headX = nextPos.x
        root.headY = nextPos.y
    }

    function setDirection(direction) {
        switch (direction) {
        case Snake.Direction.Up:
            if (snake.direction === Snake.Direction.Down)
                return;
            break;
        case Snake.Direction.Down:
            if (snake.direction === Snake.Direction.Up)
                return;
            break;
        case Snake.Direction.Left:
            if (snake.direction === Snake.Direction.Right)
                return;
            break;
        case Snake.Direction.Right:
            if (snake.direction === Snake.Direction.Left)
                return;
            break;
        default:
            return;
        }
        snake.nextDirection = direction;
    }

    function addSegment() {
        let component = Qt.createComponent("SnakeSegment.qml");
        let segment = component.createObject(root);
        segment.posX = root.headX
        segment.posY = root.headY
        segment.size = root.cellSize
        tail.push(segment)
    }

    function contains(x,y) {
        if (head.atPosition(x,y))
            return true;
        for (let i=0; i<tail.length; i++) {
            if (tail[i].atPosition(x,y))
                return true;
        }
        return false;
    }

    function reset(headX, headY) {
        for (let i=0; i<tail.length; i++) {
            tail[i].destroy();
        }
        tail = [];
        root.direction = Snake.Direction.Up;
        root.nextDirection = Snake.Direction.Up;
        root.headX = headX;
        root.headY = headY;
        root.addSegment();
        root.addSegment();
    }

    function isCrashed() {
        for (let i=0; i<tail.length; i++) {
            if (head.posX === tail[i].posX && head.posY === tail[i].posY)
                return true;
        }
        return false;
    }
}
