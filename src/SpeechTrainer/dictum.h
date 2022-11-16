#ifndef DICTUM_H
#define DICTUM_H

#include <QObject>

class Dictum : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariant    textId   READ textId   CONSTANT)
    Q_PROPERTY(QString     text     READ text     CONSTANT)
    Q_PROPERTY(QStringList keywords READ keywords CONSTANT)

public:
    explicit Dictum( const int         &id,
                     const QString     &text,
                     const QStringList &keywords,
                     QObject *parent = nullptr);

    QVariant    textId()   const;
    QString     text()     const;
    QStringList keywords() const;

signals:

private:
    const int         id_;
    const QString     text_;
    const QStringList keywords_;
};

#endif // DICTUM_H
