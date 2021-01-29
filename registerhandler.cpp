#include "registerhandler.h"
#include "QDebug"
#include <databaseconnection.h>

RegisterHandler::RegisterHandler(QObject *parent) : QObject(parent)
{

}

void RegisterHandler::registerAccount(QString account, QString phone, QString password) {
    QString statement = "insert into "
                        "intelligentlighting.account "
                        "values('" + account + "', '" + phone + "', '" + password + "')";
//    qDebug() << statement;
    DatabaseConnection db;
    emit execResult(db.queryStatement(statement));
}
