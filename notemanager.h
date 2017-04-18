#ifndef NOTEMANAGER_H
#define NOTEMANAGER_H

#include "lifecycleconsumer.h"

#include <QGuiApplication>
#include <QObject>
#include <QQuickView>

class NoteManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList noteTitles READ noteTitles NOTIFY noteTitlesChanged)

public:
    NoteManager();
    ~NoteManager();

    
    QStringList noteTitles();

    Q_INVOKABLE bool saveNote(QString key, QString newValue, bool overwrite=false);
    Q_INVOKABLE void deleteNote(QString key);
    Q_INVOKABLE QString loadNote(QString key);
    Q_INVOKABLE bool exists(QString key);

public slots:
    void finalizeWrite();

signals:
    void noteTitlesChanged();
    void showConfirmSaveOverwrite();
    void rebooting();

private:
    LifeCycleConsumer m_lifeCycle;
    void syncNoteKeys();
    int writeValue(QString key, QString value);

    QStringList m_noteTitleKeyList;

    static const QString s_titleDelimiter;
    static const QString s_noteKeyID;

};

#endif // NOTEMANAGER_H
