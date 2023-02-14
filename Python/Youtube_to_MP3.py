## Youtube to .MP3
#pip install moviepy
from moviepy.editor import *

# input name file
mp4File = "Huck.mp4"
mp3File = "Huck2.mp3"

audioclip = VideoFileClip(mp4File).audio
audioclip.write_audiofile(mp3File)
