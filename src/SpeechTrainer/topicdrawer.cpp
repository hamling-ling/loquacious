#include "topicdrawer.h"

#include <QFile>
#include <QDebug>
#include <QRegularExpression>


using namespace std;

//const QRegularExpression TopicDrawer::kRe("^\\d+\\.\\s+(\\w.+)");
const QRegularExpression TopicDrawer::kRe("^\\d+\\.\\s+");

TopicDrawer::TopicDrawer(QObject *parent)
    : QObject{parent}
{
    mt_ = mt19937(rnd_());
}

bool TopicDrawer::LoadTopics(const QString &resPath)
{
    QFile file(resPath);
    if(!file.open(QIODevice::ReadOnly)) {
        qCritical() << "could not read" << resPath;
        return false;
    }

    topics_.clear();


    QTextStream in(&file);
    while(topics_.size() < 4096 && !in.atEnd()) {
        QString line = in.readLine(204824);
        topics_.push_back(line.replace(kRe, "").toStdString());
    }

    file.close();
    return !topics_.empty();
}


void TopicDrawer::DrawTopics(std::array<std::string, 5> &selectedTopics)
{
    array<int, 5> indices = {0};
    std::uniform_int_distribution<int> distro(0, topics_.size()-1);

    FillRandRecursively( -1, indices, distro);
    for(int i = 0; i < indices.size(); i++) {
        selectedTopics[i] = topics_[indices[i]];
    }
}


void TopicDrawer::FillRandRecursively(const int                     filledIdx,
                                      array<int, 5>                 &arr,
                                      uniform_int_distribution<int> &distro)
{
    // arr[filledIdx+1] に入れる予定の値を格納
    int  nextVal = 0;

    bool isOverlapped = true;
    while(isOverlapped) {
        isOverlapped = false;
        nextVal = distro(mt_);
        // [0] ～ [filledIdx] に存在するか
        for(int i = 0; i <= filledIdx; i++) {
            if(arr[i] == nextVal) {
                // NG!, go over
                isOverlapped = true;
                break;
            }
        }
    }

    const int currentIdx = filledIdx + 1;
    arr[currentIdx]      = nextVal;

    if(arr.size() == currentIdx + 1) {
        return;
    }

    FillRandRecursively(currentIdx, arr, distro);
}
