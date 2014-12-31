-- Word Buster Base of Operations --

wordBuster.badWords = wordBuster.badWords or {}

function wordBuster.Load()
	MsgC(Color(41, 128, 185), "[Word Buster] Loading languages...\n")
	wordBuster.badWords = {}
	for lang, load in pairs(wordBuster.languages) do
		if load then
			if file.Exists("data/wordbuster/"..lang..".txt", "GAME") then
				local rawData = file.Read("data/wordbuster/"..lang..".txt", "GAME")
				local words = string.Explode("\n", rawData)
				for _, word in pairs(words) do
					local formatedWord = ""
					for _, char in pairs(string.ToTable(word)) do
						if wordBuster.patterns[char] then
							formatedWord = formatedWord..wordBuster.patterns[char]
						else
							formatedWord = formatedWord.."." -- Wildcard if the character isn't a letter
						end
					end
					table.insert(wordBuster.badWords, formatedWord)
				end
				for k, v in pairs(wordBuster.badWords) do
					if v == "" or v == " " then
						table.remove(wordBuster.badWords, k) -- Removes empty filters
					end
				end
			else
				MsgC(Color(41, 128, 185), "[Word Buster] Couldn't load language '"..lang.."', language not found!\n")
			end
		end
	end
	MsgC(Color(41, 128, 185), "[Word Buster] "..table.Count(wordBuster.badWords).." words loaded!\n")
end

wordBuster.Load()

hook.Add("PlayerSay", "WordBuster", function( ply, text, teamChat )
	if wordBuster.whitelist[ply:GetUserGroup()] then return	end -- If the player is a member of a whitelist group we don't do anything
	local total = 0
	for _, word in pairs(wordBuster.badWords) do
		local message, count = string.gsub(text, word, function( s )
			local censored = ""
			local l = 0
			if wordBuster.semiCensor then
				censored = s[1]
				while l < string.len(s) - 2 do
					censored = censored..wordBuster.censor
					l = l + 1
				end
				censored = censored..s[string.len(s)]
			else
				while l < string.len(s) do
					censored = censored..wordBuster.censor
					l = l + 1
				end
			end
			return censored
		end)
		total = total + count
		text = message
	end
	if wordBuster.notify then
		if total > 0 then
			ply:SendLua("chat.AddText(Color(41, 128, 185), '"..wordBuster.notifyText.."')")
		end
	end
	if total > 0 then
		return text
	end
end)

concommand.Add("wordbuster_reload", function( ply )
	if ply:IsSuperAdmin() then
		wordBuster.Load()
	end
end)