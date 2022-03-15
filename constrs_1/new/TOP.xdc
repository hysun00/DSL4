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

set_property PACKAGE_PIN V17 [get_ports {DPI[0]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {DPI[0]}]

set_property PACKAGE_PIN V16 [get_ports {DPI[1]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {DPI[1]}]

set_property PACKAGE_PIN C17 [get_ports CLK_MOUSE]
    set_property IOSTANDARD LVCMOS33 [get_ports CLK_MOUSE]

set_property PACKAGE_PIN B17 [get_ports DATA_MOUSE]
    set_property IOSTANDARD LVCMOS33 [get_ports DATA_MOUSE]

set_property PULLUP true [get_ports CLK_MOUSE]

# LEDs
set_property PACKAGE_PIN U16 [get_ports {LEDS[0]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[0]}]
set_property PACKAGE_PIN E19 [get_ports {LEDS[1]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[1]}]
set_property PACKAGE_PIN U19 [get_ports {LEDS[2]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[2]}]
set_property PACKAGE_PIN V19 [get_ports {LEDS[3]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[3]}]
set_property PACKAGE_PIN W18 [get_ports {LEDS[4]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[4]}]
set_property PACKAGE_PIN U15 [get_ports {LEDS[5]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[5]}]
set_property PACKAGE_PIN U14 [get_ports {LEDS[6]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[6]}]
set_property PACKAGE_PIN V14 [get_ports {LEDS[7]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[7]}]
set_property PACKAGE_PIN V13 [get_ports {LEDS[8]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[8]}]
set_property PACKAGE_PIN V3 [get_ports {LEDS[9]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[9]}]
set_property PACKAGE_PIN W3 [get_ports {LEDS[10]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[10]}]
set_property PACKAGE_PIN U3 [get_ports {LEDS[11]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[11]}]
set_property PACKAGE_PIN P3 [get_ports {LEDS[12]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[12]}]
set_property PACKAGE_PIN N3 [get_ports {LEDS[13]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[13]}]
set_property PACKAGE_PIN P1 [get_ports {LEDS[14]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[14]}]
set_property PACKAGE_PIN L1 [get_ports {LEDS[15]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[15]}]


### LEDs
#set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS33 } [get_ports {instruction_mem_addr[0]}]
#set_property -dict { PACKAGE_PIN E19   IOSTANDARD LVCMOS33 } [get_ports {instruction_mem_addr[1]}]
#set_property -dict { PACKAGE_PIN U19   IOSTANDARD LVCMOS33 } [get_ports {instruction_mem_addr[2]}]
#set_property -dict { PACKAGE_PIN V19   IOSTANDARD LVCMOS33 } [get_ports {instruction_mem_addr[3]}]
#set_property -dict { PACKAGE_PIN W18   IOSTANDARD LVCMOS33 } [get_ports {instruction_mem_addr[4]}]
#set_property -dict { PACKAGE_PIN U15   IOSTANDARD LVCMOS33 } [get_ports {instruction_mem_addr[5]}]
#set_property -dict { PACKAGE_PIN U14   IOSTANDARD LVCMOS33 } [get_ports {instruction_mem_addr[6]}]
#set_property -dict { PACKAGE_PIN V14   IOSTANDARD LVCMOS33 } [get_ports {instruction_mem_addr[7]}]