# script to explore how to make a nested dictionary object
set sim_list "sim_1 sim_2"
set results_dict [dict create]

foreach sim $sim_list {
# run the simulaton
	set test_time 120ns
	set test_ok [expr {$sim == "sim_1" ? true : false}]
	set test_result [dict create runtime $test_time test_ok $test_ok]	
	dict append results_dict $sim $test_result	
}

# simplest pretty-print the dictionary
proc pdict {d} {
	dict for {key value} $d {
		puts $key
		puts $value
	}
	
}

pdict $results_dict