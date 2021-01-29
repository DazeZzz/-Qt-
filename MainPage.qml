import QtQuick 2.12
import QtQml 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.12
import QtGraphicalEffects 1.15
import Store.Status 1.0
import Favorite 1.0

Page {
    signal timerBegin(string hour, string minute, string control)
    signal timerControlT(string timerId)
    signal timerControlF()
    signal createNewFavoritePage
    signal createNewTimerPage
    property int timerTime
    property bool timerTimerControl: true
    property string timerIdM
    property bool timerFlag: false
    property color mainPageColor: mainSwitch.position == 1.0 ? "LightYellow" : "#CFCFCF"
    property bool autoFlag: false
    id: mainPage
    width: 600
    height: 500

    onCreateNewFavoritePage: {
        var compFavoritePage = Qt.createComponent("FavoritePage.qml").createObject(mainWindow, {timerFlag: mainPage.timerFlag})
    }

    onCreateNewTimerPage: {
        var compTimerPage = Qt.createComponent("TimerPage.qml").createObject(mainWindow, {timerFlag: mainPage.timerFlag,
                                                                                 timerId: mainPage.timerIdM})
    }

    onTimerControlT: {
        timerIdM = timerId
        timerFlag = true
        mainTitle.timerFlag = timerFlag
        addFavorite.timerFlag = timerFlag
        adjustPage.timerFlag = timerFlag
    }

    onTimerControlF: {
        timerFlag = false
        mainTitle.timerFlag = timerFlag
        addFavorite.timerFlag = timerFlag
        adjustPage.timerFlag = timerFlag
        timerTimer.stop()
    }

    onTimerBegin: {
        timerTimer.interval = (parseInt(hour) * 60 + parseInt(minute))* 60 * 1000
        timerTimer.start()
        if (control == "yes")
            timerTimerControl = true
        else
            timerTimerControl = false
//        console.log(timerTimer.interval)
    }

    Timer {
        id: timerTimer
        interval: 0
        repeat: false
        running: false
        onTriggered: {
            if ((timerTimerControl && (mainSwitch.position == 0)) || (!timerTimerControl && (mainSwitch.position == 1))) {
                timer1.start()
                if (mainSwitch.position == 1)
                    mainSwitch.position = 0
                else
                    mainSwitch.position = 1
            }
            timerControlF()
        }
    }

    Timer {
        id: timer1
        interval: 70
        repeat: true
        running: false
        onTriggered: {
            timer2.start()
            if (mainPageColor == "#cfcfcf") {
                mainPageColor = "#ffffe0"
                logoFlag.source = "qrc:/Image/logoColorful.png"
            }
            else {
                mainPageColor = "#cfcfcf"
                logoFlag.source = "qrc:/Image/logo.png"
            }
        }
    }

    Timer {
        id: timer2
        interval: 560
        repeat: false
        running: false
        onTriggered: {
            timer1.stop()
            mainPageColor = mainSwitch.position == 1.0 ? "LightYellow" : "#CFCFCF"
            logoFlag.source = mainSwitch.position == 1.0 ? "qrc:/Image/logoColorful.png" : "qrc:/Image/logo.png"
        }
    }

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex
        orientation: Qt.Horizontal

        Rectangle {
            id: firstPageBg
            color: mainPageColor

            Image {
                id: logoFlag
                width: 200
                height: 200
                mipmap: true
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -30
                source: mainSwitch.position == 1.0 ? "qrc:/Image/logoColorful.png" : "qrc:/Image/logo.png"
            }

            Switch {
                id: mainSwitch
                anchors.horizontalCenter: logoFlag.horizontalCenter
                anchors.top: logoFlag.bottom
                anchors.topMargin: 30
                onClicked: {
                    timer1.start()
                }
            }
        }

        Rectangle {

            Image {
                z: 3
                anchors.centerIn: parent
                width: 200
                height: 200
                mipmap: true
                source: logoFlag.source

                MouseArea {
                    hoverEnabled: false
                    anchors.fill: parent
                    onClicked: {
                    }
                }
            }

            Rectangle {
                z: 2
                anchors.centerIn: parent
                width: 170
                height: 170
                radius: 85
                color: mainSwitch.position == 0 ? "LightYellow" : "#CFCFCF"
            }

            Rectangle {
                z: 2
                anchors.centerIn: parent
                width: 5
                height: 460
                color: mainSwitch.position == 0 ? "LightYellow" : "#CFCFCF"
            }

            Rectangle {
                z: 2
                anchors.centerIn: parent
                width: 600
                height: 5
                color: mainSwitch.position == 0 ? "LightYellow" : "#CFCFCF"
            }

            Grid {
                z: 1
                anchors.centerIn: parent
                rows: 2
                columns: 2

                RoundButton {
                    id: auto_manSwitch
                    contentItem: Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                        Image {
                            width: 27.6
                            height: 50
                            anchors.centerIn: parent
                            mipmap: true
                            source: autoFlag ? "qrc:/Image/autoA.png" : "qrc:/Image/auto.png"
                        }
                    }
                    background: Rectangle {
                        implicitWidth: 300
                        implicitHeight: 230
                        color: firstPageBg.color == "#cfcfcf" ?
                                   (auto_manSwitch.pressed ? Qt.darker("#ffffe0", 1.2) : (auto_manSwitch.hovered ? "#ffffe0" : "#cfcfcf")) :
                                   (auto_manSwitch.pressed ? Qt.darker("#cfcfcf", 1.2) : (auto_manSwitch.hovered ? "#cfcfcf" : "#ffffe0" ))
                    }
                    onClicked: {
                        autoFlag = !autoFlag
                    }
                }

                RoundButton {
                    id: adjust
                    contentItem: Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                        Image {
                            width: 50
                            height: 50
                            anchors.centerIn: parent
                            mipmap: true
                            source: "qrc:/Image/adjust.png"
                        }
                    }
                    background: Rectangle {
                        implicitWidth: 300
                        implicitHeight: 230
                        color: mainPageColor == "#cfcfcf" ?
                                   (adjust.pressed ? Qt.darker("#ffffe0", 1.2) : (adjust.hovered ? "#ffffe0" : "#cfcfcf")) :
                                   (adjust.pressed ? Qt.darker("#cfcfcf", 1.2) : (adjust.hovered ? "#cfcfcf" : "#ffffe0" ))
                    }

                    onClicked: {
                        mainPage.visible = false
                        adjustPage.visible = true
                    }
                }

                RoundButton {
                    id: favorite
                    contentItem: Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                        Image {
                            width: 40
                            height: 40
                            anchors.centerIn: parent
                            mipmap: true
                            source: "qrc:/Image/favorite.png"
                        }
                    }
                    background: Rectangle {
                        implicitWidth: 300
                        implicitHeight: 230
                        color: mainPageColor == "#cfcfcf" ?
                                   (favorite.pressed ? Qt.darker("#ffffe0", 1.2) : (favorite.hovered ? "#ffffe0" : "#cfcfcf")) :
                                   (favorite.pressed ? Qt.darker("#cfcfcf", 1.2) : (favorite.hovered ? "#cfcfcf" : "#ffffe0" ))
                    }

                    onClicked: {
                        mainPage.visible = false
                        createNewFavoritePage()
                    }
                }

                RoundButton {
                    id: timing
                    contentItem: Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                        Image {
                            width: 40
                            height: 40
                            anchors.centerIn: parent
                            mipmap: true
                            source: "qrc:/Image/timing.png"
                        }
                    }
                    background: Rectangle {
                        implicitWidth: 300
                        implicitHeight: 230
                        color: mainPageColor == "#cfcfcf" ?
                                   (timing.pressed ? Qt.darker("#ffffe0", 1.2) : (timing.hovered ? "#ffffe0" : "#cfcfcf")) :
                                   (timing.pressed ? Qt.darker("#cfcfcf", 1.2) : (timing.hovered ? "#cfcfcf" : "#ffffe0" ))
                    }

                    onClicked: {
                        mainPage.visible = false
                        createNewTimerPage()
                    }
                }
            }
        }
    }

    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex

        TabButton {
            text: qsTr("Switch")
            font.family: "Microsoft YaHei"
            background: Rectangle {
                implicitHeight: 40
                color: tabBar.currentIndex == 0 ? mainPageColor : "black"
            }
        }
        TabButton {
            text: qsTr("Cortrol")
            font.family: "Microsoft YaHei"
            background: Rectangle {
                implicitHeight: 40
                color: tabBar.currentIndex == 1 ? mainPageColor : "black"
            }
        }
    }

    Loader {
        id: loader
    }

    StoreStatus {
        id: storeStatus
    }

    Favorite {
        id: favoriteC
    }
}
