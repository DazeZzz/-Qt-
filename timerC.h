#ifndef TIMER_H
#define TIMER_H

#include <QObject>

class TimerC : public QObject
{
private:
    Q_OBJECT
    int number;
    QStringList timers;

public:
    explicit TimerC(QObject *parent = nullptr);

signals:

public slots:
    bool addTimer(int id, QString hour, QString minute, QString flag);
    void deleteTimer(int id);
    int getNumber();
    QStringList getTimers();
};

#endif // TIMER_H
