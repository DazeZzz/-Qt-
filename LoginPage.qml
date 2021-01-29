import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import Login.Handler 1.0
import Register.Handler 1.0

Window {
    id: loginPage
    visible: true
    width: 570
    height: 390
    color: "transparent"
    modality: Qt.WindowModal
    title: qsTr("Very-Handsome")
    flags: Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint

    Rectangle {
        z: -2
        anchors.fill: parent
        opacity: 1

        Rectangle {
            z: 3
            id: mainTitle                       //创建标题栏
            anchors.top: parent.top             //对标题栏定位
            anchors.left: parent.left
            anchors.right: parent.right
            height: 40                          //设置标题栏高度
            color: animationBg.color                //设置标题栏背景颜色

            MouseArea { //为窗口添加鼠标事件
                property point clickPos: "0,0"
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton //只处理鼠标左键
                onPressed: { //接收鼠标按下事件
                    clickPos = Qt.point(mouse.x, mouse.y)
                }
                onPositionChanged: { //鼠标按下后改变位置
                    var pos = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
                    loginPage.setX(loginPage.x + pos.x)
                    loginPage.setY(loginPage.y + pos.y)
                }
            }

            Button {
                z: 3
                text: "<"
                font.pixelSize: 23
                font.bold: true
                visible: false
                id: returnButton
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                width: parent.height
                height: width
                background: Rectangle {
                    property color btnColor: "#9C9C9C"
                    color: returnButton.pressed ? Qt.darker(mainTitle.color, 1.2) : (returnButton.hovered ? Qt.lighter(btnColor, 1.2) : mainTitle.color)
                }

                onClicked: {
                    animationBg2.state = "beforeLogin2"
                    animationBg2.color = "white"
                    logo.state = "loginLogo"
                    logo.source = "qrc:/Image/logo.png"
                    phone.visible = false
                    accountInput.placeholderText = qsTr("账户/电话")
                    loginButtonContent.text = qsTr("登录")
                    toopTipA.contentItem.text = qsTr("请你输入账户/电话后再登录")
                    toopTipP.contentItem.text = qsTr("请你输入密码后再登录")
                    registerButton.visible = true
                    returnButton.visible = false
                    accountInput.text = ""
                    passwordInput.text = ""
                }
            }

            Button {
                z: 3
                text: "×"
                font.pixelSize: 23
                id: quitButton
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                width: parent.height
                height: parent.height
                background: Rectangle {
                    color: quitButton.pressed ? "#FF4500" : (quitButton.hovered ? "#FF4500" : mainTitle.color)
                }

                onClicked: {
                    loginPage.close()
                }
            }

            Button {
                z: 3
                text: "－"
                font.pixelSize: 23
                id: minimizeButton
                anchors.right: quitButton.left
                anchors.bottom: parent.bottom
                width: parent.height
                height: parent.height
                background: Rectangle {
                    property color btnColor: "#9C9C9C"
                    color: minimizeButton.pressed ? Qt.darker(mainTitle.color, 1.2) : (minimizeButton.hovered ? Qt.lighter(btnColor, 1.2) : mainTitle.color)
                }

                onClicked: {
                    loginPage.showMinimized()
                }
            }
        }

        Rectangle {
            z: 0
            id: animationBg
            width: 570
            height: 390
            color: "#9C9C9C"
            opacity: 1
            states: [
                State {
                    name: "beforeLogin"
                    PropertyChanges {
                        target: animationBg
                        y: -250
                    }
                },
                State {
                    name: "afterLogin"
                    PropertyChanges {
                        target: animationBg
                        y: 0
                    }
                }
            ]

            state: "beforeLogin"

            transitions: Transition {
                PropertyAnimation {
                    properties: "y"
                    duration: 1000
                    easing.type: Easing.Linear
                }
            }
        }

        Rectangle {
            z: 0
            id: animationBg2
            width: 570
            height: 390
            color: "white"
            opacity: 1
            states: [
                State {
                    name: "beforeLogin2"
                    PropertyChanges {
                        target: animationBg2
                        y: 140
                    }
                },
                State {
                    name: "afterLogin2"
                    PropertyChanges {
                        target: animationBg2
                        y: 90
                    }
                }
            ]

            state: "beforeLogin2"

            transitions: Transition {
                PropertyAnimation {
                    properties: "y"
                    duration: 400
                    easing.type: Easing.Linear
                }
            }
        }

        Image {
            z: 3
            id: logo
            source: "qrc:/Image/logo.png"
            anchors.horizontalCenter: account.horizontalCenter
            mipmap: true
            width: 100
            height: 100
            states: [
                State {
                    name: "loginLogo"
                    PropertyChanges {
                        target: logo
                        y: 85
                    }
                },
                State {
                    name: "registerLogo"
                    PropertyChanges {
                        target: logo
                        y: 35
                    }
                }
            ]

            state: "loginLogo"

            transitions: Transition {
                PropertyAnimation {
                    properties: "y"
                    duration: 400
                    easing.type: Easing.Linear
                }
            }
        }

        DropShadow {
            z: 3
            anchors.fill: logo
            horizontalOffset: 2
            verticalOffset: 2
            radius: 8.0
            samples: 17
            color: "#aa000000"
            source: logo
        }

        Rectangle {
            z: 0
            id: phone
            color: animationBg2.color
            visible: false
            anchors.left: account.left
            anchors.bottom: account.top
            width: 270
            height: 50

            Rectangle {
                id: phoneImageR
                width: 18
                height: parent.height
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                border.color: "#B5B5B5"
                border.width: 1

                Rectangle {
                    color: phone.color
                    anchors.fill: parent
                    anchors.leftMargin: 0
                    anchors.topMargin: 0
                    anchors.rightMargin: 0
                    anchors.bottomMargin: 1

                    Image {
                        id: phoneImage
                        source: "qrc:/Image/phone.png"
                        width: phoneImageR.width
                        height: phoneImageR.width
                        mipmap: true
                        anchors.centerIn: parent
                        anchors.verticalCenterOffset: 7

                        ToolTip {
                            id: toopTiphone
                            visible: false
                            contentItem: Text {
                                text: qsTr("请你输入电话后再注册")
                                font.family: "Microsoft YaHei"
                                color: "#4F4F4F"
                            }
                        }
                    }
                }
            }

            TextField {
                id: phoneInput
                placeholderText: qsTr("电话")
                placeholderTextColor: "#9C9C9C"
                selectionColor: "#9C9C9C"
                selectedTextColor: "white"
                font.pixelSize: 19
                font.family: "Microsoft YaHei"
                maximumLength: 20
                antialiasing: true
                bottomPadding: -5
                anchors.left: phoneImageR.right
                anchors.bottom: phoneImageR.bottom
                selectByMouse: true

                background: Rectangle {
                    implicitWidth: phone.width - accountImageR.width
                    implicitHeight: phone.height
                    border.color: "#B5B5B5"
                    border.width: 1

                    Rectangle {
                        color: phone.color
                        anchors.fill: parent
                        anchors.leftMargin: 0
                        anchors.topMargin: 0
                        anchors.rightMargin: 0
                        anchors.bottomMargin: 1
                    }
                }
            }
        }

        Rectangle {
            z: 1
            id: account
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 10
            color: animationBg2.color
            width: 270
            height: 50

            Rectangle {
                id: accountImageR
                width: 18
                height: parent.height
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                border.color: "#B5B5B5"
                border.width: 1

                Rectangle {
                    color: account.color
                    anchors.fill: parent
                    anchors.leftMargin: 0
                    anchors.topMargin: 0
                    anchors.rightMargin: 0
                    anchors.bottomMargin: 1

                    Image {
                        id: accountImage
                        width: 18
                        height: 18
                        source: "qrc:/Image/account.png"
                        mipmap: true
                        anchors.centerIn: parent
                        anchors.verticalCenterOffset: 7

                        ToolTip {
                            id: toopTipA
                            visible: false
                            contentItem: Text {
                                text: qsTr("请你输入账户/电话后再登录")
                                font.family: "Microsoft YaHei"
                                color: "#4F4F4F"
                            }
                        }
                    }
                }
            }

            TextField {
                id: accountInput
                placeholderText: qsTr("账户/电话")
                placeholderTextColor: "#9C9C9C"
                selectionColor: "#9C9C9C"
                selectedTextColor: "white"
                font.pixelSize: 19
                font.family: "Microsoft YaHei"
                maximumLength: 20
                bottomPadding: -5
                anchors.left: accountImageR.right
                anchors.bottom: accountImageR.bottom
                selectByMouse: true

                background: Rectangle {
                    implicitWidth: 252
                    implicitHeight: 50
                    border.color: "#B5B5B5"
                    border.width: 1

                    Rectangle {
                        color: account.color
                        anchors.fill: parent
                        anchors.leftMargin: 0
                        anchors.topMargin: 0
                        anchors.rightMargin: 0
                        anchors.bottomMargin: 1
                    }
                }
            }
        }

        Rectangle {
            z: 1
            id: password
            anchors.left: account.left
            anchors.top: account.bottom
            color: animationBg2.color
            width: 270
            height: 50

            Rectangle {
                id: passwordImageR
                width: 18
                height: parent.height
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                border.color: "#B5B5B5"
                border.width: 1

                Rectangle {
                    color: password.color
                    anchors.fill: parent
                    anchors.leftMargin: 0
                    anchors.topMargin: 0
                    anchors.rightMargin: 0
                    anchors.bottomMargin: 1

                    Image {
                        id: passwordImage
                        source: "qrc:/Image/password.png"
                        width: 18
                        height: 18
                        mipmap: true
                        anchors.centerIn: parent
                        anchors.verticalCenterOffset: 7

                        ToolTip {
                            id: toopTipP
                            visible: false
                            contentItem: Text {
                                text: qsTr("请你输入密码后再登录")
                                font.family: "Microsoft YaHei"
                                color: "#4F4F4F"
                            }
                        }
                    }
                }
            }

            TextField {
                id: passwordInput
                placeholderText: qsTr("密码")
                placeholderTextColor: "#9C9C9C"
                selectionColor: "#9C9C9C"
                selectedTextColor: "white"
                font.pixelSize: 19
                font.family: "Microsoft YaHei"
                maximumLength: 20
                bottomPadding: -5
                anchors.left: passwordImageR.right
                anchors.bottom: passwordImageR.bottom
                selectByMouse: true
                echoMode: TextInput.Password

                background: Rectangle {
                    implicitWidth: 252
                    implicitHeight: 50
                    border.color: "#B5B5B5"
                    border.width: 1

                    Rectangle {
                        color: password.color
                        anchors.fill: parent
                        anchors.leftMargin: 0
                        anchors.topMargin: 0
                        anchors.rightMargin: 0
                        anchors.bottomMargin: 1
                    }
                }
            }
        }



        RoundButton {
            z: 1
            id: loginButton
            anchors.left: account.left
            anchors.top: password.bottom
            anchors.topMargin: 40
            hoverEnabled: true
            radius: 5
            background: Rectangle {
                property color btnColor: "#9C9C9C"
                id: loginButtonBackground
                implicitWidth: account.width
                implicitHeight: account.height - 5
                radius: 5
                color: loginButtonMouseArea.pressed ? Qt.darker(btnColor, 1.2) : (loginButton.hovered ? Qt.lighter(btnColor, 1.1) : btnColor)
            }
            contentItem: Text {
                id: loginButtonContent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("登录")
                font.family: "Microsoft YaHei"
                font.pixelSize: 17
                color: "white"
            }

            MouseArea {
                id: loginButtonMouseArea
                anchors.fill: parent
                cursorShape: loginButton.hovered ? Qt.PointingHandCursor : Qt.ArrowCursor
                onClicked: phone.visible ? register() : login()

                function login() {
                    if (!accountInput.text)
                        toopTipA.visible = true
                    else if (!passwordInput.text)
                        toopTipP.visible = true
                    else {
                        animationBg.z = 2
                        animationBg.color = "#ffffe0"
                        animationBg.state = "afterLogin"
                        logo.source = "qrc:/Image/logoColorful.png"
                        loginTimer.start();
                    }
                }

                function register() {
                    if (!phoneInput.text)
                        toopTiphone.visible = true
                    else if (!accountInput.text)
                        toopTipA.visible = true
                    else if (!passwordInput.text)
                        toopTipP.visible = true
                    else {
                        returnButton.visible = false
                        animationBg.color = "#ffffe0"
                        animationBg2.color = "white"
                        animationBg2.state = "beforeLogin2"
                        logo.state = "loginLogo"
                        animationTimer2.start();
                    }
                }
            }
        }

        DropShadow {
            anchors.fill: loginButton
            verticalOffset: 3
            radius: 8.0
            samples: 17
            color: "#aa000000"
            source: loginButton
        }

        RoundButton {
            z: 1
            id: registerButton
            x: 7
            y: 353
            hoverEnabled: true
            contentItem: Text {
                text: qsTr("注册账号")
                font.family: "Microsoft YaHei"
                font.pixelSize: 14
                color: registerButton.hovered ? "#696969" : "#9C9C9C"
            }
            background: Rectangle {
                color: "transparent"
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: registerButton.hovered ? Qt.PointingHandCursor : Qt.ArrowCursor
                onClicked: {
                    animationBg.z = 0
                    animationBg2.state = "afterLogin2"
                    animationBg2.color = "#ffffe0"
                    logo.state = "registerLogo"
                    logo.source = "qrc:/Image/logoColorful.png"
                    phoneTimer.start()
                    accountInput.placeholderText = qsTr("账户名称")
                    loginButtonContent.text = qsTr("注册")
                    toopTipA.contentItem.text = qsTr("请你输入账户名称后再注册")
                    toopTipP.contentItem.text = qsTr("请你输入密码后再注册")
                    registerButton.visible = false
                    accountInput.text = ""
                    passwordInput.text = ""
                }
            }
        }

        BusyIndicator {
            z: 3
            id: busy
            anchors.top: logo.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            topPadding: 65
            running: false
        }

        Label {
            z: 3
            id: loginFailed
            text: qsTr("验 证 失 败")
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 100
            bottomPadding: 65
            font.family: "Microsoft YaHei"
            font.pixelSize: 20
            color: "transparent"
        }

        Timer {
            id: loginTimer
            interval: 1000
            repeat: false
            running: false
            onTriggered: {
                loginTimer1.start()
                busy.running = true
            }
        }

        Timer {
            id: loginTimer1
            interval: 3000
            repeat: false
            running: false
            onTriggered: {
                loginHandler.verifyAccount(accountInput.text, passwordInput.text)
            }
        }

        Timer {
            id: loginFailedTimer
            interval: 2000
            repeat: false
            running: false
            onTriggered: {
                animationBg.state = "beforeLogin"
                animationBg.color = "#9C9C9C"
                loginFailed.color = "transparent"
            }
        }

        Timer {
            id: animationTimer
            interval: 1000
            repeat: false
            running: false
            onTriggered: {
                animationBg.z = 0
                animationBg2.state = "afterLogin2"
                logo.state = "registerLogo"
                phoneTimer.start()
            }
        }

        Timer {
            id: animationTimer2
            interval: 400
            repeat: false
            running: false
            onTriggered: {
                animationBg.z = 2
                animationBg.state = "afterLogin"
                animationTimer22.start()
            }
        }

        Timer {
            id: animationTimer22
            interval: 1000
            repeat: false
            running: false
            onTriggered: {
                busy.running = true
                phone.visible = 0
                registerTimer.start()
            }
        }

        Timer {
            id: registerTimer
            interval: 3000
            repeat: false
            running: false
            onTriggered: {
                registerHandler.registerAccount(accountInput.text, phoneInput.text, passwordInput.text)
            }
        }

        Timer {
            id: registerFailedTimer
            interval: 2000
            repeat: false
            running: false
            onTriggered: {
                animationBg2.color = "#ffffe0"
                animationBg.state = "beforeLogin"
                loginFailed.color = "transparent"
                animationTimer.start()
            }
        }

        Timer {
            id: phoneTimer
            interval: 400
            repeat: false
            running: false
            onTriggered: {
                phone.visible = true
                returnButton.visible = true
            }
        }

        Timer {
            id: registerSuccessTimer
            interval: 2000
            repeat: false
            running: false
            onTriggered: {
                loader.source = "qrc:/main.qml"
                loginPage.hide()
            }
        }

        Timer {
            id: loginSuccessTimer
            interval: 2000
            repeat: false
            running: false
            onTriggered: {
                loader.source = "qrc:/main.qml"
                loginPage.hide()
            }
        }
    }

    LoginHandler {
        id: loginHandler
        onExecResult: {
            if (result) {
                busy.running = false
                loginFailed.color = "black"
                loginFailed.text = qsTr("登 录 成 功")
                loginSuccessTimer.start()
            } else {
                busy.running = false
                loginFailed.text = qsTr("验 证 失 败")
                loginFailed.color = "white"
                logo.source = "qrc:/Image/logo.png"
                animationBg.color = "#9C9C9C"
                loginFailedTimer.start()
            }
        }
    }

    RegisterHandler {
        id: registerHandler
        onExecResult: {
            if (result) {
                busy.running = false
                loginFailed.text = qsTr("注 册 成 功")
                loginFailed.color = "black"
                registerSuccessTimer.start()
            } else {
                busy.running = false
                loginFailed.text = qsTr("注 册 失 败")
                animationBg.color = "#9c9c9c"
                loginFailed.color = "white"
                registerFailedTimer.start()
            }
        }
    }

    Loader {
        id: loader
    }
}
