import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    property int spacing: 10
    id: window
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")
    color: "#606060"

    Text {
        id: title;
        x: (window.width - title.width)/2;
        y: spacing;
        text: qsTr("Web Snake");
        font.pixelSize: 32;
    }

    Text {
        id: score
        x: (window.width - score.width)/2;
        y: 2*window.spacing + title.height;
        text: board.score;
        font.pixelSize: 24;
    }

    Rectangle {
        property int availableHeight: window.height - title.height - score.height - 4*window.spacing
        property int availableWidth: window.width - 2*window.spacing
        property int cellSize: (availableWidth < availableHeight ? availableWidth : availableHeight)/boardSize
        property int rectangleSize: boardSize * cellSize
        property int boardSize: 20
        property var food: null
        property int score: 0;
        id: board
        x: (window.width - rectangleSize) / 2
        y: 3 * window.spacing + title.height + score.height
        width: rectangleSize
        height: rectangleSize
        color: "#000000"

        Timer {
            interval: 100
            running: true
            repeat: true
            onTriggered: {
                let nextPos = snake.nextHeadPosition();
                if (nextPos.x < 0 ||
                        nextPos.x >= board.boardSize ||
                        nextPos.y < 0 ||
                        nextPos.y >= board.boardSize) {
                    board.reset();
                    return;
                }
                snake.move()
                if (snake.isCrashed()) {
                    board.reset();
                    return;
                }

                if (board.food != null) {
                    if (snake.headX === board.food.posX && snake.headY === board.food.posY) {
                        board.food.destroy();
                        board.food = null;
                        board.placeFood();
                        snake.addSegment();
                        board.score++;
                    }
                }
            }
        }

        Snake {
            id: snake
            cellSize: board.cellSize
        }

        function randimize(min, max) {
            min = Math.floor(min);
            max = Math.floor(max);
            let tmp = Math.floor(Math.random()*1024*1024);
            return tmp % (max-min) + min
        }

        function placeFood() {
            while (board.food == null) {
                let x = randimize(0, board.boardSize-1);
                let y = randimize(0, board.boardSize-1);

                if (snake.contains(x,y))
                    continue;

                let component = Qt.createComponent("Food.qml");
                let food = component.createObject(board);
                food.posX = x
                food.posY = y
                food.size = board.cellSize
                board.food = food

                break;
            }
        }

        function reset() {
            if (board.food != null) {
                board.food.destroy();
                board.food = null;
            }
            board.score = 0;
            snake.reset(board.boardSize/2, board.boardSize/2);
            board.placeFood();
        }

        Component.onCompleted: {
            board.reset();
        }
    }

    Item {
        focus: true
        Keys.onUpPressed: snake.setDirection(Snake.Direction.Up)
        Keys.onDownPressed: snake.setDirection(Snake.Direction.Down)
        Keys.onLeftPressed: snake.setDirection(Snake.Direction.Left)
        Keys.onRightPressed: snake.setDirection(Snake.Direction.Right)
    }
}
