INTERFACE=$1

ip tuntap del name $INTERFACE mode tap
#ip addr
echo "deleted $INTERFACE"

exit 0

