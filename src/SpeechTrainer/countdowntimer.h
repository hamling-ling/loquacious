#ifndef COUNTDOWNTIMER_H
#define COUNTDOWNTIMER_H

#include <mutex>


#include <QObject>
#include <QTimer>


class CountDownTimer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int remainSec READ remainSec NOTIFY remainSecChanged)
public:
    explicit CountDownTimer(QObject *parent = nullptr);

    void start(int sec);
    void stop();
    int  remainSec();

signals:
    void remainSecChanged();
    void elapsed();

private:
    mutable std::recursive_mutex mutex_;
    QTimer                       *timer_;
    int                          remainSec_;

    void TimerElapsed();
};


#endif // COUNTDOWNTIMER_H
