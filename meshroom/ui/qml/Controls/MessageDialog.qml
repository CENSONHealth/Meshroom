import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import MaterialIcons 2.2

Dialog {
    id: root

    property alias text: textLabel.text
    property alias detailedText: detailedLabel.text
    property alias helperText: helperLabel.text
    property alias icon: iconLabel
    property alias canCopy: copyButton.visible
    property alias preset: presets.state

    default property alias children: layout.children

    // the content of this MessageDialog as a string
    readonly property string asString: titleLabel.text + "\n\n" + text + "\n" + detailedText + "\n" + helperText + "\n"

    /// Return the text content of this dialog as a simple string.
    /// Used when copying the message in the system clipboard.
    /// Can be overridden in components extending MessageDialog
    function getAsString() {
        return asString
    }

    x: parent.width/2 - width/2
    y: parent.height/2 - height/2
    modal: true

    padding: 15
    standardButtons: Dialog.Ok

    header: Pane {
        topPadding: 6
        bottomPadding: 0
        leftPadding: 8
        rightPadding: leftPadding

        background: Item {
            // hidden text edit to perform copy in clipboard
            TextEdit {
                id: textContent
                visible: false
            }
        }

        RowLayout {
            width: parent.width
            // Icon
            Label {
                id: iconLabel
                font.family: MaterialIcons.fontFamily
                font.pointSize: 14
                visible: text != ""
            }

            Label {
                id: titleLabel
                Layout.fillWidth: true
                text: title + " - " + Qt.application.name + " " + Qt.application.version
                font.bold: true
            }
            MaterialToolButton {
                id: copyButton
                text: MaterialIcons.content_copy
                ToolTip.text: "Copy Message to Clipboard"
                font.pointSize: 11
                onClicked: {
                    textContent.text = getAsString()
                    textContent.selectAll(); textContent.copy()
                }
            }
        }
    }

    ColumnLayout {
        id: layout
        // Text
        spacing: 12
        Label {
            id: textLabel
            font.bold: true
            visible: text != ""
            onLinkActivated: Qt.openUrlExternally(link)
        }
        // Detailed text
        Label {
            id: detailedLabel
            text: text
            visible: text != ""
            onLinkActivated: Qt.openUrlExternally(link)
        }
        // Additional helper text
        Label {
            id: helperLabel
            visible: text != ""
            onLinkActivated: Qt.openUrlExternally(link)
        }
    }

    StateGroup {
        id: presets
        states: [
            State {
                name: "Info"
                PropertyChanges {
                    target: iconLabel
                    text: MaterialIcons.info
                }
            },
            State {
                name: "Warning"
                PropertyChanges {
                    target: iconLabel
                    text: MaterialIcons.warning
                    color: "#FF9800"
                }
            },
            State {
                name: "Error"
                PropertyChanges {
                    target: iconLabel
                    text: MaterialIcons.error
                    color: "#F44336"
                }
            }
        ]
    }

}
