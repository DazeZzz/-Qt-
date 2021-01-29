#ifndef REGISTERHANDLER_H
#define REGISTERHANDLER_H

#include <QObject>

class RegisterHandler : public QObject
{
private:
    Q_OBJECT

public:
    explicit RegisterHandler(QObject *parent = nullptr);

signals:
    void execResult(bool result);

public slots:
    void registerAccount(QString account, QString phone, QString password);

};

#endif // REGISTERHANDLER_H
