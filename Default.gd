extends Control

onready var note_label = $Note
onready var octave_label = $Octave
onready var freq_label = $Frequency

var recorder_effect
var spectrum_effect


var octave_length = 12
var total_notes = 108
var notes = [ "C","C#","D","D#","E","F","F#","G","G#","A","A#","B" ]
var note_frequencies = [] 

func _ready():
	# We get the index of the "Record" bus.
	var idx = AudioServer.get_bus_index("Record")
	# And use it to retrieve its first effect, which has been defined
	# as an "AudioEffectRecord" resource.
	recorder_effect = AudioServer.get_bus_effect(idx, 0)
	spectrum_effect = AudioServer.get_bus_effect_instance(idx, 1)
	
	
	# Calculate frequencies of all notes here!
	var a = pow (2.0, 1/float(octave_length))
	var ref_freq = 446
	
	for i in range(-57, 51):
		note_frequencies.append(ref_freq * pow(a, i))

func _on_Timer_timeout() -> void:
	var freq = note_frequencies[0]
	var greatest_mag = 0
	
	for i in total_notes-1:
		var mag = spectrum_effect.get_magnitude_for_frequency_range(note_frequencies[i], note_frequencies[min(i+1, total_notes-1)])
		mag = mag.length()
		greatest_mag = max(greatest_mag, mag);
		if greatest_mag == mag:
			note_label.text = notes[i % octave_length]
			octave_label.text = String(floor(i / 12.0))
#			freq_label.text = String(floor(note_frequencies[i] * 100) / 100) + "Hz";
			freq_label.text = String(floor(note_frequencies[i] * 100) / 100) + "Hz";
