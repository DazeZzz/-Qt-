import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.15
import Store.Status 1.0

Page {
    signal favoriteMode(string lum, string cotp)
    property color adjustPageColor: "#ffffe0"
    property double luminance
    property double colorTemperature
    property bool timerFlag: false

    onFavoriteMode: {
        dial1.value = parseFloat(lum) / 100
        dial2.value = (parseFloat(cotp) - 2700) / 3800
        console.log(cotp)
    }

    id: adjustPage
    visible: true
    width: 600
    height: 540

    Component.onCompleted: {
        luminance = storeStatus.getLuminance()
        colorTemperature = storeStatus.getColorTemperature()
    }

    Component.onDestruction: {
        storeStatus.storeStatus(dial1.value, dial2.value)
    }

    Rectangle {
        id: adjustMainTitle                       //创建标题栏
        anchors.top: parent.top             //对标题栏定位
        anchors.left: parent.left
        anchors.right: parent.right
        color: adjustPageColor
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
                       (adjustMainTitle.color == "#ffffe0" ? "#cfcfcf" : "#ffffe0") : adjustMainTitle.color)
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
                       (adjustMainTitle.color == "#ffffe0" ? "#cfcfcf" : "#ffffe0") : adjustMainTitle.color)
            }

            onClicked: {
                mainWindow.showMinimized()
            }
        }

        Rectangle {
            width: parent.height
            height: width
            color: adjustMainTitle.color
            visible: timerFlag
            anchors.right: minimizeButton.left
            anchors.top: adjustMainTitle.top

            Image {
                source: "qrc:/Image/timing.png"
                width: 20
                height: width
                anchors.centerIn: parent
                mipmap: true
            }
        }

        Button {
            id: returnButton
            text: "<"
            font.pixelSize: 23
            font.bold: true
            visible: true
            anchors.left: parent.left
            anchors.top: parent.top
            width: parent.height
            height: parent.height
            background: Rectangle {
                color: returnButton.pressed ? "#9c9c9c" : (returnButton.hovered ?
                       (adjustMainTitle.color == "#ffffe0" ? "#cfcfcf" : "#ffffe0") : adjustMainTitle.color)
            }

            onClicked: {
                adjustPage.visible = false
                mainPage.visible = true
            }
        }
    }

    Grid {
        rows: 2
        rowSpacing: 0
        columns: 2
        columnSpacing: 0
        anchors.top: adjustMainTitle.bottom

        Rectangle {
            color: adjustPageColor
            width: adjustPage.width / 2
            height: adjustPage.height * 0.7

            Dial {
                z: 2
                id: dial1
                value: luminance
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: 10
                anchors.verticalCenterOffset: 10
            }

            Image {
                z: 3
                source: dial1.pressed ? "qrc:/Image/logoColorful.png" : "qrc:/Image/logo.png"
                width: 135
                anchors.centerIn: dial1
                height: width
                mipmap: true
            }

            Rectangle {
                z: 1
                width: 184
                height: width
                radius: width / 2
                anchors.centerIn: dial1
                color: dial1.hovered ? "#ffffe0" : "#cfcfcf"
            }
        }

        Rectangle {
            color: adjustPageColor
            width: adjustPage.width / 2
            height: adjustPage.height * 0.7

            Dial {
                z: 2
                id: dial2
                value: colorTemperature
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: -10
                anchors.verticalCenterOffset: 10
            }

            Image {
                z: 3
                source: dial2.pressed ? "qrc:/Image/logoColorful.png" : "qrc:/Image/logo.png"
                width: 135
                anchors.centerIn: dial2
                height: width
                mipmap: true
            }

            Rectangle {
                z: 1
                width: 184
                height: width
                radius: width / 2
                anchors.centerIn: dial2
                color: dial2.hovered ? "#ffffe0" : "#cfcfcf"
            }
        }

        Rectangle {
            color: adjustPageColor
            width: adjustPage.width / 2
            height: adjustPage.height * 0.3

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: 10
                text: qsTr("- 亮度 " + (dial1.value * 100).toFixed(0).toString() + " % -")
                font.pixelSize: 19
                font.family: "Microsoft YaHei"
            }
        }

        Rectangle {
            color: adjustPageColor
            width: adjustPage.width / 2
            height: adjustPage.height * 0.3

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: -10
                text: qsTr("- 色温 " + (2700 + dial2.value * 3800).toFixed(0).toString() + " K -")
                font.pixelSize: 19
                font.family: "Microsoft YaHei"
            }
        }
    }

    StoreStatus {
        id: storeStatus
    }
}

