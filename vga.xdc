set_property IOSTANDARD LVCMOS33 [get_ports {clk100MHz}]
set_property PACKAGE_PIN Y9 [get_ports {clk100MHz}]
create_clock -period 10 [get_ports clk100MHz]
# ----------------------------------------------------------------------------
# VGA Output - Bank 33
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN Y21 [get_ports {blue[0]}]; # "VGA-B0"
set_property PACKAGE_PIN Y20 [get_ports {blue[1]}]; # "VGA-B1"
set_property PACKAGE_PIN AB20 [get_ports {blue[2]}]; # "VGA-B2"
set_property PACKAGE_PIN AB19 [get_ports {blue[3]}]; # "VGA-B3"
set_property PACKAGE_PIN AB22 [get_ports {green[0]}]; # "VGA-G0"
set_property PACKAGE_PIN AA22 [get_ports {green[1]}]; # "VGA-G1"
set_property PACKAGE_PIN AB21 [get_ports {green[2]}]; # "VGA-G2"
set_property PACKAGE_PIN AA21 [get_ports {green[3]}]; # "VGA-G3"
set_property PACKAGE_PIN V20 [get_ports {red[0]}]; # "VGA-R0"
set_property PACKAGE_PIN U20 [get_ports {red[1]}]; # "VGA-R1"
set_property PACKAGE_PIN V19 [get_ports {red[2]}]; # "VGA-R2"
set_property PACKAGE_PIN V18 [get_ports {red[3]}]; # "VGA-R3"
set_property PACKAGE_PIN AA19 [get_ports {hsync}]; # "VGA-HS"
set_property PACKAGE_PIN Y19 [get_ports {vsync}]; # "VGA-VS"
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 33]];

set_property PACKAGE_PIN N15 [get_ports {L}];
set_property PACKAGE_PIN T18 [get_ports {U}];
set_property PACKAGE_PIN R18 [get_ports {R}];
set_property PACKAGE_PIN R16 [get_ports {D}];
set_property PACKAGE_PIN p16 [get_ports {res}];
set_property PACKAGE_PIN F22 [get_ports {rand[0]}]
set_property PACKAGE_PIN G22 [get_ports {rand[1]}]
set_property PACKAGE_PIN H22 [get_ports {rand[2]}]
set_property PACKAGE_PIN F21 [get_ports {rand[3]}]
set_property PACKAGE_PIN H19 [get_ports {rand[4]}]
set_property PACKAGE_PIN H18 [get_ports {rand[5]}]
set_property PACKAGE_PIN H17 [get_ports {rand[6]}]
set_property PACKAGE_PIN M15 [get_ports {rand[7]}]
set_property PACKAGE_PIN T22 [get_ports {led[0]}]
set_property PACKAGE_PIN T21 [get_ports {led[1]}]
set_property PACKAGE_PIN U22 [get_ports {led[2]}]
set_property PACKAGE_PIN U21 [get_ports {led[3]}]
set_property PACKAGE_PIN V22 [get_ports {led[4]}]
set_property PACKAGE_PIN W22 [get_ports {led[5]}]
set_property PACKAGE_PIN U19 [get_ports {led[6]}]
set_property PACKAGE_PIN U14 [get_ports {led[7]}]
set_property IOSTANDARD LVCMOS25 [get_ports L];
set_property IOSTANDARD LVCMOS25 [get_ports res];
set_property IOSTANDARD LVCMOS25 [get_ports U];
set_property IOSTANDARD LVCMOS25 [get_ports R];
set_property IOSTANDARD LVCMOS25 [get_ports D];
set_property IOSTANDARD LVCMOS25 [get_ports rand]
set_property IOSTANDARD LVCMOS33 [get_ports led]
set_property IOSTANDARD LVCMOS33 [get_ports ssd]
set_property IOSTANDARD LVCMOS33 [get_ports ssdcat]
set_property PACKAGE_PIN AB11 [get_ports {ssd[6]}]
set_property PACKAGE_PIN AB10 [get_ports {ssd[5]}]
set_property PACKAGE_PIN AB9 [get_ports {ssd[4]}]
set_property PACKAGE_PIN AA8 [get_ports {ssd[3]}]
set_property PACKAGE_PIN V12 [get_ports {ssd[2]}]
set_property PACKAGE_PIN W10 [get_ports {ssd[1]}]
set_property PACKAGE_PIN V9 [get_ports {ssd[0]}]
set_property PACKAGE_PIN V8 [get_ports ssdcat]