extends Control

onready var freq_label = $Frequency

var recorder_effect
var spectrum_effect

var definition = 20

var notes = [
	"C0","C#0","D0","D#0","E0","F0","F#0","G0","G#0","A0","A#0","B0",
	"C1","C#1","D1","D#1","E1","F1","F#1","G1","G#1","A1","A#1","B1",
	"C2","C#2","D2","D#2","E2","F2","F#2","G2","G#2","A2","A#2","B2",
	"C3","C#3","D3","D#3","E3","F3","F#3","G3","G#3","A3","A#3","B3",
	"C4","C#4","D4","D#4","E4","F4","F#4","G4","G#4","A4","A#4","B4",
	"C5","C#5","D5","D#5","E5","F5","F#5","G5","G#5","A5","A#5","B5",
	"C6","C#6","D6","D#6","E6","F6","F#6","G6","G#6","A6","A#6","B6",
	"C7","C#7","D7","D#7","E7","F7","F#7","G7","G#7","A7","A#7","B7",
	"C8","C#8","D8","D#8","E8","F8","F#8","G8","G#8","A8","A#8","B8"
]
var note_frequencies = [] 

func _ready():
	# We get the index of the "Record" bus.
	var idx = AudioServer.get_bus_index("Record")
	# And use it to retrieve its first effect, which has been defined
	# as an "AudioEffectRecord" resource.
	recorder_effect = AudioServer.get_bus_effect(idx, 0)
	spectrum_effect = AudioServer.get_bus_effect_instance(idx, 1)
	
	
	# Calculate frequencies of all notes here!
	var a = pow (2.0, 1/12.0)
	var ref_freq = 446
	
	for i in range(-57, 51):
		note_frequencies.append(ref_freq * pow(a, i))

func _on_Timer_timeout() -> void:
	var freq = note_frequencies[0]
	var greatest_mag = 0
	
	for i in notes.size()-1:
		var mag = spectrum_effect.get_magnitude_for_frequency_range(note_frequencies[i], note_frequencies[min(i+1, notes.size()-1)])
		mag = mag.length()
		greatest_mag = max(greatest_mag, mag);
		if greatest_mag == mag:
			freq_label.text = notes[i]
