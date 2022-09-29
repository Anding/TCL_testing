launch_simulation -simset sim_1 -quiet
puts [current_time]
puts [get_value test_ok]
close_sim -quiet

# add_condition to execute TCL during the simulation run
