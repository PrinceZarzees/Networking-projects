set nn             [lindex $argv 0]
set nf             [lindex $argv 1]                       
set height         [lindex $argv 2]
set row            [lindex $argv 3]                       
set col            [lindex $argv 4]
set packets_per_sec [lindex $argv 5] 
set tx_range        [lindex $argv 6]
Phy/WirelessPhy set Pt_ [expr 0.00721383*$tx_range**4] 

# ======================================================================
# Define options
# ======================================================================      
set val(chan)           Channel/WirelessChannel    ;# channel type
set val(prop)           Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)          Phy/WirelessPhy  ;#802_15_4         # network interface type
set val(mac)            Mac/802_11                 ;# MAC type
set val(ifq)            CMUPriQueue                ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         50                         ;# max packet in ifq
set val(nn)             $nn                         ;# number of mobilenodes
set val(rp)             DSR                        ;# routing protocol
set val(nf)             $nf                         ;#number of flow
set val(height)         $height
set val(width)          $val(height)
set val(row)            $row                          ;#number of row
set val(col)            $col                          ;#number of col
# ======================================================================
# Main Program
# ======================================================================


#
# Initialize Global Variables
#
set ns_		[new Simulator]
set tracefd     [open project.tr w]
set nf [open project.nam w]
$ns_ trace-all $tracefd
$ns_  namtrace-all-wireless $nf $val(width) $val(height)

# set up topography object
set topo       [new Topography]

$topo load_flatgrid $val(width) $val(height)

#
# Create God
#
create-god $val(nn)




$ns_ node-config -adhocRouting $val(rp) \
    -llType $val(ll) \
    -macType $val(mac) \
    -ifqType $val(ifq) \
    -ifqLen $val(ifqlen) \
    -antType $val(ant) \
    -propType $val(prop) \
    -phyType $val(netif) \
    -channelType $val(chan) \
    -topoInstance $topo \
    -agentTrace ON \
    -routerTrace ON \
    -macTrace OFF \
    -movementTrace OFF \
    -energyModel "EnergyModel" \
    -initialEnergy 25 \
    -txPower 0.9 \
    -rxPower 0.5 \
    -idlePower 0.45 \
    -sleepPower 0.05 \

for {set i 0} {$i < $val(nn)} {incr i} {


    set node_($i) [$ns_ node]
    $node_($i) random-motion 0 ;#disable random motion

}
set rng [new RNG]
$rng seed 0

set node_num 0
for {set i 0} {$i < $val(row)} {incr i} {

    for {set j 0} {$j < $val(col)} {incr j} {
        $node_($node_num) set X_ [expr ($i*$val(height))/$val(row)+1]
        $node_($node_num) set Y_  [expr ($j*$val(width))/$val(col)+1]
        $node_($node_num) set Z_ 0
        $ns_ initial_node_pos $node_($node_num) 20
        set x [expr ($i*$val(height))/$val(row)+1]
        set y [expr ($j*$val(width))/$val(col)+1]
        # set dest_x [$rng uniform [expr $val(width)/4] [expr 3*$val(width)/4] ]
        # set dest_y [$rng uniform [expr $val(height)/4] [expr 3*$val(height)/4] ]
        # $ns_ at 10.0 "$node_($node_num) setdest $dest_x $dest_y $velocity"
        # $ns_ at 30.0 "$node_($node_num) setdest $x $y $velocity"
        #puts "$velocity"
        incr node_num

    }


}


for {set i 0} {$i < $val(nf) } {incr i} {
    set sink_no [$rng integer $val(nn)]
    set source [$rng integer $val(nn)]
    while {$source==$sink_no} {
        set source [$rng integer $val(nn)]
    }
    # puts "$source $sink_no"

    set tcp [new Agent/TCP]
    $ns_ attach-agent $node_($source) $tcp
    set telnet_($i) [new Application/Telnet]
    $telnet_($i) attach-agent $tcp
    $telnet_($i) set interval_ [expr 1/$packets_per_sec]
    set sink [new Agent/TCPSink]
    $ns_ attach-agent $node_($sink_no) $sink

    $ns_ connect $tcp $sink
    $ns_ at 0.5 "$telnet_($i) start"

}

#
# Tell nodes when the simulation ends
#

for {set i 0} {$i < $val(nn) } {incr i} {
    $ns_ at 50.0 "$node_($i) reset";
}
$ns_ at 50.001 "stop"
$ns_ at 50.002 "puts \"NS EXITING...\" ; $ns_ halt"
proc stop {} {
    global ns_ tracefd nf
    $ns_ flush-trace
    close $nf
    close $tracefd
    #exec nam offline1.nam
}


puts "Starting Simulation..."

$ns_ run

