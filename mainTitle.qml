import QtQuick 2.12
import QtQuick.Controls 2.15

Rectangle {

    property bool timerFlag: false

    id: mainTitle                       //创建标题栏
    anchors.top: parent.top             //对标题栏定位
    anchors.left: parent.left
    anchors.right: parent.right
    height: 40                          //设置标题栏高度

    MouseArea { //为窗口添加鼠标事件
        property point clickPos: "0,0"
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton //只处理鼠标左键
        onPressed: { //接收鼠标按下事件
            clickPos = Qt.point(mouse.x, mouse.y)
        }
        onPositionChanged: { //鼠标按下后改变位置
            var pos = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
            mainWindow.setX(mainWindow.x + pos.x)
            mainWindow.setY(mainWindow.y + pos.y)
        }
    }

    Button {
        text: "×"
        font.pixelSize: 23
        id: quitButton
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        width: parent.height
        height: width
        background: Rectangle {
            color: quitButton.pressed ? "#9c9c9c" : (quitButton.hovered ?
                   (mainTitle.color == "#ffffe0" ? "#cfcfcf" : "#ffffe0") : mainTitle.color)
        }
        onClicked: {
            mainWindow.close()
        }
    }

    Button {
        text: "－"
        font.pixelSize: 23
        id: minimizeButton
        anchors.right: quitButton.left
        anchors.bottom: parent.bottom
        width: parent.height
        height: parent.height
        background: Rectangle {
            color: minimizeButton.pressed ? "#9c9c9c" : (minimizeButton.hovered ?
                   (mainTitle.color == "#ffffe0" ? "#cfcfcf" : "#ffffe0") : mainTitle.color)
        }

        onClicked: {
            mainWindow.showMinimized()
        }
    }

    Rectangle {
        width: parent.height
        height: width
        color: mainTitle.color
        visible: timerFlag
        anchors.right: minimizeButton.left
        anchors.top: mainTitle.top

        Image {
            source: "qrc:/Image/timing.png"
            width: 20
            height: width
            anchors.centerIn: parent
            mipmap: true
        }
    }
}
