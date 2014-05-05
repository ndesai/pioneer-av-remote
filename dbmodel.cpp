#include "dbmodel.h"
#include <QDir>
#include <QFile>
#include <QDirIterator>
#include <QCryptographicHash>
#include <QJsonArray>
DbModel::DbModel(QQuickItem *parent) :
    QAbstractListModel(parent),
    m_status(Null),
    m_schema(QJsonObject()),
    m_mapDepth(0),
    m_jsonDbPath("")
{
    DEBUG;

    //    QFile db(DBPATH);
    //    if(!db.open(QIODevice::ReadOnly))
    //    {
    //        qDebug() << "db does not exist! creating/copying...";
    //        QFile file("assets:/qml/MyCollections/db/store.db");
    //        file.copy(DBPATH);
    //    } else
    //    {
    //        qDebug() << "Successfully opened db, hash is below:";
    //        QByteArray hashData = QCryptographicHash::hash(db.readAll(),QCryptographicHash::Md5);
    //        qDebug() << hashData.toHex();
    //    }
    //    db.close();


    connect(this, SIGNAL(nameChanged(QString)),
            this, SLOT(openDatabase()));
    connect(this, SIGNAL(schemaChanged(QJsonObject)),
            this, SLOT(buildDataTables(QJsonObject)));
}

DbModel::~DbModel()
{
    m_jsonDb.close();
}

int DbModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    QJsonObject root = m_jsonDocument.object();
    QJsonValueRef _arrayRef = root.find(m_name).value();
    QJsonArray _arrayMain = _arrayRef.toArray();
    DEBUG << _arrayMain.count();
    return _arrayMain.count();
}

QVariant DbModel::data(const QModelIndex &index, int role) const
{
    DEBUG << "index=" << index.row();
    if(index.isValid())
    {
        QHash<int, QByteArray> _roles = this->roleNames();
        QString _key = _roles.value(role);
        //        if((index.row() <= m_modelData.count() - 1) && index.row() >= 0)
        //        {
        //            QMap<QString, QString > _dataMap = m_modelData.at(index.row());
        //            return QVariant(_dataMap.value(_key));
        //        }
        QJsonObject root = m_jsonDocument.object();
        QJsonValueRef _arrayRef = root.find(m_name).value();
        QJsonArray _arrayMain = _arrayRef.toArray();
        QJsonValue val = _arrayMain.at(index.row());
        QVariantMap vm = val.toVariant().toMap();
        DEBUG << vm.value(_key);
        return QVariant(vm.value(_key));
    }
    return QVariant();
}

QHash<int, QByteArray> DbModel::roleNames() const
{
    QHash<int, QByteArray> _roles;
    _roles.insert(Qt::UserRole + 1, QByteArray("name"));
    return _roles;
}

//void DbModel::createThread(QUrl databaseFilePath)
//{
//    //    if(m_dbThread && m_dbThread->isRunning())
//    //    {
//    //        dbThreadStarted();
//    //    } else
//    //    {
//    //        // TODO set database file path
//    //        m_dbThread = new DbThread(this, databaseFilePath.toString(QUrl::RemoveScheme));
//    //        connect( m_dbThread, SIGNAL( results( const QList<QSqlRecord>& ) ),
//    //                 this, SLOT( slotResults( const QList<QSqlRecord>& ) ) );
//    //        connect( m_dbThread, SIGNAL(started()), this, SLOT(dbThreadStarted()));
//    //        m_dbThread->start();
//    //    }

//}
//void DbModel::dbThreadStarted()
//{
//    //    if(!m_query.isEmpty())
//    //    {
//    //        this->executeQuery(m_query);
//    //    }
//    //    else
//    //    {
//    //        connect(this, SIGNAL(queryChanged(QString)),
//    //                this, SLOT(executeQuery(QString)));
//    //    }
//}

void DbModel::buildDataTables(QJsonObject arg)
{
    if(m_name.isEmpty()) return;
    qDebug() << arg.value(m_name).toObject();
    //   decomposeMap(arg);
    // qDebug() << m_createData;
}

void DbModel::openDatabase()
{
    if(m_name.isEmpty()) return;
    DEBUG;
    m_jsonDbPath = BASEPATH + m_name + ".json";
    m_jsonDb.setFileName(m_jsonDbPath);
    if(!m_jsonDb.open(QIODevice::ReadWrite | QIODevice::Text))
    {
        qDebug() << "could not open" << m_jsonDbPath << "for read/write";

    } else
    {
        QByteArray _fileData = m_jsonDb.readAll();
        qDebug() << "Successfully opened db, hash is below:";
        QByteArray hashData = QCryptographicHash::hash(_fileData, QCryptographicHash::Md5);
        qDebug() << hashData.toHex();
        if(QString(hashData.toHex()) == NEWFILEHASH)
        {
            qDebug() << "DB Does not exist";
            qDebug() << "New JSON database created";
            // build basic json schema using m_name
            QString _json("{\"" + m_name + "\":[]}");
            qDebug() << "Attempting to create base schema as" << _json;
            QJsonParseError error;
            m_jsonDocument = QJsonDocument::fromJson(_json.toLatin1(), &error);
            if(QJsonParseError::NoError == error.error)
            {
                qDebug() << "Successfully created JSON document";
                QTextStream out(&m_jsonDb);
                out << m_jsonDocument.toJson();
            } else
            {
                qDebug() << "Failed to create JSON document with error = " + error.errorString();
            }
        } else
        {
            qDebug() << "JSON database already exists";
            // verify json schema with m_schema
            QJsonParseError error;
            m_jsonDocument = QJsonDocument::fromJson(_fileData, &error);
            if(QJsonParseError::NoError == error.error)
            {
                qDebug() << "Successfully built JSON document";
                qDebug() << m_jsonDocument.toJson();
            } else
            {
                qDebug() << "Failed to build JSON document with error = " + error.errorString();
            }
        }
        m_jsonDb.close();
    }
}

void DbModel::decomposeMap(QVariant arg, QString parent)
{
    QMapIterator<QString, QVariant> iterator(arg.toMap());
    while(iterator.hasNext())
    {
        iterator.next();
        qDebug() << m_mapDepth << ") " << iterator.key();
        QVariant value = iterator.value();
        switch(value.type())
        {
        case QMetaType::QVariantMap:
            qDebug() << "is a map";
            m_createData.insert(iterator.key(), QVariantMap());
            m_mapDepth++;
            decomposeMap(value, iterator.key());
            m_mapDepth--;
            break;
        case QMetaType::QString:
            qDebug() << "is a string";
            if(!parent.isEmpty())
            {
                QVariantMap val = QVariantMap(m_createData.value(parent));
                val.insert(iterator.key(), value);
                m_createData.insert(parent, val);
            }
            break;
        case QMetaType::Bool:
            qDebug() << "is a bool";
            break;
        case QMetaType::Int:
            qDebug() << "is a int";
            break;
        case QMetaType::QVariantList:
            qDebug() << "is a qvariantlist";
            if(!parent.isEmpty())
            {
                QVariantMap val = QVariantMap(m_createData.value(parent));
                val.insert(iterator.key(), QVariantList());
                m_createData.insert(parent, val);
            }
            break;
        default:
            qDebug() << "failed: is a " << value.typeName();
            break;
        }
    }
}

//void DbModel::executeQuery(QString queryStatement)
//{
//    //    executionTimer.restart();
//    //    setStatus(Loading);
//    //    m_dbThread->execute(queryStatement);
//}

//void DbModel::slotResults(const QList<QSqlRecord>& sqlRecords)
//{
//    //    {
//    //        // Clear all data and signal rows to update
//    //        int count = m_modelData.count();
//    //        beginInsertRows(QModelIndex(), 0, count - 1);
//    //        m_modelData.clear();
//    //        endInsertRows();
//    //    }
//    //    bool rolesSet = false;
//    //    QListIterator<QSqlRecord> sqlRecordsIterator(sqlRecords);
//    //    while(sqlRecordsIterator.hasNext())
//    //    {
//    //        QSqlRecord sqlRecord = sqlRecordsIterator.next();
//    //        if(!rolesSet)
//    //        {
//    //            // Set the Roles for QAbstractListModel
//    //            m_roleNames.clear();
//    //            m_roleNames = roleNames();
//    //            for(int column = 0; column < sqlRecord.count(); column++)
//    //            {
//    //                QString columnName = sqlRecord.fieldName(column);
//    //                // Create Roles with the field names
//    //                m_roleNames.insert( Qt::UserRole + 1 + column,
//    //                                    QByteArray(columnName.toAscii()));
//    //                //qDebug() << __PRETTY_FUNCTION__ << columnName;
//    //            }
//    //            rolesSet = true;
//    //            setRoleNames(m_roleNames);
//    //        }
//    //        QMap<QString,QString> dataMap;
//    //        for(int column = 0; column < sqlRecord.count(); column++)
//    //        {
//    //            dataMap.insert(sqlRecord.fieldName(column), sqlRecord.value(column).toString());
//    //        }
//    //        m_modelData.append(dataMap);
//    //    }
//    //    {
//    //        beginInsertRows(QModelIndex(), 0, m_modelData.count() - 1);
//    //        endInsertRows();
//    //        emit countChanged(getCount());
//    //        setStatus(Ready);
//    //    }
//    //    qDebug() << __PRETTY_FUNCTION__ << "Query And Populating Model took " << executionTimer.elapsed() << "ms";
//}

QVariant DbModel::get(int index)
{
    Q_UNUSED(index);
    //    if(index < 0 || index >= m_modelData.count())
    //        return QVariant();
    //    QMap<QString,QVariant> dataMap;
    //    QMapIterator<QString,QString> i(m_modelData.at(index));
    //    while(i.hasNext())
    //    {
    //        i.next();
    //        dataMap.insert(i.key(),QVariant(i.value()));
    //    }
    //    return QVariant(dataMap);
    return QVariant();
}

void DbModel::insert(QString key, QJSValue callbackFunction)
{
    if(m_name.isEmpty() || key.isEmpty() ||  m_jsonDocument.isNull())
    {
        DEBUG << "cannot insert. name is empty or json document is null";
        if(callbackFunction.isCallable())
        {
            callbackFunction.call(QJSValueList() << 1);
        }
        return;
    }
    QJsonObject root = m_jsonDocument.object();
    QJsonValueRef _arrayRef = root.find(m_name).value();
    QJsonArray _arrayMain = _arrayRef.toArray();
    QVariantMap _obj;
    _obj.insert("name", key);
    _arrayMain.append(QJsonValue::fromVariant(_obj));
    root.insert(m_name, _arrayMain);
    m_jsonDocument.setObject(root);
    qDebug() << m_jsonDocument.toJson();
    saveDatabase();
    if(callbackFunction.isCallable())
    {
        callbackFunction.call(QJSValueList() << 0);
    }
    beginInsertRows(QModelIndex(), _arrayMain.count() - 1, _arrayMain.count() - 1);
    endInsertRows();
}
void DbModel::insertObject(QVariant obj, QVariant where, QJSValue callbackFunction)
{

}

void DbModel::saveDatabase()
{
    if(m_jsonDb.open(QFile::WriteOnly | QFile::Truncate))
    {
        QTextStream out(&m_jsonDb);
        out << m_jsonDocument.toJson();
        m_jsonDb.close();
    }
}

