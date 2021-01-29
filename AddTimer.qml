import QtQuick 2.12
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQml 2.15
import TimerC 1.0

Page {
    property color addTimerColor: "#ffffe0"
    property bool timerFlag: false
    property int number

    id: addTimerPage
    visible: true
    width: 600
    height: 540

    Component.onCompleted: {
        var numberC = timerC.getNumber()
        var array = timerC.getTimers()
        number = parseInt(array[numberC * 4 - 4]) + 1
    }

    Rectangle {
        color: addTimerColor
        anchors.fill: parent

        Rectangle {
            z: 1
            id: mainTitle                       //创建标题栏
            anchors.top: parent.top             //对标题栏定位
            anchors.left: parent.left
            anchors.right: parent.right
            height: 40                          //设置标题栏高度
            color: addTimerColor

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
                    addTimerPage.visible = false
                    mainPage.createNewTimerPage()
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
    }

    Rectangle {
        id: rect
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -40
        width: frame.implicitWidth
        height: frame.implicitHeight
        color: "transparent"

        function formatText(count, modelData) {
            var data = count === 12 ? modelData + 1 : modelData
            return data.toString().length < 2 ? "0" + data : data
        }

        Component {
            id: delegateComponent
            Label {
                text: rect.formatText(Tumbler.tumbler.count, modelData)
                opacity: 0.4 + (1 - Math.abs(Tumbler.displacement)) * 0.6
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 25
                font.family: "Microsoft YaHei"
            }
        }

        Frame {
            id: frame
            padding: 30
            anchors.centerIn: parent

            Row {
                spacing: 10

                id: row
                Tumbler {
                    id: hoursTumbler
                    model: 24
                    delegate: delegateComponent
                }

                Tumbler {
                    id: minutesTumbler
                    model: 60
                    delegate: delegateComponent
                }
            }
        }
    }

    Switch {
        id: switchs
        anchors.top: rect.bottom
        anchors.horizontalCenter: rect.horizontalCenter
        anchors.topMargin: 30
    }

    RoundButton {
        id: button
        anchors.top: switchs.bottom
        anchors.topMargin: 30
        anchors.horizontalCenter: switchs.horizontalCenter
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
                if (timerC.addTimer(number, hoursTumbler.currentItem.text, minutesTumbler.currentItem.text,
                                    switchs.position == 1 ? "yes" : "no")) {
                    number++
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

    TimerC {
        id: timerC
    }

    Rectangle {
        id: afterAdd
        width: 600
        height: 150
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        color: addTimerColor
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
            addTimerPage.visible = false
            mainPage.createNewTimerPage()
        }
    }

    Timer {
        id: addFailedTimer
        interval: 1000
        repeat: false
        running: false
        onTriggered: {
            busy.running = false
            addLabel.text = qsTr("添 加 失 败")
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
}
