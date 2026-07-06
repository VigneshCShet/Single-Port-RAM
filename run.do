vlog -sv +acc +cover +fcover -l simulation.log src/design/ram_design.sv src/test/interface.sv src/test/ram_package.sv src/test/top_tb.sv
vsim -vopt work.tb -voptargs=+acc=npr -assertdebug -l simulation.log -coverage -c -do "coverage save -onexit -assert -directive -cvg -codeAll coverage.ucdb; run -all; exit"
vcover report -html coverage.ucdb -htmldir covReport -details
