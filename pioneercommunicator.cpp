#include "pioneercommunicator.h"
#include <QDebug>
#define Timeout 5000
#define RESPONSE_POWER "PWR"
#define RESPONSE_VOLUME "VOL"
#define RESPONSE_MUTE "MUT"
#define RESPONSE_INPUT "FN"
#define RESPONSE_LISTENINGMODESET "SR"
#define RESPONSE_LISTENINGMODE "LM"
#define RESPONSE_SPEAKERS "SPK"
#define RESPONSE_HDMIOUTPUT "HO"
#define RESPONSE_SBCHPROCESSING "EX"
#define RESPONSE_MCACCMEMORY "MC"
#define RESPONSE_PHASECONTROL "IS"
#define RESPONSE_TONE "TO"
#define RESPONSE_BASS "BA"
#define RESPONSE_TREBLE "TR"
#define RESPONSE_HDMIAUDIO "HA"
#define RESPONSE_TUNERPRESET "PR"
#define RESPONSE_TUNERFREQUENCY "FR"
#define RESPONSE_XM "XM"
#define RESPONSE_SIRIUS "SIR"
#define RESPONSE_AIRPLAYPRECURSOR "GBP"
#define RESPONSE_AIRPLAYDATA "GCP"
// TODO


PioneerCommunicator::PioneerCommunicator(QObject *parent) :
    QObject(parent),
    m_receiverHost(""),
    m_port(0),
    m_volume(0),
    m_mute(false),
    m_input(Unknown),
    m_connected(false),
    m_poweredOn(false)
{

    connect(this, SIGNAL(receiverHostChanged(QString)),
            this, SLOT(connectToReceiver()));

    connect(this, SIGNAL(portChanged(int)),
            this, SLOT(connectToReceiver()));

    QString ipAddress = "";
    foreach (const QHostAddress &address, QNetworkInterface::allAddresses()) {
        if (address.protocol() == QAbstractSocket::IPv4Protocol && address != QHostAddress(QHostAddress::LocalHost))
             DEBUG << address.toString();
        break;
    }
}

void PioneerCommunicator::inputCycle(bool reverse)
{
    if(!reverse)
    {
        this->sendMessage("FU\r\n");
    }
    else
    {
        this->sendMessage("FD\r\n");
    }
}


void PioneerCommunicator::connectToReceiver()
{
    if(m_receiverHost.isEmpty())
    {
        DEBUG << "receiverHost missing";
        return;
    }
    if(!m_port)
    {
        DEBUG << "port not valid";
        return;
    }
    DEBUG << "attempting to connect to" << m_receiverHost;
    if(m_socket)
    {
        m_socket->disconnectFromHost();
        m_socket->deleteLater();
    }
    m_socket = new QTcpSocket(this);
    QObject::connect(m_socket, SIGNAL(readyRead()),
                     this, SLOT(newDataAvailable()));
    QObject::connect(m_socket, SIGNAL(disconnected()),
                     this, SLOT(socketDisconnected()));
    QObject::connect(m_socket, SIGNAL(connected()),
                     this, SLOT(socketConnected()));
    m_socket->connectToHost(m_receiverHost, m_port);
}

void PioneerCommunicator::socketDisconnected()
{
    this->setConnected(false);
    this->connectToReceiver();
}

void PioneerCommunicator::socketConnected()
{
    this->sendMessage("?F\r\n");
    this->sendMessage("?P\r\n");
    this->sendMessage("?V\r\n");
    this->sendMessage("?M\r\n");
    this->setConnected(true);
}

void PioneerCommunicator::newDataAvailable()
{
    emit messageReceived();
    QString msg = QString(m_socket->readAll()).simplified();
    if(msg == "R") { return; }
    DEBUG << "Message received";
    DEBUG << msg;
    QStringList spaceSplit = msg.split(" ");
    QString value = "";
    if(msg.startsWith(RESPONSE_INPUT))
    {
        if(spaceSplit.length() > 1)
        {
            msg = spaceSplit.at(0);
        }
        value = msg.split(RESPONSE_INPUT).at(1);
        this->setInput((Input)value.toInt());
    }
    else if(msg.startsWith(RESPONSE_VOLUME))
    {
        value = msg.split(RESPONSE_VOLUME).at(1);
        int v = value.toInt();
        this->setVolume((int)floor(v/2));
    }
    else if(msg.startsWith(RESPONSE_MUTE))
    {
        value = msg.split(RESPONSE_MUTE).at(1);
        this->setMute(!((bool)value.toInt()));
    }
    else if(msg.startsWith(RESPONSE_POWER))
    {
        value = msg.split(RESPONSE_POWER).at(1);
        this->setPoweredOn(!((bool)value.toInt()));
    }
    else if(msg.startsWith((RESPONSE_AIRPLAYDATA)))
    {
        // GCP0210000"" GDP000010000100001 GEP01020"[SONG NAME]" GEP02021"[ARTIST NAME]" GEP03022"[ALBUM NAME]" GEP04000"" GEP05000"" GEP06000"" GEP07023"1:10"
        // GCP0210000"" GDP000010000100001 GEP01020"Wind Spirit" GEP02021"Bill Miller" GEP03022"The Art of Survival" GEP04000"" GEP05000"" GEP06000"" GEP07023"2:39"
        QRegExp rx("GCP0210000\"\" GDP000010000100001 GEP01020\"(.*)\" GEP02021\"(.*)\" GEP03022\"(.*)\" GEP04000\"\"");
        rx.indexIn(msg);
        QStringList albumInformation = rx.capturedTexts();
        if(!albumInformation.isEmpty())
        {
            albumInformation.removeFirst();
        }
        m_airplayNowPlayingInformation = albumInformation;
        emit airplayNowPlayingInformationChanged(m_airplayNowPlayingInformation);
    }
}

void PioneerCommunicator::sendMessage(QString str)
{
    emit messageSending();
    if (!m_socket || !m_socket->waitForConnected(Timeout)) {
        DEBUG << "failed";
        emit failedToSendMessage(str);
        return;
    }
    m_socket->write(str.toLatin1());
    DEBUG << "Message sent to receiver";
    DEBUG << str.simplified();
}
