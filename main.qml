import QtQuick 2.0

Rectangle {
    id:notepadMain
    visible: true
    width: 720
    height: 480
    color:"black"
    Column{
        width:parent.width-noteList.width-10
        height: parent.height
        NoteView{
            id: noteView
            width: parent.width
            height: parent.height - messagebox.height
            noteTextSize: 25
            enabled: keypad.visible
            onNoteTitleChanged:{
                if(noteTitle!="")
                    message.text = qsTr("Note currently opened : ") + noteTitle
                else
                    message.text = qsTr("Select note to view/edit >> ")
            }
        }
        Rectangle{
            id: messagebox
            color:"#eeeeee"
            height:40
            width:parent.width

            Text{
                id: message
                height:20
                width:parent.width - 20
                text:qsTr("Select note to view/edit >> ")
                font.pixelSize: 20
                anchors.centerIn: parent
            }
        }
    }

    Item{
        anchors.right: parent.right
        height:parent.height
        width:parent.width * 0.35

        ButtonItem{
            id: addNoteButton
            color:"white"
            buttonIcon: "qrc:/images/addIcon.png"
            width:parent.width
            height:60
            onButtonPressed: {
                keypad.visible = true
            }
        }

        NoteList{
            id: noteList
            listToShow: noteManager.noteTitles

            height:parent.height-addNoteButton.height
            width:keypad.width

            onViewingNote:{
                noteView.noteTitle = noteName;
                noteView.text = noteManager.loadNote(noteName)
                keypad.visible=true
            }

            onDeleteThisNote: {
                noteView.closedNote()
                noteManager.deleteNote(whichNote)
            }

            enabled:!keypad.visible
            anchors.top: addNoteButton.bottom
        }

        Keypad{
            id:keypad
            anchors.fill:parent

            showCloseButton: true
            keyBorderColor: "#bbbbbb"

            anchors.right: parent.right
            onKeyPressed:{
                if(which===keypad.deleteSymbol)
                    noteView.deleteLastChar()
                else if(which===keypad.spaceSymbol)
                    noteView.insertChar(" ")
                else
                    noteView.insertChar(which)
            }

            onSave: {
                var noteText = noteView.text
                var addingNew = false
                if(noteView.noteTitle == ""){
                    noteView.noteTitle = noteText.substring(0,10)
                    addingNew = true
                }

                if(noteManager.saveNote(noteView.noteTitle,
                                        noteText,
                                        !(noteManager.exists(noteView.noteTitle) && addingNew)
                                        )){
                    noteView.closedNote()
                    keypad.visible = false
                }
            }

            onCancel:{
                noteView.closedNote()
                keypad.visible = false;
            }
        }

    }

    ConfirmMessageDialog{
        id: confirmSaveOverwriteDialog
        visible: false
        Connections{
            target:noteManager
            onShowConfirmSaveOverwrite:{
                confirmSaveOverwriteDialog.visible=true
            }
        }

        text:qsTr("Pre-existing note, overwrite?")
        onAcceptAction: {
            noteManager.saveNote(noteView.noteTitle, noteView.text, true)
            noteView.closedNote()
            keypad.visible = false
            confirmSaveOverwriteDialog.visible=false
        }
        onCancelAction:{
            confirmSaveOverwriteDialog.visible=false
            noteView.closedNote()
            keypad.visible = false
        }
    }
}
