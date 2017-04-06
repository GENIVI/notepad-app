import QtQuick 2.0


ListView{
    id:listView
    property alias listToShow:listView.model
    property int noteTitlePixelSize: 20

    signal viewingNote(string noteName)
    signal deleteThisNote(string whichNote)

    clip: true

    delegate: NoteListDelegate{
        id: noteTitleRow
        titlePixelSize: noteTitlePixelSize
        onSelectNoteToView: {
            console.log("selected note to view: " + note_name)
            viewingNote(note_name)
        }

        onDeleteNote: {
            console.log("selected note to delete: " + note_name)
            deleteThisNote(note_name)
        }

        noteName: modelData
        noteIndex:index
    }
}

