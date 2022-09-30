# understanding how to work with files from Tcl / Vivado
#
# find the location of the current script and adapt it to a filename in the same directory
set script_path [ file dirname [ file normalize [ info script ] ] ]
puts $script_path
set output_file [ file join $script_path regression.txt ]

# write to the file
set output_channel [open $output_file w]
puts $output_channel $output_file
puts $output_channel [clock format [clock seconds]]
close $output_channel