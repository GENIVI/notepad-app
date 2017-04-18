#include "notemanager.h"
#include <persistence_client_library.h>
#include <persistence_client_library_key.h>
#include <NodeStateManager.h>
#include <QDebug>

const QString NoteManager::s_noteKeyID = "00#NoteKeys#00";
const QString NoteManager::s_titleDelimiter = ",";

NoteManager::NoteManager()
{

    // initialize the PCL
    unsigned int shutdownReg = PCL_SHUTDOWN_TYPE_NORMAL | PCL_SHUTDOWN_TYPE_FAST;
    pclInitLibrary("Notepad", shutdownReg);

    // load the list of note titles / keys from storage
    unsigned char buffer[2048] = {0};
    const char *keySaved = (const char*) strdup(s_noteKeyID.toLocal8Bit().constData());
    pclKeyReadData(PCL_LDBID_LOCAL, keySaved, 1, 2, buffer, 2048);
    m_noteTitleKeyList = QString((const char*) buffer).split(s_titleDelimiter);
    m_noteTitleKeyList.removeAll(QString());



}

NoteManager::~NoteManager()
{
    // de-initialize the PCL
    pclDeinitLibrary();
}

void NoteManager::finalizeWrite()
{
    // de-initialize the PCL
    pclDeinitLibrary();
}

QStringList NoteManager::noteTitles()
{
    // read in the list of note titles and extract them based on delimiter
    return m_noteTitleKeyList;
}

bool NoteManager::saveNote(QString key, QString newValue, bool overwrite)
{
    qWarning()<<"deinit9";

    // check if key already exists in the list of pre-existing
    if(!m_noteTitleKeyList.contains(key) && !key.isEmpty()){
        // if not, add to title list and update
        m_noteTitleKeyList.append(key);
        syncNoteKeys();
    }else{
        if(!overwrite){
            emit showConfirmSaveOverwrite();
            return false;
        }
    }

    // save new value
    int ret = writeValue(key, newValue);
    return ret >= 0;
}

void NoteManager::deleteNote(QString key)
{
    // check for the existence of note
    if(m_noteTitleKeyList.contains(key)){
        // if exists, remove
        m_noteTitleKeyList.removeOne(key);
        syncNoteKeys();
    }

}

QString NoteManager::loadNote(QString key)
{
    unsigned char buffer[2048] = {0};

    // check for existence of note
    if(m_noteTitleKeyList.contains(key) && !key.isEmpty()){
        // if exists, load
        const char *keySaved = (const char*) strdup(key.toLocal8Bit().constData());
        pclKeyReadData(PCL_LDBID_LOCAL, keySaved, 1, 2, buffer, 2048);
    }

    return QString((const char*) buffer);
}

bool NoteManager::exists(QString key)
{

    return m_noteTitleKeyList.contains(key);
}


void NoteManager::syncNoteKeys()
{
    QString keys = m_noteTitleKeyList.join(s_titleDelimiter);
    writeValue(s_noteKeyID, keys);
    emit noteTitlesChanged();
}

int NoteManager::writeValue(QString key, QString value)
{
    unsigned char *msg = (unsigned char*) strdup(value.toLocal8Bit().constData());
    const char *keySaved = (const char*) strdup(key.toLocal8Bit().constData());
    int ret = pclKeyWriteData(PCL_LDBID_LOCAL, keySaved, 1, 2, msg, value.length());
    return ret;
}
