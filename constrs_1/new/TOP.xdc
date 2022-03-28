# 100MHZ Clock signal
set_property -dict { PACKAGE_PIN W5   IOSTANDARD LVCMOS33 } [get_ports CLK]

##Reset button
set_property -dict { PACKAGE_PIN u18   IOSTANDARD LVCMOS33 } [get_ports RESET]

# IR Led
set_property -dict { PACKAGE_PIN G2   IOSTANDARD LVCMOS33 } [get_ports IR_LED]

##7 Segment Display
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



set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports {DPI[0]}]
set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports {DPI[1]}]

set_property -dict { PACKAGE_PIN C17   IOSTANDARD LVCMOS33 } [get_ports CLK_MOUSE]

set_property -dict { PACKAGE_PIN B17   IOSTANDARD LVCMOS33 } [get_ports DATA_MOUSE]

set_property PULLUP true [get_ports CLK_MOUSE]

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



set_property PACKAGE_PIN P19 [get_ports VGA_HS]
    set_property IOSTANDARD LVCMOS33 [get_ports VGA_HS]

set_property PACKAGE_PIN R19 [get_ports VGA_VS]
    set_property IOSTANDARD LVCMOS33 [get_ports VGA_VS]

set_property PACKAGE_PIN H19 [get_ports {VGA_COLOUR[0]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {VGA_COLOUR[0]}]
set_property PACKAGE_PIN J19 [get_ports {VGA_COLOUR[1]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {VGA_COLOUR[1]}]
set_property PACKAGE_PIN N19 [get_ports {VGA_COLOUR[2]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {VGA_COLOUR[2]}]
set_property PACKAGE_PIN H17 [get_ports {VGA_COLOUR[3]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {VGA_COLOUR[3]}]
set_property PACKAGE_PIN G17 [get_ports {VGA_COLOUR[4]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {VGA_COLOUR[4]}]
set_property PACKAGE_PIN D17 [get_ports {VGA_COLOUR[5]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {VGA_COLOUR[5]}]
set_property PACKAGE_PIN K18 [get_ports {VGA_COLOUR[6]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {VGA_COLOUR[6]}]
set_property PACKAGE_PIN J18 [get_ports {VGA_COLOUR[7]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {VGA_COLOUR[7]}]