# Add more folders to ship with the application, here
folder_01.source = qml/remote
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

QT += network sql
QT += sql
QTPLUGIN += qsqlite

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    AVRCommunicator.cpp \
    dbmodel.cpp \
    dbthread.cpp

# Installation path
# target.path =

# Please do not modify the following two lines. Required for deployment.
include(qtquick2applicationviewer/qtquick2applicationviewer.pri)
qtcAddDeployment()

HEADERS += \
    AVRCommunicator.h \
    dbmodel.h \
    dbthread.h \
    definition.h \
    platformios.h

OTHER_FILES += \
    qml/remote/views/SettingsSheet.qml

OBJECTIVE_SOURCES += \
    platformios.mm
