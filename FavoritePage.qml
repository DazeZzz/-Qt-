import QtQuick 2.12
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import Favorite 1.0

Page {
    property color favoritePageColor: "#ffffe0"
    property int number
    property bool timerFlag: false

    Component.onCompleted: {
        number = favoriteC.getNumber()
        if (number == 0) {
            noFavorite.visible = true
            deleteButton.enabled = false
        }
        else {
            var fname = favoriteC.getFavoriteName()
            var array = favoriteC.getFavorites()
            for (var i = 0; i < number; i++) {
                repeater.itemAt(i).color = i % 2 ? "#cfcfcf" : "#ffffe0"
                repeater.itemAt(i).pname = qsTr(array[i * 3])
                repeater.itemAt(i).pluminance = qsTr(array[i * 3 + 1])
                repeater.itemAt(i).pcolorTemperature = qsTr(array[i * 3 + 2])
                if (array[i * 3] == fname)
                    repeater.itemAt(i).flag = true
                console.log(fname)
            }
        }
    }

    id: favoritePage
    visible: true
    width: 600
    height: 540


    Rectangle {
        z: 1
        id: favoriteMainTitle                       //创建标题栏
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
                                                               (favoriteMainTitle.color == "#ffffe0" ? "#cfcfcf" : "#ffffe0") : favoriteMainTitle.color)
            }

            onClicked: {
                favoritePage.destroy()
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
                                                            (favoriteMainTitle.color == "#ffffe0" ? "#cfcfcf" : "#ffffe0") : favoriteMainTitle.color)
            }

            onClicked: {
                favoritePage.destroy()
                addFavorite.visible = true
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
                                                               (favoriteMainTitle.color == "#ffffe0" ? "#cfcfcf" : "#ffffe0") : favoriteMainTitle.color)
            }

            Image {
                width: 20
                height: width
                source: favoriteMainTitle.enabled ? "qrc:/Image/delete.png" : "qrc:/Image/delete2.png"
                mipmap: true
                anchors.centerIn: parent
            }

            onClicked: {
                deleteConfirm.visible = true
                favoriteMainTitle.enabled = false
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
                                                             (favoriteMainTitle.color == "#ffffe0" ? "#cfcfcf" : "#ffffe0") : favoriteMainTitle.color)
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
                                                                 (favoriteMainTitle.color == "#ffffe0" ? "#cfcfcf" : "#ffffe0") : favoriteMainTitle.color)
            }

            onClicked: {
                mainWindow.showMinimized()
            }
        }

        Rectangle {
            width: parent.height
            height: width
            color: favoriteMainTitle.color
            visible: timerFlag
            anchors.right: minimizeButton.left
            anchors.top: favoriteMainTitle.top

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
                property string pname: "NAME"
                property string pluminance: "Luminance"
                property string pcolorTemperature: "ColorTemperature"

                RoundButton {
                    id: button
                    width: 150
                    height: width
                    radius: width / 2
                    anchors.bottom: name.top
                    anchors.horizontalCenter: name.horizontalCenter
                    anchors.bottomMargin: 50
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
                            favoriteC.clearFavoriteName()
                            favoriteC.storeFavoriteName(pname)
                        } else
                            favoriteC.clearFavoriteName()
                        adjustPage.favoriteMode(pluminance, pcolorTemperature)
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

                Label {
                    id: name
                    text: parent.pname
                    font.pixelSize: 30
                    font.family: "Microsoft YaHei"
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: 90
                }

                Row {
                    anchors.top: name.bottom
                    anchors.horizontalCenter: name.horizontalCenter
                    anchors.topMargin: 20
                    spacing: 20

                    Rectangle {
                        color: bg.color
                        width: 200
                        height: 50
                        Label {
                            id: luminance
                            anchors.centerIn: parent
                            text: qsTr("- 亮度：" + bg.pluminance + " % -")
                            font.pixelSize: 20
                            font.family: "Microsoft YaHei"
                        }
                    }

                    Rectangle {
                        color: bg.color
                        width: 200
                        height: 50
                        Label {
                            id: colorTemperature
                            anchors.centerIn: parent
                            text: qsTr("- 色温：" + bg.pcolorTemperature + " K -")
                            font.pixelSize: 20
                            font.family: "Microsoft YaHei"
                        }
                    }
                }
            }
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
                favoriteC.deleteFavorite(repeater.itemAt(swipeView.currentIndex).pname)
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
                favoriteMainTitle.enabled = true
            }
        }
    }

    Rectangle {
        id: noFavorite
        z: 2
        width: 600
        height: 500
        color: "#ffffe0"
        anchors.top: favoriteMainTitle.bottom
        anchors.left: favoriteMainTitle.left
        visible: false

        Label {
            anchors.centerIn: parent
            text: qsTr("还 没 有 收 藏 哦 ~")
            font.pixelSize: 25
            font.family: "Microsoft YaHei"
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
            mainPage.createNewFavoritePage()
            favoritePage.destroy()
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

    Favorite {
        id: favoriteC
    }
}
