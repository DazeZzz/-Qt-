import QtQuick 2.12
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import Favorite 1.0
import QtQml 2.15

Page {
    property color addFavoriteColor: "#ffffe0"
    property bool timerFlag: false

    id: addFavoritePage
    visible: true
    width: 600
    height: 540

    Rectangle {
        id: backgroundR
        color: addFavoriteColor
        anchors.fill: parent

        Rectangle {
            z: 1
            id: mainTitle                       //创建标题栏
            anchors.top: parent.top             //对标题栏定位
            anchors.left: parent.left
            anchors.right: parent.right
            height: 40                          //设置标题栏高度
            color: addFavoriteColor

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
                text: "<"
                font.pixelSize: 23
                font.bold: true
                visible: true
                id: returnButton
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                width: parent.height
                height: width
                background: Rectangle {
                    color: returnButton.pressed ? "#9c9c9c" : (returnButton.hovered ?
                                                                   (mainTitle.color == "#ffffe0" ? "#cfcfcf" : "#ffffe0") : mainTitle.color)
                }
                onClicked: {
                    addFavorite.visible = false
                    mainPage.createNewFavoritePage()
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

        Grid {
            id: grid
            rows: 2
            rowSpacing: 0
            columns: 2
            columnSpacing: 0
            anchors.top: mainTitle.bottom

            Rectangle {
                color: addFavoriteColor
                width: addFavoritePage.width / 2
                height: 280

                Dial {
                    z: 2
                    id: dial1
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
                color: addFavoriteColor
                width: addFavoritePage.width / 2
                height: 280

                Dial {
                    z: 2
                    id: dial2
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
                color: addFavoriteColor
                width: addFavoritePage.width / 2
                height: 70

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset: 10
                    text: qsTr("- 亮度 " + (dial1.value * 100).toFixed(0).toString() + " % -")
                    font.pixelSize: 19
                    font.family: "Microsoft YaHei"
                }
            }

            Rectangle {
                color: addFavoriteColor
                width: addFavoritePage.width / 2
                height: 70

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset: -10
                    text: qsTr("- 色温 " + (2700 + dial2.value * 3800).toFixed(0).toString() + " K -")
                    font.pixelSize: 19
                    font.family: "Microsoft YaHei"
                }
            }
        }

        Rectangle {
            id: name
            anchors.horizontalCenter: mainTitle.horizontalCenter
            anchors.top: grid.bottom
            color: addFavoriteColor
            width: 200
            height: 50

            TextField {
                id: nameInput
                placeholderText: qsTr("       -  名  称  -")
                placeholderTextColor: "#9C9C9C"
                selectionColor: "#9C9C9C"
                selectedTextColor: "white"
                font.pixelSize: 19
                font.family: "Microsoft YaHei"
                maximumLength: 10
                bottomPadding: -5
                selectByMouse: true

                background: Rectangle {
                    implicitWidth: 200
                    implicitHeight: 50
                    border.color: "#B5B5B5"
                    border.width: 1

                    Rectangle {
                        color: name.color
                        anchors.fill: parent
                        anchors.leftMargin: 0
                        anchors.topMargin: 0
                        anchors.rightMargin: 0
                        anchors.bottomMargin: 1
                    }
                }

                ToolTip {
                    id: toopTip
                    visible: false
                    contentItem: Text {
                        text: qsTr("请你输入名称后再添加")
                        font.family: "Microsoft YaHei"
                        color: "#4F4F4F"
                    }
                }
            }
        }

        RoundButton {
            id: button
            anchors.top: name.bottom
            anchors.topMargin: 30
            anchors.horizontalCenter: mainTitle.horizontalCenter
            hoverEnabled: true
            radius: 5
            background: Rectangle {
                property color btnColor: "#9C9C9C"
                id: buttonBackground
                implicitWidth: 200
                implicitHeight: 45
                radius: 5
                color: buttonMouseArea.pressed ? Qt.darker(btnColor, 1.2) : (button.hovered ? Qt.lighter(btnColor, 1.1) : btnColor)
            }
            contentItem: Text {
                id: buttonContent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("添  加")
                font.family: "Microsoft YaHei"
                font.pixelSize: 17
                color: "white"
            }

            MouseArea {
                id: buttonMouseArea
                anchors.fill: parent
                cursorShape: button.hovered ? Qt.PointingHandCursor : Qt.ArrowCursor

                onClicked: {
                    if (!nameInput.text)
                        toopTip.visible = true
                    else if (favorite.addFavorite(nameInput.text, (dial1.value * 100).toFixed(0).toString(), (2700 + dial2.value * 3800).toFixed(0).toString())) {
                        addSuccessTimer.start()
                    } else {
                        addFailedTimer.start()
                    }
                    afterAdd.visible = true
                    busy.running = true
                }
            }
        }

        DropShadow {
            anchors.fill: button
            verticalOffset: 3
            radius: 8.0
            samples: 17
            color: "#aa000000"
            source: button
        }
    }

    Rectangle {
        id: afterAdd
        width: 600
        height: 150
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        color: addFavoriteColor
        visible: false
    }

    BusyIndicator {
        z: 1
        id: busy
        anchors.centerIn: afterAdd
        running: false
    }

    Label {
        z: 1
        id: addLabel
        text: qsTr("添 加 成 功")
        visible: false
        anchors.centerIn: afterAdd
        font.family: "Microsoft YaHei"
        font.pixelSize: 20
    }

    Timer {
        id: addSuccessTimer
        interval: 1000
        repeat: false
        running: false
        onTriggered: {
            busy.running = false
            addLabel.text = qsTr("添 加 成 功")
            addLabel.visible = true
            addSuccessTimer2.start()
        }
    }

    Timer {
        id: addSuccessTimer2
        interval: 1500
        repeat: false
        running: false
        onTriggered: {
            addLabel.visible = false
            afterAdd.visible = false
            addFavorite.visible = false
            mainPage.createNewFavoritePage()
        }
    }

    Timer {
        id: addFailedTimer
        interval: 1000
        repeat: false
        running: false
        onTriggered: {
            busy.running = false
            addLabel.text = qsTr("该名称已存在")
            addLabel.visible = true
            addFailedTimer2.start()
        }
    }

    Timer {
        id: addFailedTimer2
        interval: 2000
        repeat: false
        running: false
        onTriggered: {
            afterAdd.visible = false
            addLabel.visible = false
        }
    }

    Favorite {
        id: favorite
    }
}
