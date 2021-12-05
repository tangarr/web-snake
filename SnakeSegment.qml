import QtQuick 2.0

Rectangle {
    property int size: 10
    property int posX: 0
    property int posY: 0
    id: root
    x: root.posX*root.size
    y: root.posY*root.size
    width: root.size
    height: root.size
    color: "#ffffff"

    function atPosition(x, y) {
        return x === root.posX && y === root.posY;
    }
}
