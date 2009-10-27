
	set terminal png
	set output 'Q13.png'
	set ylabel 'Precision'
	set xlabel 'Recall'
	set xrange [-0.1:1.1]
	set yrange [-0.1:1.1]
	plot 'Q13.dat' index 0 using 1:2 w linespoints lw 2 pt 5 title 'Standard', \
'Q13.dat' index 1 using 1:2 w linespoints lw 2 pt 5 title 'Stemming', \
'Q13.dat' index 2 using 1:2 w linespoints lw 2 pt 5 title 'Stopword Elimination', \
'Q13.dat' index 3 using 1:2 w linespoints lw 2 pt 5 title 'Stemming & Stopword Elimination'