#include "topicitemmodel.h"

#include <QVariant>


using namespace std;


TopicItemModel::TopicItemModel( const int    topicIdIn,
                                const string &topicSentenceIn,
                                QObject      *parent)
    : QObject{parent},
      topicId_(topicIdIn),
      topicSentence_(topicSentenceIn.c_str())
{

}


QVariant TopicItemModel::topicId() const
{
    return QVariant::fromValue(topicId_);
}


QString TopicItemModel::topicSentence() const
{
    return topicSentence_;
}
