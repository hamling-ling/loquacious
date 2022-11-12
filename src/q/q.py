import random
import re
import time
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('-ns', '--noselection', action='store_true', required=False)

args = parser.parse_args()

def show_questions(file_name):
    f           = open(file_name)
    lines       = f.readlines()
    five_topics = random.sample(lines, 5)
    for i, x in enumerate(five_topics):
        replaced = re.sub('^\d+', str(i+1), x).rstrip()
        print(replaced)
    f.close()

def show_progress_bar(message, percent=0, width=40):
    left  = width * int(percent) // 100
    right = width - left
    
    tags     = "#" * left
    spaces   = " " * right
    percents = f"{percent:3.0f}%"
    
    print("\r", message, "[", tags, spaces, "] ", percents, sep="", end="", flush=True)


def wait_for(msg, sec):
    current_sec = 0.0
    progress    = 0.0
    # loop for every seconds
    while progress < 100:
        progress = 100.0 * current_sec/sec
        show_progress_bar(msg, progress)
        time.sleep(1)
        current_sec += 1.0
    
def main():
    # Show selectionand wait for 60 sec
    if not args.noselection:
        file_name = 'topics.txt'
        show_questions(file_name)
        wait_for("select your topic", 60)
    
    # Wait for 120 sec and show progress
    wait_for("make your speech ", 120)
    print("")

if __name__ == "__main__":
    main()
