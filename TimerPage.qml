import QtQuick 2.12
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import TimerC 1.0

Page {
    property bool timerFlag: false
    property int number
    property color timerPageColor: "#ffffe0"
    property string timerId

    Component.onCompleted: {
        number = timerC.getNumber()
        if (number == 0) {
            noTimer.visible = true
            deleteButton.enabled = false
        } else {
            var array = timerC.getTimers()
            for (var i = 0; i < number; i++) {
                repeater.itemAt(i).color = i % 2 ? "#cfcfcf" : "#ffffe0"
                repeater.itemAt(i).pid = qsTr(array[i * 4])
                repeater.itemAt(i).phour = qsTr(array[i * 4 + 1])
                repeater.itemAt(i).pminute = qsTr(array[i * 4 + 2])
                repeater.itemAt(i).pflag = qsTr(array[i * 4 + 3])
                if (timerId == repeater.itemAt(i).pid)
                    repeater.itemAt(i).flag = true
            }
        }
    }

    id: timerPage
    visible: true
    width: 600
    height: 540


    Rectangle {
        z: 1
        id: timerPageMainTitle                       //创建标题栏
        anchors.top: parent.top             //对标题栏定位
        anchors.left: parent.left
        anchors.right: parent.right
        height: 40                          //设置标题栏高度
        color: swipeView.currentIndex % 2 ? "#cfcfcf" : "#ffffe0"

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
                                                               (timerPageMainTitle.color == "#ffffe0" ? "#cfcfcf" : "#ffffe0") : timerPageMainTitle.color)
            }

            onClicked: {
                timerPage.destroy()
                mainPage.visible = true
            }
        }

        Button {
            text: "＋"
            font.pixelSize: 23
            visible: true
            id: addButton
            anchors.left: returnButton.right
            anchors.bottom: parent.bottom
            width: parent.height
            height: width
            background: Rectangle {
                color: addButton.pressed ? "#9c9c9c" : (addButton.hovered ?
                                                            (timerPageMainTitle.color == "#ffffe0" ? "#cfcfcf" : "#ffffe0") : timerPageMainTitle.color)
            }

            onClicked: {
                timerPage.destroy()
                addTimer.visible = true
            }
        }

        Button {
            visible: true
            id: deleteButton
            anchors.left: addButton.right
            anchors.bottom: parent.bottom
            width: parent.height
            height: width
            background: Rectangle {
                color: deleteButton.pressed ? "#9c9c9c" : (deleteButton.hovered ?
                                                               (timerPageMainTitle.color == "#ffffe0" ? "#cfcfcf" : "#ffffe0") : timerPageMainTitle.color)
            }

            Image {
                width: 20
                height: width
                source: deleteButton.enabled ? "qrc:/Image/delete.png" : "qrc:/Image/delete2.png"
                mipmap: true
                anchors.centerIn: parent
            }

            onClicked: {
                deleteConfirm.visible = true
                timerPageMainTitle.enabled = false
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
                                                             (timerPageMainTitle.color == "#ffffe0" ? "#cfcfcf" : "#ffffe0") : timerPageMainTitle.color)
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
                                                                 (timerPageMainTitle.color == "#ffffe0" ? "#cfcfcf" : "#ffffe0") : timerPageMainTitle.color)
            }

            onClicked: {
                mainWindow.showMinimized()
            }
        }

        Rectangle {
            width: parent.height
            height: width
            color: timerPageMainTitle.color
            visible: timerFlag
            anchors.right: minimizeButton.left
            anchors.top: timerPageMainTitle.top

            Image {
                source: "qrc:/Image/timing.png"
                width: 20
                height: width
                anchors.centerIn: parent
                mipmap: true
            }
        }
    }

    SwipeView {
        id: swipeView
        currentIndex: 0
        anchors.fill: parent
        interactive: true

        Repeater {
            id: repeater
            model: number

            Rectangle {
                id: bg
                property bool flag: false
                property string pflag: "yes"
                property string pid: "ID"
                property string phour: "Hour"
                property string pminute: "Minute"

                RoundButton {
                    id: button
                    width: 150
                    height: width
                    radius: width / 2
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -30
                    background: Rectangle {
                        implicitWidth: 150
                        implicitHeight: implicitWidth
                        radius: implicitWidth / 2
                        color: bg.color == "#ffffe0" ?
                                   (button.hovered ? "#cfcfcf" : bg.color) :
                                   (button.hovered ? "#ffffe0" : bg.color)
                    }

                    onClicked: {
                        bg.flag = !bg.flag
                        if (bg.flag) {
                            for (var i = 0; i < number; i++)
                                if (i != swipeView.currentIndex)
                                    repeater.itemAt(i).flag = false
                            timerId = bg.pid
                            mainPage.timerControlT(timerId)
                            mainPage.timerBegin(bg.phour, bg.pminute, bg.pflag)
                            timerFlag = true
                        } else {
                            mainPage.timerControlF()
                            timerId = ""
                            timerFlag = false
                        }
                    }
                }

                Image {
                    id: logo
                    width: 130
                    height: width
                    source: bg.flag ? "qrc:/Image/logoColorful.png" : "qrc:/Image/logo.png"
                    mipmap: true
                    anchors.centerIn: button
                }

                Rectangle {
                    width: 235
                    height: 80
                    color: bg.color
                    anchors.horizontalCenter: button.horizontalCenter
                    anchors.top: button.bottom
                    anchors.verticalCenterOffset: 30

                    Label {
                        id: hourLabel
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        text: qsTr(bg.phour + " ")
                        font.pixelSize: 28
                        font.family: "Microsoft YaHei"
                    }

                    Label {
                        id: hourLabel1
                        anchors.left: hourLabel.right
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 3
                        text: qsTr("小时")
                        font.pixelSize: 15
                        font.family: "Microsoft YaHei"
                    }

                    Label {
                        id: minuteLabel
                        anchors.left: hourLabel1.right
                        anchors.bottom: parent.bottom
                        text: qsTr("  " + bg.pminute + " ")
                        font.pixelSize: 28
                        font.family: "Microsoft YaHei"
                    }

                    Label {
                        id: minuteLabel1
                        anchors.left: minuteLabel.right
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 3
                        text: qsTr("分钟    后")
                        font.pixelSize: 15
                        font.family: "Microsoft YaHei"
                    }

                    Label {
                        id: flagLabel
                        anchors.left: minuteLabel1.right
                        anchors.bottom: parent.bottom
                        text: bg.pflag == "yes" ? qsTr(" 开启") : qsTr(" 关闭")
                        font.pixelSize: 28
                        font.family: "Microsoft YaHei"
                    }
                }
            }
        }
    }

    Rectangle {
        id: noTimer
        z: 2
        width: 600
        height: 500
        color: "#ffffe0"
        anchors.top: timerPageMainTitle.bottom
        anchors.left: timerPageMainTitle.left
        visible: false

        Label {
            anchors.centerIn: parent
            text: qsTr("还 没 有 定 时 哦 ~")
            font.pixelSize: 25
            font.family: "Microsoft YaHei"
        }
    }

    Rectangle {
        z: 2
        id: deleteConfirm
        width: 600
        height: 400
        color: "#cfcfcf"
        anchors.centerIn: parent
        visible: false

        Image {
            id: deleteLogo
            source: "qrc:/Image/logoColorful.png"
            width: 150
            height: width
            mipmap: true
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -60
        }

        Label {
            id: deleteLabel
            text: qsTr("确 认 删 除?")
            font.family: "Microsoft YaHei"
            font.pixelSize: 25
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: deleteLogo.bottom
            anchors.topMargin: 20
        }

        Button {
            icon.source: "qrc:/Image/yes.png"
            font.pixelSize: 23
            id: yes
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            width: 300
            height: 100
            background: Rectangle {
                color: yes.pressed ? "#9c9c9c" :
                                     (yes.hovered ? "#FFFACD" : "#cfcfcf")
            }
            onClicked: {
                timerC.deleteTimer(repeater.itemAt(swipeView.currentIndex).pid)
                afterYes.visible = true
                busy.running = true
                yesTimer.start()
            }
        }

        Button {
            icon.source: "qrc:/Image/no.png"
            font.pixelSize: 23
            id: no
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            width: 300
            height: 100
            background: Rectangle {
                color: no.pressed ? "#9c9c9c" :
                                    (no.hovered ? "#FFFACD" : "#cfcfcf")
            }

            onClicked: {
                deleteConfirm.visible = false
                timerPageMainTitle.enabled = true
            }
        }
    }

    Rectangle {
        id: afterYes
        y: 300
        z: 2
        width: 600
        height: 200
        color: "#cfcfcf"
        visible: false
        anchors.left: parent.left
    }

    BusyIndicator {
        z: 3
        id: busy
        anchors.centerIn: afterYes
        anchors.verticalCenterOffset: -20
        running: false
    }

    Timer {
        id: yesTimer
        interval: 1000
        repeat: false
        running: false
        onTriggered: {
            busy.running = false
            yesLabel.visible = true
            yesTimer2.start()
        }
    }

    Timer {
        id: yesTimer2
        interval: 1500
        repeat: false
        running: false
        onTriggered: {
            mainPage.createNewTimerPage()
            timerPage.destroy()
        }
    }

    Label {
        z: 2
        id: yesLabel
        text: qsTr("删 除 成 功")
        visible: false
        anchors.centerIn: afterYes
        anchors.verticalCenterOffset: -20
        font.family: "Microsoft YaHei"
        font.pixelSize: 25
    }

    TimerC {
        id: timerC
    }
}
