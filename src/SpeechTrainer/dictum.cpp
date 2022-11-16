#include "dictum.h"

#include <QVariant>


Dictum::Dictum( const int         &id,
                const QString     &text,
                const QStringList &keywords,
                QObject *parent)
    : QObject{parent},
      id_(id),
      text_(text),
      keywords_(keywords)
{

}


QVariant Dictum::textId() const
{
    return QVariant::fromValue(id_);
}


QString Dictum::text() const
{
    return text_;
}


QStringList Dictum::keywords() const
{
    return keywords_;
}
