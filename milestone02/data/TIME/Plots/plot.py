import os

lists = [{} for x in range(5)]
for path in os.listdir('.'):
    if not path.endswith('.dat'):
        continue

    values = [{} for i in range(5)]

    f = open(path, 'r')
    i = 0
    j = 0
    for line in f:
        if len(line.strip()) == 0:
            if len(values[i].keys()) == 0:
                continue           
            i += 1
            j = 0
            continue
        else:
            x, y = [float(z) for z in line.split()]
            values[i][j] = (x, y)
            j += 1
            
    f.close()

    for i in range(4):
        for j in values[i].keys():
            y = values[i][j]
            lists[i][j] = lists[i].get(j, []) + [y]
    
avg = []
f = open('Queries.dat', 'w')
for i in range(4):
    for j in lists[i].keys():
        x0 = [x[0] for x in lists[i][j]]
        x1 = [x[1] for x in lists[i][j]]
        N = float(len(x0))
        avg = (sum(x0) / N, sum(x1) / N)
        f.write('%f %f\n' % avg)
    f.write('\n\n')
f.close()
