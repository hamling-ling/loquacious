#include "countdowntimer.h"

#include <QTimer>

using namespace std;


CountDownTimer::CountDownTimer(QObject *parent)
    : QObject{parent}, timer_(new QTimer(this))
{
    connect( timer_,
             &QTimer::timeout,
             this,
             &CountDownTimer::TimerElapsed);
}


void CountDownTimer::start(int sec)
{
    lock_guard<recursive_mutex> lock(mutex_);
    timer_->stop();

    if(remainSec_ != sec) {
        remainSec_ = sec;
        emit remainSecChanged();
    }

    timer_->start(1000);
}


void CountDownTimer::stop()
{
    lock_guard<recursive_mutex> lock(mutex_);
    timer_->stop();

    if(0 != remainSec_) {
        remainSec_ = 0;
        emit remainSecChanged();
    }
}


int CountDownTimer::remainSec()
{
    lock_guard<recursive_mutex> lock(mutex_);
    return remainSec_;
}


void CountDownTimer::TimerElapsed()
{
    lock_guard<recursive_mutex> lock(mutex_);

    remainSec_--;
    if(remainSec_ <= 0) {
        remainSec_ = 0;
        emit remainSecChanged();
        emit elapsed();
    } else {
        emit remainSecChanged();
    }
}
