set terminal png
set output 'Plot_ROC.png'
set ylabel 'True Positive Rate'
set xlabel 'False Positive Rate'
plot 'roc.plot' using 1:2 w linespoints lw 2 pt 5 title 'Standard', \
     x title 'Random'


set terminal png
set output 'Plot_Recall.png'
set ylabel 'Precision'
set xlabel 'Recall'
set xrange [-0.1:1.1]
set yrange [-0.1:1.1]
plot 'recall.plot' index 0 using 1:2 w linespoints lw 2 pt 5 title ''


