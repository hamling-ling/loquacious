#ifndef TOPICITEMMODEL_H
#define TOPICITEMMODEL_H

#include <QObject>

#include <string>


class TopicItemModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariant topicId       READ topicId  CONSTANT)
    Q_PROPERTY(QString  topicSentence READ topicSentence CONSTANT)


public:
    explicit TopicItemModel( const int         topicIdIn,
                             const std::string &topicSentenceIn,
                             QObject           *parent = nullptr);

    QVariant topicId() const;
    QString  topicSentence() const;

signals:

private:
    const int     topicId_;
    const QString topicSentence_;
};

#endif // TOPICITEMMODEL_H
