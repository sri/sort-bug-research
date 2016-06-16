# Sorts completes successfully under Python 2.7.6
# This program was run 100 times.
import random
class T:
    def __init__(self, a, b):
        self.a = a
        self.b = b
    def __cmp__(self, other):
        print "comparing"
        return cmp(self.b, other.a)

def rand():
    return float(random.randrange(1000, 2600))

A = []
B = []

for i in range(100000):
    A.append(rand())
    B.append(rand())

ALL = zip(A, B)
OBJS = [T(a, b) for (a, b) in ALL]
sorted(OBJS)
print "Done"
