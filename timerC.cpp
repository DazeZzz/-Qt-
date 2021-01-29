#include "timerC.h"
#include "databaseconnection.h"
#include "QDebug"

TimerC::TimerC(QObject *parent) : QObject(parent)
{
    DatabaseConnection db;
    QString statement = "select * "
                        "from intelligentlighting.timer";
//    qDebug() << statement;
    timers = db.executeStatement(statement, 4);
    number = timers.length() / 4;
//    qDebug() << timers;
}

bool TimerC::addTimer(int id, QString hour, QString minute, QString flag) {
    DatabaseConnection db;
    QString statement = QString("insert into intelligentlighting.timer "
                                "values('%1', '%2', '%3', '%4')").arg(id).arg(hour).arg(minute).arg(flag);
//    qDebug() << statement;
    return db.queryStatement(statement);
}

void TimerC::deleteTimer(int id) {
    DatabaseConnection db;
    QString statement = QString("delete from intelligentlighting.timer "
                                "where id_timer = '%1'").arg(id);
    db.queryStatement(statement);
}

int TimerC::getNumber() {
    return number;
}

QStringList TimerC::getTimers() {
    return timers;
}
