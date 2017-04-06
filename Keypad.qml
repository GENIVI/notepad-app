import QtQuick 2.0

Rectangle {
    id: keypad

    property string spaceSymbol:"[_]"
    property string deleteSymbol:"<<"
    readonly property var keys:["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", spaceSymbol, deleteSymbol ]

    property alias showCloseButton:exitSaveRow.visible
    property alias keyBorderColor:keypad.color

    signal keyPressed(variant which)
    signal save()
    signal cancel()

    visible: false
    color:"black"
    Column{
        Grid{
            id:keypadGrid

            height:(keypad.height-exitSaveRow.height)
            width: keypad.width

            columns: 3
            columnSpacing:2

            rows: 4
            rowSpacing:2

            Repeater{
                model: keys
                ButtonItem{
                    id: key
                    height:keypadGrid.height/keypadGrid.rows
                    width: keypadGrid.width/keypadGrid.columns

                    onButtonPressed: {
                        keyPressed(modelData)
                        console.log("Keypressed: " + modelData )
                    }

                    buttonText: modelData
                }
            }
        }

        Row{
            id:exitSaveRow

            visible:true

            height:showCloseButton ? 60 : 0
            width:keypad.width

            ButtonItem{
                id: saveButton
                width:exitSaveRow.width / 2

                buttonText:qsTr("Save")

                onButtonPressed: {
                    save()
                }
            }

            ButtonItem{
                id: closeKey

                width:exitSaveRow.width / 2

                buttonText: qsTr("Exit")
                onButtonPressed: {
                    cancel()
                }
            }
        }
    }
}
