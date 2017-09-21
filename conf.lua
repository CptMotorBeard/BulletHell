-- Configuration
function love.conf(t)
	t.title = ""
	t.version = "0.10.2"
	t.window.icon = nil
	t.window.resizable = false

	-- Changeable options	
	t.window.width = 1024
	t.window.height = 768
	t.window.borderless = false
	t.window.fullscreen = false
	t.window.vsync = true
	t.window.msaa = 0
	t.window.display = 1
	
	-- Debug purposes only
	t.console = false

	-- Modules
	t.modules.audio = false				-- Enable the audio module (boolean)
	t.modules.event = true				-- Enable the event module (boolean)
	t.modules.graphics = true		 	-- Enable the graphics module (boolean)
	t.modules.image = true			  	-- Enable the image module (boolean)
	t.modules.joystick = false			-- Enable the joystick module (boolean)
	t.modules.keyboard = true			-- Enable the keyboard module (boolean)
	t.modules.math = true				-- Enable the math module (boolean)
	t.modules.mouse = false				-- Enable the mouse module (boolean)
	t.modules.physics = false			-- Enable the physics module (boolean)
	t.modules.sound = false				-- Enable the sound module (boolean)
	t.modules.system = true				-- Enable the system module (boolean)
	t.modules.timer = true				-- Enable the timer module (boolean), Disabling will result 0 delta time in love.update
	t.modules.touch = false				-- Enable the touch module (boolean)
	t.modules.video = false				-- Enable the video module (boolean)
	t.modules.window = true				-- Enable the window module (boolean)
	t.modules.thread = false				-- Enable the thread module (boolean)
end