FILES = src/design/mcu.v \
	src/design/song_reader.v \
	src/design/note_player.v \
	src/design/sine_reader.v \
	src/design/music_player.v \
	src/sim/mcu_tb.v \
	src/sim/song_reader_tb.v \
	src/sim/note_player_tb.v \
	src/sim/sine_reader_tb.v \
	src/sim/music_player_tb.v \
	src/lab4.xdc \
	lab4.runs/impl_1/lab4_top.bit \
	lab4.runs/impl_1/lab4_top_timing_summary_routed.rpt \
	lab4.runs/synth_1/lab4_top.vds

init:
	@vivado -nolog -nojournal -notrace -mode batch -source init_project.tcl
	@echo "Finished initalizing lab. Run vivado on the generated .xpr file to open the project."

submit:
	@rm -f lab4_submission.zip
	@zip -j lab4_submission.zip $(FILES)
	@echo "Generated lab4_submission.zip. If there are any errors, please check if all of your files are in the right places. Congrats on finishing!"
