#ifndef DBMODEL_H
#define DBMODEL_H
#include <QAbstractListModel>
#include <QQuickItem>
#include <QJSValue>
#include <QDebug>
#include <QUrl>
#include <QSqlDatabase>
#include <QStringList>
#include <QSqlError>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QMap>
#include <QTime>
#include <QMapIterator>
#include <QJsonObject>
#include <QJsonDocument>
#include "dbthread.h"
#include "definition.h"
class DbModel : public QAbstractListModel
{
    Q_OBJECT
    Q_ENUMS(Status)
    Q_PROPERTY(Status status READ getStatus WRITE setStatus NOTIFY statusChanged)
    Q_PROPERTY(QString name READ getName WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QJsonObject schema READ getSchema WRITE setSchema NOTIFY schemaChanged)
    Q_PROPERTY(QVariant sampleObject READ getSampleObject WRITE setSampleObject NOTIFY sampleObjectChanged)
public:
    explicit DbModel(QQuickItem *parent = 0);
    ~DbModel();
    Q_INVOKABLE QVariant get(int index);
    enum Status {
        Null,
        Ready,
        Loading,
        Error
    };

    QString getName() const
    {
        return m_name;
    }
    Q_INVOKABLE void testCallback(QJSValue fn)
    {
        if(fn.isCallable())
        {
            fn.call(QJSValueList() << 42 << 32);
        }
    }
    Q_INVOKABLE void insert(QString key, QJSValue callbackFunction);
    Q_INVOKABLE void insertObject(QVariant obj, QVariant where, QJSValue callbackFunction);

    Status getStatus() const
    {
        return m_status;
    }

    QJsonObject getSchema() const
    {
        return m_schema;
    }

    QVariant getSampleObject() const
    {
        return m_sampleObject;
    }

signals:
    void nameChanged(QString arg);

    void statusChanged(Status arg);

    void schemaChanged(QJsonObject arg);

    void sampleObjectChanged(QVariant arg);

public slots:
    void setName(QString arg)
    {
        if (m_name != arg) {
            m_name = arg;
            emit nameChanged(arg);
        }
    }
    void setStatus(Status arg)
    {
        if (m_status != arg) {
            m_status = arg;
            emit statusChanged(arg);
        }
    }
    void setSchema(QJsonObject arg)
    {
        if (m_schema != arg) {
            m_schema = arg;
            emit schemaChanged(arg);
        }
    }

    void setSampleObject(QVariant arg)
    {
        if (m_sampleObject != arg) {
            m_sampleObject = arg;
            emit sampleObjectChanged(arg);
        }
    }

private slots:
//    void createThread(QUrl);
//    void executeQuery(QString);
//    void slotResults( const QList<QSqlRecord>& );
//    void dbThreadStarted();
    void buildDataTables(QJsonObject arg);
    void openDatabase();
private:
    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;
    QSqlDatabase m_db;
    QHash<int, QByteArray> m_roleNames;
    QList< QMap<QString, QString > > m_modelData;
    DbThread *m_dbThread;
    QTime executionTimer;
    QString m_name;
    Status m_status;
    QJsonObject m_schema;
    int m_mapDepth;
    QMap<QString, QVariantMap > m_createData;
    void decomposeMap(QVariant arg, QString parent = "");
    QString m_jsonDbPath;
    QFile m_jsonDb;
    QJsonDocument m_jsonDocument;
    void saveDatabase();
    QVariant m_sampleObject;
};

#endif // DBMODEL_H
