#include "brainstormingmodel.h"

#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>


using namespace std;


namespace loquatious {


static const char* kKeyDictums  = "dictums";
static const char* kKeyId       = "id";
static const char* kKeySentence = "sentence";
static const char* kKeyWords    = "key_words";


BrainstormingModel::BrainstormingModel(QObject *parent)
    : QObject{parent}
{
    /*keywords_.append("dog");
    keywords_.append("cat");
    keywords_.append("mouse");*/
}


DictumListModel* BrainstormingModel::dictumListModel() {
    return &dictumListModel_;
}


const QStringList BrainstormingModel::keywords() const
{
    lock_guard<recursive_mutex> lock(mutex_);
    return keywords_;
}


bool BrainstormingModel::loadData()
{
    QFile file(":/dictums.json");
    if(!file.open(QIODevice::ReadOnly)) {
        return false;
    }

    auto buf = file.read(1024 * 1024);
    file.close();

    QJsonDocument jsonDoc(QJsonDocument::fromJson(buf));
    const QJsonObject& json = jsonDoc.object();
    if(!json.contains(kKeyDictums) || !json[kKeyDictums].isArray()) {
        qCritical() << "json error!";
        return false;
    }

    dictumListModel_.clear();
    qDeleteAll(allDictums_);
    allDictums_.clear();

    QJsonArray jsonDictums = json[kKeyDictums].toArray();

    for(int i = 0; i < jsonDictums.size(); i++) {
        QJsonObject item = jsonDictums[i].toObject();
        if(!item.contains(kKeyId) || !item[kKeyId].isDouble()) {
            qCritical() << "json error!";
            return false;
        }
        if(!item.contains(kKeySentence) || !item[kKeySentence].isString()) {
            qCritical() << "json error!";
            return false;
        }
        if(!item.contains(kKeyWords) || !item[kKeyWords].isArray()) {
            qCritical() << "json error!";
            return false;
        }

        const int id = static_cast<int>(item[kKeyId].toDouble());
        const QString text = item[kKeySentence].toString();

        QStringList keywords;
        QJsonArray kwjson = item[kKeyWords].toArray();
        for(int i = 0; i < kwjson.size(); i++) {
            if(!kwjson[i].isString()) {
                qCritical() << "json error!";
                return false;
            }
            QString word = kwjson[i].toString();
            keywords << word;
            keyMap_[word].insert(id);
        }

        Dictum* newItem = new Dictum(id, text, keywords, this);
        allDictums_[id] = newItem;
    }

    {
        lock_guard<recursive_mutex> lock(mutex_);
        keywords_.clear();
        keywords_.append(keyMap_.keys());
    }
    emit keywordsChanged();

    return true;
}


void BrainstormingModel::select(const QString& keyword)
{
    lock_guard<recursive_mutex> lock(mutex_);

    QList<Dictum*> matchedDictums;
    const QSet<int>& qset = keyMap_[keyword];
    foreach(const int i, qset) {
        matchedDictums << allDictums_[i];
    }

    dictumListModel_.setDictums(matchedDictums);
}


} // namespace
