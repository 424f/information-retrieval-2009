def postprocess(in_path, out_path):
    output = open(out_path, 'w')
    input = open(in_path, 'r')

    xs = []
    ys = []
    for line in input:
        if len(line.strip()) == 0:
            if len(xs) == 0: continue
            output.write("%f %f\n" % (sum(xs) / len(xs), sum(ys) / len(ys)))
            xs = []
            ys = []
        else:
            x, y = [float(v) for v in line.split()]
            xs.append(x)
            ys.append(y)
    input.close()
    output.close()
    
postprocess('roc', 'roc.plot')
postprocess('recall', 'recall.plot')