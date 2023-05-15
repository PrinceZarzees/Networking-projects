echo "-------------Varying Number of Nodes-------------"
echo "Number of Nodes, Throughput, Average Delay, Delivery ratio, Drop ratio, Energy Consumption" > temp1.csv
ns project.tcl 20 20 500 4 5 200 3
echo -n "20," >> temp1.csv
awk -f parse.awk project.tr >> temp1.csv
ns project.tcl 40 20 500 5 8 200 3
echo -n "40," >> temp1.csv
awk -f parse.awk project.tr >> temp1.csv
ns project.tcl 60 20 500 6 10 200 3
echo -n "60," >> temp1.csv
awk -f parse.awk project.tr >> temp1.csv
ns project.tcl 80 20 500 8 10 200 3
echo -n "80," >> temp1.csv
awk -f parse.awk project.tr >> temp1.csv
ns project.tcl 100 20 500 10 10 200 3
echo -n "100," >> temp1.csv
awk -f parse.awk project.tr >> temp1.csv
echo "--------------Varying Number of flows----------------------"
echo "Number of flows, Throughput, Average Delay, Delivery ratio, Drop ratio, Energy Consumption" >> temp1.csv
for flow in {10..50..10}
do
ns project.tcl 40 $flow 500 5 8 200 3
echo -n "$flow," >> temp1.csv
awk -f parse.awk project.tr >> temp1.csv
done
echo "--------------Varying Number of Packets----------------------"
echo "Number of Packets, Throughput, Average Delay, Delivery ratio, Drop ratio, Energy Consumption" >> temp1.csv
for packet in {100..500..100}
do
ns project.tcl 40 20 500 5 8 $packet 3
echo -n "$packet," >> temp1.csv
awk -f parse.awk project.tr >> temp1.csv
done
echo "--------------Varying Coverage----------------------"
echo "Coverage, Throughput, Average Delay, Delivery ratio, Drop ratio, Energy Consumption" >> temp1.csv
for coverage in {1..5..1}
do
ns project.tcl 40 20 500 5 8 200 $coverage
echo -n "$coverage," >> temp1.csv
awk -f parse.awk project.tr >> temp1.csv
echo "------------------------------------"
done