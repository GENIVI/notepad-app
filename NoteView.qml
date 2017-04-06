import QtQuick 2.0
Rectangle{
    id: noteBackground
    property string noteTitle:""
    property alias text:note.text
    property alias noteTextSize:note.fontSize

    function closedNote(){
        noteTitle = ""
        note.text = ""
    }

    function insertChar(which){
        note.insert(note.cursorPosition, which)
    }

    function deleteLastChar(){
        note.remove(note.cursorPosition-1, note.cursorPosition)
    }

    color:"white"

    Flickable {
        id: flick
        flickableDirection:Flickable.VerticalFlick

        clip: true
        anchors.centerIn: parent

        height: noteBackground.height-20
        width: noteBackground.width

        contentWidth: note.paintedWidth
        contentHeight: note.paintedHeight


        function ensureVisible(r)
        {
            if (contentX >= r.x)
                contentX = r.x;
            else if (contentX+width <= r.x+r.width)
                contentX = r.x+r.width-width;

            if (contentY >= r.y)
                contentY = r.y;
            else if (contentY+height <= r.y+r.height)
                contentY = r.y+r.height-height;

        }

        Rectangle{
            id: editableArea
            color:"transparent"
            width: noteBackground.width
            height: noteBackground.height

            TextEdit {
                id: note
                property int fontSize:20

                width: noteBackground.width - 20
                height: noteBackground.height

                anchors.centerIn: editableArea

                focus: true
                wrapMode: TextEdit.Wrap

                cursorVisible: true
                onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)

                font.pixelSize: fontSize
            }
        }
    }
}
