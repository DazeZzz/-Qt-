#include "databaseconnection.h"
#include "QDebug"
#include <QSqlError>
#include <QSqlQuery>


DatabaseConnection::DatabaseConnection(QObject *parent, QString connectionName) : QObject(parent)
{
    if (QSqlDatabase::contains(connectionName))
        database = QSqlDatabase::database(connectionName);
    else {
        database = QSqlDatabase::addDatabase("QMYSQL", connectionName);
        database.setHostName("your host name");
        database.setPort(3306);  //your Port
        database.setUserName("your user name");
        database.setPassword("your password");
    }
    if (!database.open()) {
        qDebug() << "fail to connect mysql:" << database.lastError().text();
        return;
    } else
        qDebug() << "success to connect mysql:" << database.lastError().text();
}

bool DatabaseConnection::queryStatement(QString statement) {
    QString queryString = statement;
    QSqlQuery query(database);
    return query.exec(statement);
}

QStringList DatabaseConnection::executeStatement(QString statement, int number) {
    int count;
    QString queryString = statement;
    QSqlQuery query(database);
    QStringList resultList;
    query.exec(statement);
    while (query.next()) {
        count = 0;
        while (count < number) {
            resultList << query.value(count).toString();
            count++;
        }
    }
    return resultList;
}
