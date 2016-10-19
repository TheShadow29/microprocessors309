from random import randint

with open("tracefile_alu.txt","w") as trace:
    for i in range(1000):
        x = randint(0,65535);
        y = randint(0,65535);
        a = x + y

        if a>65535:
            c = 1
        else:
            c = 0

        if a == 0:
            z = 1
        else:
            z = 0

        a = a & 65535

        trace.write("{:01b} {:016b} {:016b} {:016b} {:01b} {:01b}\n".format(0,x,y,a,c,z))

        n = ~(x & y)
        c = 0
        if n == 0:
            z = 1
        else:
            z = 0

        n = n & 65535

        trace.write("{:01b} {:016b} {:016b} {:016b} {:01b} {:01b}\n".format(1,x,y,n,c,z))

with open("tracefile_rf.txt","w") as trace:
    x = [0]*8
    for i in range(8):
        x[i] = randint(0,65535);

        trace.write("{:01b} {:03b} {:03b} {:03b} {:016b} {:016b} {:016b}\n".format(1,0,0,i,0,0,x[i]))

    for i in range(50):
        a = randint(0,7)
        b = randint(0,7)

        trace.write("{:01b} {:03b} {:03b} {:03b} {:016b} {:016b} {:016b}\n".format(0,a,b,0,x[a],x[b],0))
