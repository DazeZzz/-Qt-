#include "loginhandler.h"
#include "databaseconnection.h"
#include <QDebug>

LoginHandler::LoginHandler(QObject *parent) : QObject(parent)
{

}

void LoginHandler::verifyAccount(QString account, QString password) {
    QString statement = "select id_account, password_account "
                        "from intelligentlighting.account "
                        "where id_account = '"+ account +"'";
//    qDebug() << statement;
    DatabaseConnection db;
    QStringList resultList = db.executeStatement(statement, 2);
    if (!resultList.isEmpty())
        emit execResult(password == resultList[1]);
    else
        emit execResult(false);
}
