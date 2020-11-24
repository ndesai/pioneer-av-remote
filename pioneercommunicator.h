#ifndef PIONEERCOMMUNICATOR_H
#define PIONEERCOMMUNICATOR_H
#include <QObject>
#include <QtNetwork>
#include <QtCore/qmath.h>
#include "definition.h"
class PioneerCommunicator : public QObject
{
    Q_OBJECT
    Q_ENUMS(Input)
    Q_PROPERTY(QString receiverHost READ receiverHost WRITE setReceiverHost NOTIFY receiverHostChanged)
    Q_PROPERTY(int port READ port WRITE setPort NOTIFY portChanged)
    Q_PROPERTY(int volume READ volume WRITE setVolume NOTIFY volumeChanged)
    Q_PROPERTY(bool mute READ mute WRITE setMute NOTIFY muteChanged)
    Q_PROPERTY(Input input READ input WRITE setInput NOTIFY inputChanged)
    Q_PROPERTY(bool connected READ connected WRITE setConnected NOTIFY connectedChanged)
    Q_PROPERTY(bool poweredOn READ poweredOn WRITE setPoweredOn NOTIFY poweredOnChanged)
    Q_PROPERTY(QStringList airplayNowPlayingInformation READ airplayNowPlayingInformation NOTIFY airplayNowPlayingInformationChanged)

public:
    explicit PioneerCommunicator(QObject *parent = 0);
    enum Input {
        Unknown = -1,
        DVD = 4,
        BD = 25,
        TVSAT = 5,
        SATCBL = 6,
        DVRBDR = 15,
        VIDEO = 10,
        VIDEO2 = 14,
        HDMI1 = 19,
        HDMI2 = 20,
        HDMI3 = 21,
        HDMI4 = 22,
        HDMI5 = 23,
        INTERNETRADIO = 26,
        IPODUSB = 17,
        XMRADIO = 18,
        CD = 1,
        CDRTAPE = 3,
        TUNER = 2,
        PHONO = 0,
        MUTLICHIN = 12,
        ADAPTERPORT = 33,
        SIRIUS = 27,
        HDMICYCLIC = 31,
        AIRPLAY = 46,
        FAVORITE = 45,
        MEDIASERVER = 44,
        PANDORA = 41,
        NETRADIO = 38,
        GAME = 49
    };


    Q_INVOKABLE void inputCycle(bool reverse = false);

    QString receiverHost() const
    {
        return m_receiverHost;
    }

    quint16 port() const
    {
        return m_port;
    }

    int volume() const
    {
        return m_volume;
    }

    bool mute() const
    {
        return m_mute;
    }

    Input input() const
    {
        return m_input;
    }

    bool connected() const
    {
        return m_connected;
    }

    bool poweredOn() const
    {
        return m_poweredOn;
    }

    QStringList airplayNowPlayingInformation() const
    {
        return m_airplayNowPlayingInformation;
    }

private:
    QTcpSocket *m_socket;
    QString m_receiverHost;

    int m_port;

    int m_volume;

    bool m_mute;

    Input m_input;

    bool m_connected;

    bool m_poweredOn;

    QStringList m_airplayNowPlayingInformation;

signals:

    void receiverHostChanged(QString arg);

    void portChanged(int arg);

    void volumeChanged(int arg);

    void muteChanged(bool arg);

    void inputChanged(Input arg);

    void connectedChanged(bool arg);

    void poweredOnChanged(bool arg);

    void airplayNowPlayingInformationChanged(QStringList arg);

    void failedToSendMessage(QString message);

    void messageSending();
    void messageReceived();

public slots:
    void sendMessage(QString);

    void setReceiverHost(QString arg)
    {
        if (m_receiverHost != arg) {
            m_receiverHost = arg;
            emit receiverHostChanged(arg);
        }
    }
    void setPort(int arg)
    {
        if (m_port != arg) {
            m_port = arg;
            emit portChanged(arg);
        }
    }

    void connectToReceiver();

    void newDataAvailable();

    void socketDisconnected();
    void socketConnected();


    void setVolume(int arg)
    {
        if (m_volume != arg) {
            m_volume = arg;
            emit volumeChanged(arg);
        }
    }
    void setMute(bool arg)
    {
        if (m_mute != arg) {
            m_mute = arg;
            emit muteChanged(arg);
        }
    }
    void setInput(Input arg)
    {
        if (m_input != arg) {
            m_input = arg;
            emit inputChanged(arg);
        }
    }
    void setConnected(bool arg)
    {
        if (m_connected != arg) {
            m_connected = arg;
            emit connectedChanged(arg);
        }
    }
    void setPoweredOn(bool arg)
    {
        if (m_poweredOn != arg) {
            m_poweredOn = arg;
            emit poweredOnChanged(arg);
        }
    }
};

#endif // PIONEERCOMMUNICATOR_H
