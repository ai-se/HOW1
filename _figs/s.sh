data() { cat<<EOF
ant        a 0.54 0.13
camel      c 0.45 0.38
ivy        i 0.8  0.41
jedit      j 0.64 0.3
log4j      l 0.8  0.19
luncene    L 0,6  0.3
pbeans(rf) P 0.9  0.32 
poi        p 0.57 0.33
synapse    s 0.63 0.49
velocity   v 0.86 0.66
xalan      x 0.44 0
xerces     X 0.22 0.4
EOF
}

data | sed 's/[ ]+/	/g' > /tmp/s.dat
points() {
    data | gawk '{
      print "set label \"" $2 "\" at  " $3 "," $4 ";\n" }'
}

eps2pdf() {
 gs -dSAFER -dNOPLATFONTS -dNOPAUSE -dBATCH \
  -sDEVICE=pdfwrite -sPAPERSIZE=letter -dCompatibilityLevel=1.4 \
  -dPDFSETTINGS=/printer -dCompatibilityLevel=1.4 -dMaxSubsetPct=100 \
  -dSubsetFonts=true -dEmbedAllFonts=true -dEPSCrop -sOutputFile="$1.pdf" \
  -f "$1.eps"
}

plot(){
    gnuplot<<EOF
set terminal postscript eps color "Helvetica" 15
set size 0.5,0.5
set output "s.eps
set xrange [0:1]
set yrange [-0.05:1]
set xlabel "recall (pd)"
set ylabel "\% false alarms"
set arrow 1 from 0.6,0.4 to 1,0.4 nohead
set arrow 2 from 0.6,0.4 to 0.6,-0.05 nohead

$(points)
plot "/tmp/s.dat" using ($$3+0.05):4 title "" with points lt 1 pt 6
EOF
eps2pdf s
}

plot
open s.pdf

