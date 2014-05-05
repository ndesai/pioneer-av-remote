#include "dbthread.h"



// Configure runtime parameters here
#define DATABASE_USER "magdalena"
#define DATABASE_PASS "deedee"
#define DATABASE_NAME "asynchdbtest.db"
#define DATABASE_HOST ""
#define DATABASE_DRIVER "QSQLITE"
#define SAMPLE_RECORDS 100000


class DbWorker : public QObject
{
  Q_OBJECT

   public:
    DbWorker( QObject* parent = 0, QString databasePath = "");
    ~DbWorker();

  public slots:
    void slotExecute( const QString& query );

signals:
  void results( const QList<QSqlRecord>& records );

   private:
     QSqlDatabase m_database;
};

//

DbWorker::DbWorker( QObject* parent, QString databasePath )
    : QObject( parent )
{
    // thread-specific connection, see db.h
    QUuid uuid = QUuid::createUuid();
    m_database = QSqlDatabase::addDatabase( DATABASE_DRIVER, uuid.toString());
    m_database.setDatabaseName(databasePath);

    if (!m_database.open())
    {
        qDebug() << "Unable to connect to database, giving up:" << m_database.lastError().text();
        return;
    }
}

DbWorker::~DbWorker()
{
    m_database.close();
}

void DbWorker::slotExecute( const QString& query )
{
    QList<QSqlRecord> recs;
    QSqlQuery sql(query, m_database);
    //sql.setForwardOnly(true);
    while(sql.next())
    {
        recs.push_back(sql.record());
    }
    qDebug() << Q_FUNC_INFO << "query is\"" << query << "\"and records count is" << recs.count();
    emit results(recs);
}


// DbThread
DbThread::DbThread(QObject *parent, QString databaseFilePath) :
    QThread(parent)
{
    m_databaseFilePath = databaseFilePath;
}

DbThread::~DbThread()
{
    delete m_worker;
}

void DbThread::execute(const QString &query)
{
    emit executefwd(query);
}

void DbThread::run()
{
    emit ready(false);
    emit progress("DbThread is starting..one moment please..");

    m_worker = new DbWorker(0, m_databaseFilePath);

    connect( this, SIGNAL( executefwd( const QString& ) ),
             m_worker, SLOT( slotExecute( const QString& ) ) );

    qRegisterMetaType< QList<QSqlRecord> >( "QList<QSqlRecord>" );

    // forward final signal
    connect( m_worker, SIGNAL( results( const QList<QSqlRecord>& ) ),
             this, SIGNAL( results( const QList<QSqlRecord>& ) ) );



    emit progress( "Press 'Go' to run a query." );
    emit ready(true);

    exec();  // our event loop

}

#include "dbthread.moc"
