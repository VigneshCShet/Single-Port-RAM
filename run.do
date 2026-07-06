vlog -sv +acc +cover +fcover -l simulation.log ram_design.sv interface.sv ram_package.sv top_tb.sv
vsim -vopt work.tb -voptargs=+acc=npr -assertdebug -l simulation.log -coverage -c -do "coverage save -onexit -assert -directive -cvg -codeAll coverage.ucdb; run -all; exit"
vcover report -html coverage.ucdb -htmldir covReport -details
