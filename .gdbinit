# J-LINK GDB SERVER initialization
#
# This connects to a GDB Server listening
# for commands on localhost at tcp port 2331
target remote 192.168.5.103:2331
# Set JTAG speed to 30 kHz
monitor speed 30
# Set GDBServer to little endian
monitor endian little
# Reset the chip to get to a known state.
monitor reset
#
# CPU core initialization (to be done by user)
#
# Set auto JTAG speed
monitor speed auto
# Load the program executable
load
