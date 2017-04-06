import QtQuick 2.0

Rectangle {
    id: noteListItem

    property string noteName:""
    property int noteIndex:-1
    property int titlePixelSize:20

    signal selectNoteToView(string note_name)
    signal deleteNote(string note_name)

    color: noteIndex % 2 == 0 ? "#cccccc" : "white"


    height:80
    width:parent.width



    Item{
        id: savedItemRow

        visible:noteName!=""
        anchors.fill: parent

        Rectangle{
            id: spacer
            width:10
            height:1
            opacity:0
            anchors.verticalCenter: parent.verticalCenter

        }

        Text{
            id: noteTitle
            text: noteName
            font.pixelSize: titlePixelSize

            width:noteName!="" ? noteTitle.implicitWidth : 0

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: spacer.right
        }

        ButtonItem{
            id: deleteNoteButton
            color:"transparent"
            buttonIcon:"qrc:/images/deleteIcon.png"
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            onButtonPressed: {
                deleteNote(noteName)
            }
        }
        MouseArea{
            id: noteRowMouseArea
            height: parent.height
            width: parent.width-deleteNoteButton.width
            onClicked: selectNoteToView(noteName)
        }
    }
}
