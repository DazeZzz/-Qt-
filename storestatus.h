#ifndef STORESTATUS_H
#define STORESTATUS_H

#include <QObject>

class StoreStatus : public QObject
{
private:
    Q_OBJECT
    double luminance;
    double colorTemperature;

public:
    explicit StoreStatus(QObject *parent = nullptr);

signals:

public slots:
    void storeStatus(double luminance, double colorTemperature);
    double getLuminance();
    double getColorTemperature();
};

#endif // STORESTATUS_H
