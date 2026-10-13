class_name DynamicParticles2D extends GPUParticles2D


@onready var use_cpu := OS.get_name() == "Web"
@onready var cpu_particles := CPUParticles2D.new()

func _ready() -> void:
	add_child(cpu_particles)
	cpu_particles.convert_from_particles(self)
	cpu_particles.fixed_fps = 0
	cpu_particles.finished.connect(_finished)
	finished.connect(_finished)


# DynamicParticles2D's method overrides are prefixed by "dp_"
func dp_restart() -> void:
	if use_cpu:
		cpu_particles.restart()
	else:
		restart()

signal dp_finished
func _finished() -> void:
	dp_finished.emit()
