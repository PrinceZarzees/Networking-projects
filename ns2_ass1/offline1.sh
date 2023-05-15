for area in {250..1250..250}
do
ns offline1.tcl 40 20 $area 5 8
echo "-------------Area $area-------------"
awk -f parse.awk offline1.tr
echo "------------------------------------"
done
ns offline1.tcl 20 20 500 4 5
echo "-------------Node 20-------------"
awk -f parse.awk offline1.tr
echo "------------------------------------"
ns offline1.tcl 40 20 500 5 8
echo "-------------Node 40-------------"
awk -f parse.awk offline1.tr
echo "------------------------------------"
ns offline1.tcl 60 20 500 6 10
echo "-------------Node 60-------------"
awk -f parse.awk offline1.tr
echo "------------------------------------"
ns offline1.tcl 80 20 500 8 10
echo "-------------Node 80-------------"
awk -f parse.awk offline1.tr
echo "------------------------------------"
ns offline1.tcl 100 20 500 10 10
echo "-------------Node 100-------------"
awk -f parse.awk offline1.tr
echo "------------------------------------"
for flow in {10..50..10}
do
ns offline1.tcl 40 $flow 500 5 8
echo "-------------Flow $flow-------------"
awk -f parse.awk offline1.tr
echo "------------------------------------"
done