#ifndef LOGINHANDLER_H
#define LOGINHANDLER_H

#include <QObject>

class LoginHandler : public QObject
{
private:
    Q_OBJECT

public:
    explicit LoginHandler(QObject *parent = nullptr);

signals:
    void execResult(bool result);

public slots:
    void verifyAccount(QString account, QString password);
};

#endif // LOGINHANDLER_H
