#ifndef TOPICDRAWER_H
#define TOPICDRAWER_H

#include <vector>
#include <array>
#include <random>

#include <QObject>


class TopicDrawer : public QObject
{
    Q_OBJECT
public:
    explicit TopicDrawer(QObject *parent = nullptr);
    bool LoadTopics(const QString &resPath);
    void DrawTopics(std::array<std::string, 5> &selectedTopics);

signals:

private:
    std::vector<std::string> topics_;
    std::random_device       rnd_;
    std::mt19937             mt_;
    static const QRegularExpression kRe;

    void FillRandRecursively(const int                          filledIdx,
                             std::array<int, 5>                 &arr,
                             std::uniform_int_distribution<int> &distr);
};

#endif // TOPICDRAWER_H
