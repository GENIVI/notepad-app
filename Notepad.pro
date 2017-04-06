TEMPLATE = app

QT += qml quick
CONFIG += c++11

SOURCES += main.cpp \
    notemanager.cpp \
    UnixSignalHandler.cpp

INCLUDEPATH += /usr/include \
                $\{DLT_INCLUDE_DIRS\}

LIBS += $\{DLT_LIBRARIES\} \


# Specify deploy path to /usr/bin
target.path = /opt/com.genivi.gdp.notepad/bin

RESOURCES += qml.qrc icons.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH += imports

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    notemanager.h \
    UnixSignalHandler.h

unix: CONFIG += link_pkgconfig
unix: PKGCONFIG += persistence_client_library
