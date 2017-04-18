import QtQuick 2.0

Rectangle {
    id:dialogBody
    property alias text: message.text

    property alias showCancelButton: cancelButton.visible
    property alias showAcceptButton: acceptButton.visible

    anchors.fill: parent
    color:"transparent"

    signal acceptAction()
    signal cancelAction()

    MouseArea{
        anchors.fill: dialogBody
    }

    Rectangle{
        id: messageDialog

        anchors.centerIn: parent

        color:"white"
        border.color: "black"
        border.width: 3
        radius: 20

        width:parent.width/2
        height: parent.height/2

        TextEdit{
            id: message
            height:messageDialog.height - buttonRow.height - 20
            width: messageDialog.width * 0.9
            enabled:false
            font.pixelSize: 20
            clip: true
            wrapMode: TextEdit.Wrap

            text:"some message"

            anchors.horizontalCenter: messageDialog.horizontalCenter
            anchors.bottom: buttonRow.top
        }

        Row{
            id:buttonRow
            height:60
            anchors.horizontalCenter: parent.horizontalCenter

            anchors.bottom: parent.bottom
            anchors.bottomMargin:  messageDialog.border.width

            ButtonItem{
                id: acceptButton
                buttonText: "ok"

                height: parent.height
                width: messageDialog.width/3

                inactiveColor: "#cac8c8"
                pressedColor: "#ffffff"

                border.width: 3
                border.color: "#eeeeee"
                radius:10

                onButtonPressed: dialogBody.acceptAction()
            }

            ButtonItem{
                id: cancelButton

                buttonText: "cancel"

                height: parent.height
                width: messageDialog.width/3

                inactiveColor: "#cac8c8"
                pressedColor: "#ffffff"

                border.width: 3
                border.color: "#eeeeee"
                radius:10

                onButtonPressed: dialogBody.cancelAction()
            }
        }
    }

}
