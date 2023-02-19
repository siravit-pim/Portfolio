## Google Text to Speed (must online)
#pip install playsound
import playsound
#pip install gTTS
import gtts

# input text and language
mytext = "Hello everyone Python"
language = "en"

# setting sound
gttsObject = gtts.gTTS(text = mytext, tld = "co.uk", lang = language, slow = False)
gttsObject.save("welcome.mp3")

# play mp3 file
playsound.playsound("welcome.mp3")
print("Done !")
