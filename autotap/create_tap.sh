echo "script"

LIB="LD_LIBRARY_PATH=/usr/local/lib"
INTERFACE=$1
BRIDGE="br0"

ip tuntap add name $INTERFACE mode tap
/sbin/brctl addif $BRIDGE $INTERFACE
/sbin/brctl show
ip link set dev $INTERFACE master $BRIDGE
ip link set $INTERFACE up

echo "exit script create tap"

exit 0
