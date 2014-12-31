-- Init script for Word Buster --

if SERVER then
	MsgC(Color(41, 128, 185), "[Word Buster] Initializing...\n")

	wordBuster = {}

	include("sv_config.lua")
	include("sv_wordbuster.lua")

	MsgC(Color(41, 128, 185), "[Word Buster] Initialized!\n")
else
	MsgC(Color(41, 128, 185), "This server is using ", Color(192, 57, 43), "Word Buster", Color(41, 128, 185), " (http://facepunch.com/showthread.php?t=XXXXXXX)\n")
end