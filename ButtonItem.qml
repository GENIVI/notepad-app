import QtQuick 2.0


Rectangle {
    id: buttonItem

    property alias buttonText:textItem.text
    property alias buttonIcon:iconItem.source
    property point iconSize: Qt.point(40,40)

    property string inactiveColor: "#ffffff"
    property string pressedColor: "#cac8c8"


    signal buttonPressed();

    implicitHeight: height
    implicitWidth:  width

    height:60
    width:60

    color: buttonMouseArea.pressed ? pressedColor : inactiveColor

    Row{
        anchors.centerIn: buttonItem

        height:Math.max(iconItem.height, textItem.height)
        width:iconItem.width + textItem.width

        Image{
            id: iconItem
            width:iconItem.source=="" ? 0 : iconSize.x
            height:iconItem.source=="" ? 0 : iconSize.y
        }

        Rectangle{
            id: spacer
            width:iconItem.width!=0 ? 10 : 0
            height:1
            opacity: 0
        }

        Text{
            id: textItem
            font.pixelSize: 20
            width:text=="" ? 0 : textItem.implicitWidth
            height:text=="" ? 0 : textItem.implicitHeight
            text:""
            anchors.verticalCenter:  parent.verticalCenter
        }

    }
    MouseArea{
        id: buttonMouseArea
        anchors.fill: buttonItem
        onClicked: {
            buttonPressed()
            console.log("Keypressed: " + textItem.text + " -height " + buttonItem.height)
        }

    }
}
