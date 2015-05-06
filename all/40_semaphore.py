__author__ = 'yuan'

import threading
import random
import time

class MyThread(threading.Thread):

    flag = {}
    flag[0] = False
    flag[1] = False
    turn = 0

    def __init__(self, thread_name, threadingsemaphore, pid):
        threading.Thread.__init__(self, name=thread_name)
        self.semaphore = threadingsemaphore
        self.pid = pid

    def run(self):
        while True:
            self.semaphore.acquire()
            MyThread.turn = self.pid
            MyThread.flag[self.pid] = True
            MyThread.flag[1-self.pid] = False
            print "turn: ", MyThread.turn, " flag: ", MyThread.flag
            self.semaphore.release()
            time.sleep(random.uniform(0, 1.0))


threadingsemaphore = threading.Semaphore(2)

threads = []
for i in range(2):
    threads.append(MyThread('proc '+str(i), threadingsemaphore, i))
for t in threads:
    t.start()
