__author__ = 'yuan'

import threading
import time
import random

condition = threading.Condition()
flag = {}
flag[0] = False
flag[1] = False
turn = 0

class MyProcess(threading.Thread):
    def __init__(self, pid):
        threading.Thread.__init__(self)
        self.pid = pid

    def run(self):
        global flag, turn
        i = self.pid
        j = 1 - self.pid
        while True:
            if condition.acquire():
                flag[i] = True
                turn = i
                condition.notify()
                while flag[j] or turn == j:
                    condition.wait()

                print "turn: ", turn, " flag: ", flag
                flag[i] = False
                time.sleep(random.uniform(0, 1.0))
                condition.release()

if __name__ == "__main__":
    for p in range(2):
        p = MyProcess(p)
        p.start()
