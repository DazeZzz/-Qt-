import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.15

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 600
    height: 540
    flags: Qt.Window | Qt.FramelessWindowHint

    MainTitle {
        id: mainTitle
        color: mainPage.mainPageColor
    }

    MainPage {
        id: mainPage
        visible: true
        anchors.top: mainTitle.bottom
    }

    AdjustPage {
        id: adjustPage
        visible: false
        anchors.top: mainTitle.top
    }

    AddFavorite {
        id: addFavorite
        visible: false
        anchors.top: mainTitle.top
    }

    AddTimer {
        id: addTimer
        visible: false
        anchors.top: mainTitle.top
    }
}
