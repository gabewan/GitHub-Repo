Get-Service -ComputerName "102FSCPC011" -Name WinRM | Start-Service
Copy-Item -Path "c:\program files\Videolan" -Destination "\\102fscpc011\c$\Program Files\Videolan" -Force
#Copy-Item -Path "\\102fscpc007\c$\program files\Suprise.mp3" -Destination "\\102fscpc010\c$\program files" -Force
Copy-Item -Path "c$\program files\Oh baby a triple sound effect.mp3" -Destination "\\102fscpc011\c$\program files" -Force
Enter-PSSession -ComputerName "102FSCPC011"


& 'C:\Program Files\VideoLAN\VLC\vlc.exe' --qt-start-minimized --play-and-exit --qt-notification=0 "Oh Baby A triple Sound Effect.mp3"