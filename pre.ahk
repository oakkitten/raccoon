; Autohotkey preprocessor by arbe

; Syntax: preprocessor.exe [-run] [-deleteLines | -clearLines] scriptPath

#NoEnv

; Check syntax and store variables passed on command line
terminateDueToBadSyntax() {
	msgbox Syntax: preprocessor.exe [-run] [-deleteLines | -clearLines] scriptPath
	exitapp
}

if 0 = 0
	terminateDueToBadSyntax()

Loop %0%
{
	param := %A_Index%
	if param = -run
		followupAction = run
	else if param = -deleteLines	; delete not defined lines instead of out-commenting them (attention: AHK debug messages will not show the same line numbers as in the source files anymore).
		deleteLines := true
	else if param = -clearLines		; does not delete but clear (blank out) undefined lines
		clearLines := true
	else
		scriptPath := param
}

if scriptPath=
	terminateDueToBadSyntax()

IfNotExist %scriptPath%
	terminateDueToBadSyntax()


; recursive main preprocessing function call. Returns the output path of preprocessed script.
preprocess(inPath)
{
	global defines
	global deleteLines
	global clearLines
	
	StringTrimRight outPath, inPath, 4
	outPath = %outPath%.PREPROCESSED.ahk
	
	FileDelete %outPath%
	Loop read, %inPath%, %outPath%
	{
		; strip of comments for internal representation and trim line:
		line := A_LoopReadLine
		temp := InStr(line, ";")
		if temp > 0
			StringLeft line, line, temp-1
		line = %line%
		
		; extract commands:
		indexAfterCommand := InStr(line, A_Space)
		if indexAfterCommand > 0
			StringLeft commandName, A_LoopReadLine, indexAfterCommand-1
		else
			commandName := A_LoopReadLine
		
		StringTrimLeft commandParameter, line, indexAfterCommand
		defineObject=|%commandParameter%|
		
		; check commands
		lineText=;%A_LoopReadLine% ; default for the following commands is blankout
		if commandName = #DEFINE
		{
			IfNotInString defines, defineObject
				defines=%defines%%defineObject%
		}
		else if commandName = #IFDEF
		{
			; check for nested if
			if modeIf
			{
				MsgBox Nested IFDEF not supported by preprocessor.`nLine %A_Index% in %inPath%
				ExitApp
			}
			
			modeIf := true
			modeValue := Instr(defines, defineObject)
		}
		else if commandName = #IFNDEF
		{
			; check for nested if
			if modeIf
			{
				MsgBox Nested IFNDEF not supported by preprocessor.`nLine %A_Index% in %inPath%
				ExitApp
			}
			
			modeIf := true
			modeValue := !Instr(defines, defineObject)
		}
		else if commandName = #ELSE
		{
			; check for bad syntax
			if !modeIf
			{
				MsgBox #ELSE without #IFDEF or #IFNDEF encountered by preprocessor.`nLine %A_Index% in %inPath%
				ExitApp
			}
			
			modeValue:=!modeValue
		}
		else if commandName = #ENDIF
		{
			; check for bad syntax
			if !modeIf
			{
				MsgBox #ENDIF without #IFDEF or #IFNDEF encountered by preprocessor.`nLine %A_Index% in %inPath%
				ExitApp
			}
			
			modeIf := false
		}
		else if commandName = #INCLUDE
		{
			if (modeIf AND !modeValue)	; handle disabled includes via ifdef
				lineText=`;%A_LoopReadLine%
			else
			{
				IfExist %commandParameter%
				{
					temp := preprocess(commandParameter)
					lineText=#INCLUDE %temp%
				}
				else
				{
					MsgBox Include file %commandParameter% not found. Preprocessor does only support absolute pathes.`nLine %A_Index% in %inPath%
					ExitApp
				}
			}
		}
		else
		{
			if (modeIf AND !modeValue)
			{
				if deleteLines
					lineText=#MARKEDFORDELETION
				else if clearLines
					lineText=
				else
					lineText=`;%A_LoopReadLine%
			}
			else
				lineText=%A_LoopReadLine%
		}
		
		if lineText<>#MARKEDFORDELETION
			FileAppend %lineText%`n
	}
	return outPath
}


; parse files and write output recursively (#input)
temp := preprocess(scriptPath)

; if asked for, run next step
if followupAction=run
	Run %temp%