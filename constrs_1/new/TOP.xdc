# 100MHZ Clock signal
set_property -dict { PACKAGE_PIN W5   IOSTANDARD LVCMOS33 } [get_ports CLK]

# Reset button
set_property -dict { PACKAGE_PIN u18   IOSTANDARD LVCMOS33 } [get_ports RESET]

# IR Led
set_property -dict { PACKAGE_PIN G2   IOSTANDARD LVCMOS33 } [get_ports IR_LED]

# PS2 Mouse
set_property -dict { PACKAGE_PIN C17   IOSTANDARD LVCMOS33 } [get_ports CLK_MOUSE]
set_property -dict { PACKAGE_PIN B17   IOSTANDARD LVCMOS33 } [get_ports DATA_MOUSE]
set_property PULLUP true [get_ports CLK_MOUSE]

# VGA Display
set_property -dict { PACKAGE_PIN P19   IOSTANDARD LVCMOS33 } [get_ports VGA_HS]
set_property -dict { PACKAGE_PIN R19   IOSTANDARD LVCMOS33 } [get_ports VGA_VS]

set_property -dict { PACKAGE_PIN H19   IOSTANDARD LVCMOS33 } [get_ports {VGA_COLOUR[0]}]
set_property -dict { PACKAGE_PIN J19   IOSTANDARD LVCMOS33 } [get_ports {VGA_COLOUR[1]}]
set_property -dict { PACKAGE_PIN N19   IOSTANDARD LVCMOS33 } [get_ports {VGA_COLOUR[2]}]
set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports {VGA_COLOUR[3]}]
set_property -dict { PACKAGE_PIN G17   IOSTANDARD LVCMOS33 } [get_ports {VGA_COLOUR[4]}]
set_property -dict { PACKAGE_PIN D17   IOSTANDARD LVCMOS33 } [get_ports {VGA_COLOUR[5]}]
set_property -dict { PACKAGE_PIN K18   IOSTANDARD LVCMOS33 } [get_ports {VGA_COLOUR[6]}]
set_property -dict { PACKAGE_PIN J18   IOSTANDARD LVCMOS33 } [get_ports {VGA_COLOUR[7]}]

# 7 Segment Display
set_property -dict { PACKAGE_PIN W7   IOSTANDARD LVCMOS33 } [get_ports {DIGIT[0]}]
set_property -dict { PACKAGE_PIN W6   IOSTANDARD LVCMOS33 } [get_ports {DIGIT[1]}]
set_property -dict { PACKAGE_PIN U8   IOSTANDARD LVCMOS33 } [get_ports {DIGIT[2]}]
set_property -dict { PACKAGE_PIN V8   IOSTANDARD LVCMOS33 } [get_ports {DIGIT[3]}]
set_property -dict { PACKAGE_PIN U5   IOSTANDARD LVCMOS33 } [get_ports {DIGIT[4]}]
set_property -dict { PACKAGE_PIN V5   IOSTANDARD LVCMOS33 } [get_ports {DIGIT[5]}]
set_property -dict { PACKAGE_PIN U7   IOSTANDARD LVCMOS33 } [get_ports {DIGIT[6]}]
set_property -dict { PACKAGE_PIN V7   IOSTANDARD LVCMOS33 } [get_ports {DIGIT[7]}]

set_property -dict { PACKAGE_PIN U2   IOSTANDARD LVCMOS33 } [get_ports {SEL[0]}]
set_property -dict { PACKAGE_PIN U4   IOSTANDARD LVCMOS33 } [get_ports {SEL[1]}]
set_property -dict { PACKAGE_PIN V4   IOSTANDARD LVCMOS33 } [get_ports {SEL[2]}]
set_property -dict { PACKAGE_PIN W4   IOSTANDARD LVCMOS33 } [get_ports {SEL[3]}]

# LEDs
set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS33 } [get_ports {LEDS[0]}]
set_property -dict { PACKAGE_PIN E19   IOSTANDARD LVCMOS33 } [get_ports {LEDS[1]}]
set_property -dict { PACKAGE_PIN U19   IOSTANDARD LVCMOS33 } [get_ports {LEDS[2]}]
set_property -dict { PACKAGE_PIN V19   IOSTANDARD LVCMOS33 } [get_ports {LEDS[3]}]
set_property -dict { PACKAGE_PIN W18   IOSTANDARD LVCMOS33 } [get_ports {LEDS[4]}]
set_property -dict { PACKAGE_PIN U15   IOSTANDARD LVCMOS33 } [get_ports {LEDS[5]}]
set_property -dict { PACKAGE_PIN U14   IOSTANDARD LVCMOS33 } [get_ports {LEDS[6]}]
set_property -dict { PACKAGE_PIN V14   IOSTANDARD LVCMOS33 } [get_ports {LEDS[7]}]
set_property -dict { PACKAGE_PIN V13   IOSTANDARD LVCMOS33 } [get_ports {LEDS[8]}]
set_property -dict { PACKAGE_PIN V3   IOSTANDARD LVCMOS33 } [get_ports {LEDS[9]}]
set_property -dict { PACKAGE_PIN W3   IOSTANDARD LVCMOS33 } [get_ports {LEDS[10]}]
set_property -dict { PACKAGE_PIN U3   IOSTANDARD LVCMOS33 } [get_ports {LEDS[11]}]
set_property -dict { PACKAGE_PIN P3   IOSTANDARD LVCMOS33 } [get_ports {LEDS[12]}]
set_property -dict { PACKAGE_PIN N3   IOSTANDARD LVCMOS33 } [get_ports {LEDS[13]}]
set_property -dict { PACKAGE_PIN P1   IOSTANDARD LVCMOS33 } [get_ports {LEDS[14]}]
set_property -dict { PACKAGE_PIN L1   IOSTANDARD LVCMOS33 } [get_ports {LEDS[15]}]

# Switches
set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports {SW[0]}]
set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports {SW[1]}]
set_property -dict { PACKAGE_PIN W16   IOSTANDARD LVCMOS33 } [get_ports {SW[2]}]

# set_property -dict { PACKAGE_PIN W17   IOSTANDARD LVCMOS33 } [get_ports {SW[3]}]
# set_property -dict { PACKAGE_PIN W15   IOSTANDARD LVCMOS33 } [get_ports {SW[4]}]
# set_property -dict { PACKAGE_PIN V15   IOSTANDARD LVCMOS33 } [get_ports {SW[5]}]
# set_property -dict { PACKAGE_PIN W14   IOSTANDARD LVCMOS33 } [get_ports {SW[6]}]
# set_property -dict { PACKAGE_PIN W13   IOSTANDARD LVCMOS33 } [get_ports {SW[7]}]
# set_property -dict { PACKAGE_PIN V2   IOSTANDARD LVCMOS33 } [get_ports {SW[8]}]
# set_property -dict { PACKAGE_PIN T3   IOSTANDARD LVCMOS33 } [get_ports {SW[9]}]
# set_property -dict { PACKAGE_PIN T2   IOSTANDARD LVCMOS33 } [get_ports {SW[10]}]
# set_property -dict { PACKAGE_PIN R3   IOSTANDARD LVCMOS33 } [get_ports {SW[11]}]
# set_property -dict { PACKAGE_PIN W2   IOSTANDARD LVCMOS33 } [get_ports {SW[12]}]
# set_property -dict { PACKAGE_PIN U1   IOSTANDARD LVCMOS33 } [get_ports {SW[13]}]
# set_property -dict { PACKAGE_PIN T1   IOSTANDARD LVCMOS33 } [get_ports {SW[14]}]
# set_property -dict { PACKAGE_PIN R2   IOSTANDARD LVCMOS33 } [get_ports {SW[15]}]