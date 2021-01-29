import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.15

Window {
    id: splashScreen
    visible: true
    width: splashScreenImage.width
    height: splashScreenImage.height + 20
    title: qsTr("Hello World")
    flags: Qt.FramelessWindowHint

    Image {
        id: splashScreenImage
        mipmap: true
        source: "qrc:/Image/SplashScreen.png"
    }

    ProgressBar {
        id: splashScreenProgressBar
        width: splashScreenImage.width
        anchors.top: splashScreenImage.bottom
        indeterminate: true
    }

    Loader {
        id: loader
    }

    Timer {
        id: time
        interval: 5000
        repeat: false
        running: true
        onTriggered: {
            loader.source = "qrc:/LoginPage.qml"
            splashScreen.hide()
        }
    }
}
