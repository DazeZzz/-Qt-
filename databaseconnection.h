#ifndef DATABASECONNECTION_H
#define DATABASECONNECTION_H

#include <QObject>
#include <QSqlDatabase>

class DatabaseConnection : public QObject
{
private:
    Q_OBJECT
    QSqlDatabase database;

public:
    explicit DatabaseConnection(QObject *parent = nullptr, QString connectionName = "IntelligentLighting");
    bool queryStatement(QString statement);
    QStringList executeStatement(QString statement, int number);

signals:
    void execResult(bool result);

public slots:
};

#endif // DATABASECONNECTION_H
